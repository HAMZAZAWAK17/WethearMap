import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../utils/color_helper.dart';
import '../services/geocoding_service.dart';
import 'weather_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _mapController;
  final TextEditingController _searchController = TextEditingController();
  final Set<Marker> _markers = {};
  LatLng _currentPosition = const LatLng(48.8566, 2.3522); // Paris par défaut
  bool _isSearching = false;
  MapType _currentMapType = MapType.normal;
  bool _isLoadingLocation = false;

  @override
  void dispose() {
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _addMarker(_currentPosition, "Paris");
  }

  void _addMarker(LatLng position, String title) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId(title),
          position: position,
          infoWindow: InfoWindow(
            title: title,
            snippet: 'Appuyez pour voir la météo',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          onTap: () => _showWeather(title),
        ),
      );
    });
  }

  void _searchCity({bool showWeather = false}) {
    final cityName = _searchController.text.trim();
    if (cityName.isEmpty) {
      _showSnackBar('Veuillez entrer un nom de ville');
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Recherche de coordonnées avec geocoding
    _getCityCoordinates(cityName).then((coordinates) {
      if (coordinates != null) {
        _currentPosition = coordinates;
        _mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: coordinates,
              zoom: 12,
            ),
          ),
        );
        _addMarker(coordinates, cityName);
        
        _showSnackBar('Ville trouvée: $cityName', isSuccess: true);
        
        // Afficher la météo si demandé
        if (showWeather) {
          Future.delayed(const Duration(milliseconds: 500), () {
            _showWeather(cityName);
          });
        }
      } else {
        _showSnackBar(
          'Ville "$cityName" non trouvée. Vérifiez l\'orthographe ou essayez en anglais (ex: Casablanca, Morocco)'
        );
      }
      setState(() {
        _isSearching = false;
      });
    }).catchError((error) {
      setState(() {
        _isSearching = false;
      });
      _showSnackBar('Erreur de recherche. Vérifiez votre connexion Internet');
    });
  }

  Future<LatLng?> _getCityCoordinates(String cityName) async {
    // Utiliser le service de géocodage Google Maps
    final result = await GeocodingService.getCityCoordinates(cityName);
    if (result != null && result['coordinates'] != null) {
      return result['coordinates'] as LatLng;
    }
    return null;
  }

  // Gérer le clic sur la carte
  void _onMapTap(LatLng position) async {
    setState(() {
      _isSearching = true;
    });

    // Obtenir le nom de la ville à partir des coordonnées
    final cityName = await GeocodingService.getCityName(position);
    
    setState(() {
      _isSearching = false;
    });

    if (cityName != null) {
      // Extraire juste le nom de la ville (pas l'adresse complète)
      final cleanCityName = _extractCityName(cityName);
      _addMarker(position, cleanCityName);
      _searchController.text = cleanCityName;
    } else {
      _showSnackBar('Impossible de trouver le nom de cette ville');
    }
  }

  // Extraire le nom de la ville de l'adresse complète
  String _extractCityName(String fullAddress) {
    // Si l'adresse contient une virgule, prendre la première partie
    if (fullAddress.contains(',')) {
      return fullAddress.split(',')[0].trim();
    }
    return fullAddress;
  }

  void _showWeather(String cityName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WeatherPage(cityName: cityName),
      ),
    );
  }

  // Obtenir la localisation actuelle de l'utilisateur
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      // Vérifier les permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnackBar('Permission de localisation refusée');
          setState(() {
            _isLoadingLocation = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnackBar('Permission de localisation refusée définitivement');
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      // Obtenir la position actuelle
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      LatLng userLocation = LatLng(position.latitude, position.longitude);
      
      // Obtenir le nom de la ville
      final cityName = await GeocodingService.getCityName(userLocation);
      
      if (cityName != null) {
        final cleanCityName = _extractCityName(cityName);
        
        // Animer la caméra vers la position
        _mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: userLocation,
              zoom: 14,
            ),
          ),
        );
        
        // Ajouter le marqueur
        _addMarker(userLocation, cleanCityName);
        _searchController.text = cleanCityName;
        _currentPosition = userLocation;
        
        _showSnackBar('Localisation trouvée: $cleanCityName', isSuccess: true);
        
        // Afficher automatiquement la météo après un court délai
        Future.delayed(const Duration(milliseconds: 800), () {
          _showWeather(cleanCityName);
        });
      } else {
        _showSnackBar('Impossible de déterminer votre ville');
      }
    } catch (e) {
      _showSnackBar('Erreur lors de la localisation: ${e.toString()}');
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  // Changer le type de carte
  void _changeMapType(MapType type) {
    setState(() {
      _currentMapType = type;
    });
  }

  void _showSnackBar(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green.shade400 : Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            onMapCreated: _onMapCreated,
            onTap: _onMapTap,
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 12,
            ),
            markers: _markers,
            mapType: _currentMapType,
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),

          // Barre de recherche en haut
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  _buildQuickCities(),
                ],
              ),
            ),
          ),

          // Bouton retour
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 16),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF1e3c72)),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),

          // Bouton de localisation
          Positioned(
            right: 16,
            bottom: 200,
            child: FloatingActionButton(
              heroTag: 'location_btn',
              onPressed: _isLoadingLocation ? null : _getCurrentLocation,
              backgroundColor: Colors.white,
              child: _isLoadingLocation
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1e3c72)),
                      ),
                    )
                  : const FaIcon(
                      FontAwesomeIcons.locationCrosshairs,
                      color: Color(0xFF1e3c72),
                    ),
            ),
          ),

          // Boutons de type de carte
          Positioned(
            right: 16,
            bottom: 80,
            child: Column(
              children: [
                _buildMapTypeButton(
                  'Normal',
                  FontAwesomeIcons.map,
                  MapType.normal,
                ),
                const SizedBox(height: 8),
                _buildMapTypeButton(
                  'Satellite',
                  FontAwesomeIcons.satellite,
                  MapType.satellite,
                ),
                const SizedBox(height: 8),
                _buildMapTypeButton(
                  'Terrain',
                  FontAwesomeIcons.mountain,
                  MapType.terrain,
                ),
                const SizedBox(height: 8),
                _buildMapTypeButton(
                  'Hybride',
                  FontAwesomeIcons.layerGroup,
                  MapType.hybrid,
                ),
              ],
            ),
          ),

          // Indicateur de chargement lors du géocodage
          if (_isSearching)
            Container(
              color: Colors.black26,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black20,
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1e3c72)),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Recherche de la ville...',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.black20,
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) => _searchCity(),
              decoration: InputDecoration(
                hintText: 'Rechercher une ville...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: FaIcon(FontAwesomeIcons.magnifyingGlass, size: 20),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
          ),
          if (_isSearching)
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Bouton pour afficher la météo directement
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.cloudSun,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  onPressed: () => _searchCity(showWeather: true),
                  tooltip: 'Voir la météo',
                ),
                const SizedBox(width: 4),
                // Bouton pour rechercher sur la carte
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1e3c72), Color(0xFF7e22ce)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.arrowRight,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  onPressed: _searchCity,
                  tooltip: 'Rechercher',
                ),
                const SizedBox(width: 8),
              ],
            ),
        ],
      ),
    );
  }


  Widget _buildQuickCities() {
    final cities = ['Paris', 'Lyon', 'Marseille', 'Nice', 'Bordeaux'];
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: cities.map((city) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                _searchController.text = city;
                _searchCity();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black10,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.locationDot,
                      size: 14,
                      color: Color(0xFF7e22ce),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      city,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1e3c72),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMapTypeButton(String label, IconData icon, MapType type) {
    final isSelected = _currentMapType == type;
    
    return Tooltip(
      message: label,
      child: GestureDetector(
        onTap: () => _changeMapType(type),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1e3c72) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: isSelected 
                    ? const Color.fromRGBO(30, 60, 114, 0.4)
                    : AppColors.black10,
                blurRadius: isSelected ? 15 : 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: FaIcon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF1e3c72),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
