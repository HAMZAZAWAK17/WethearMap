import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../models/weather_model_enhanced.dart';
import '../services/weather_service.dart';
import '../utils/weather_icons.dart';
import '../providers/theme_provider.dart';

/// Onglet Map - Google Maps avec météo interactive
class MapTab extends StatefulWidget {
  const MapTab({super.key});

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> with AutomaticKeepAliveClientMixin {
  GoogleMapController? _mapController;
  LatLng _currentPosition = const LatLng(48.8566, 2.3522); // Paris par défaut
  WeatherDataEnhanced? _selectedLocationWeather;
  bool _isLoadingWeather = false;
  bool _showWeatherCard = false;
  String? _selectedCityName;
  MapType _currentMapType = MapType.normal;
  
  // Recherche de ville
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchResults = false;
  List<String> _searchResults = [];
  
  // Villes populaires pour suggestions
  final List<Map<String, dynamic>> _popularCities = [
    {'name': 'Paris', 'lat': 48.8566, 'lon': 2.3522},
    {'name': 'London', 'lat': 51.5074, 'lon': -0.1278},
    {'name': 'New York', 'lat': 40.7128, 'lon': -74.0060},
    {'name': 'Tokyo', 'lat': 35.6762, 'lon': 139.6503},
    {'name': 'Dubai', 'lat': 25.2048, 'lon': 55.2708},
    {'name': 'Madrid', 'lat': 40.4168, 'lon': -3.7038},
    {'name': 'Rome', 'lat': 41.9028, 'lon': 12.4964},
    {'name': 'Berlin', 'lat': 52.5200, 'lon': 13.4050},
    {'name': 'Casablanca', 'lat': 33.5731, 'lon': -7.5898},
    {'name': 'Rabat', 'lat': 34.0209, 'lon': -6.8416},
    {'name': 'Amsterdam', 'lat': 52.3676, 'lon': 4.9041},
    {'name': 'Barcelona', 'lat': 41.3851, 'lon': 2.1734},
    {'name': 'Lisbon', 'lat': 38.7223, 'lon': -9.1393},
    {'name': 'Moscow', 'lat': 55.7558, 'lon': 37.6173},
    {'name': 'Cairo', 'lat': 30.0444, 'lon': 31.2357},
  ];

  @override
  bool get wantKeepAlive => true;
  
  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Scaffold(
      body: Stack(
        children: [
          // Google Maps - Entièrement interactive
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 10,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              _updateMapTheme();
            },
            onTap: _onMapTapped,
            mapType: _currentMapType,
            
            // Activer TOUTES les interactions
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,        // ✅ Zoom
            scrollGesturesEnabled: true,      // ✅ Scroll/Pan
            tiltGesturesEnabled: true,        // ✅ Tilt
            rotateGesturesEnabled: true,      // ✅ Rotation
            mapToolbarEnabled: false,
            compassEnabled: true,
            
            // Limites de zoom
            minMaxZoomPreference: const MinMaxZoomPreference(2, 20),
          ),
          
          // Header avec recherche
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildHeader(),
          ),
          
          // Boutons flottants
          Positioned(
            bottom: _showWeatherCard ? 280 : 120,
            right: 16,
            child: Column(
              children: [
                _buildMapTypeButton(),
                const SizedBox(height: 12),
                _buildMyLocationButton(),
              ],
            ),
          ),
          
          // Weather card
          if (_showWeatherCard && _selectedLocationWeather != null)
            Positioned(
              bottom: 100,
              left: 16,
              right: 16,
              child: _buildWeatherCard(),
            ),
          
          // Loading indicator
          if (_isLoadingWeather)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildLoadingIndicator(),
            ),
        ],
      ),
    );
  }

  void _updateMapTheme() {
    if (_mapController == null) return;
    
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.isDarkMode;
    
    if (isDark && _currentMapType == MapType.normal) {
      _setDarkMapStyle();
    } else if (!isDark && _currentMapType == MapType.normal) {
      _mapController?.setMapStyle(null); // Style par défaut
    }
  }

  void _setDarkMapStyle() {
    const String darkMapStyle = '''
    [
      {"elementType": "geometry", "stylers": [{"color": "#212121"}]},
      {"elementType": "labels.icon", "stylers": [{"visibility": "off"}]},
      {"elementType": "labels.text.fill", "stylers": [{"color": "#757575"}]},
      {"elementType": "labels.text.stroke", "stylers": [{"color": "#212121"}]},
      {"featureType": "administrative", "elementType": "geometry", "stylers": [{"color": "#757575"}]},
      {"featureType": "administrative.country", "elementType": "labels.text.fill", "stylers": [{"color": "#9e9e9e"}]},
      {"featureType": "administrative.locality", "elementType": "labels.text.fill", "stylers": [{"color": "#bdbdbd"}]},
      {"featureType": "poi", "elementType": "labels.text.fill", "stylers": [{"color": "#757575"}]},
      {"featureType": "poi.park", "elementType": "geometry", "stylers": [{"color": "#181818"}]},
      {"featureType": "road", "elementType": "geometry.fill", "stylers": [{"color": "#2c2c2c"}]},
      {"featureType": "road", "elementType": "labels.text.fill", "stylers": [{"color": "#8a8a8a"}]},
      {"featureType": "road.arterial", "elementType": "geometry", "stylers": [{"color": "#373737"}]},
      {"featureType": "road.highway", "elementType": "geometry", "stylers": [{"color": "#3c3c3c"}]},
      {"featureType": "water", "elementType": "geometry", "stylers": [{"color": "#000000"}]},
      {"featureType": "water", "elementType": "labels.text.fill", "stylers": [{"color": "#3d3d3d"}]}
    ]
    ''';
    
    _mapController?.setMapStyle(darkMapStyle);
  }

  Future<void> _onMapTapped(LatLng position) async {
    setState(() {
      _currentPosition = position;
      _isLoadingWeather = true;
      _showWeatherCard = false;
      _showSearchResults = false;
    });

    try {
      // Trouver la ville la plus proche dans notre liste
      String cityName = _findNearestCity(position);

      // Obtenir la météo
      final weatherService = WeatherService();
      final weather = await weatherService.getCurrentWeatherEnhanced(cityName);

      if (mounted) {
        setState(() {
          _selectedLocationWeather = weather;
          _selectedCityName = cityName;
          _showWeatherCard = true;
          _isLoadingWeather = false;
        });

        // Animer la caméra vers la position
        _mapController?.animateCamera(
          CameraUpdate.newLatLng(position),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingWeather = false;
        });
        
        _showErrorSnackBar('Impossible de charger la météo');
      }
    }
  }

  String _findNearestCity(LatLng position) {
    double minDistance = double.infinity;
    String nearestCity = 'Paris';

    for (var city in _popularCities) {
      final cityLat = city['lat'] as double;
      final cityLon = city['lon'] as double;
      
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        cityLat,
        cityLon,
      );

      if (distance < minDistance) {
        minDistance = distance;
        nearestCity = city['name'] as String;
      }
    }

    return nearestCity;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Réessayer',
          textColor: Colors.white,
          onPressed: () => _onMapTapped(_currentPosition),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.8),
            Colors.black.withOpacity(0.6),
            Colors.transparent,
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.magnifyingGlass,
                      color: Colors.white70,
                      size: 16,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        decoration: const InputDecoration(
                          hintText: 'Rechercher une ville...',
                          hintStyle: TextStyle(color: Colors.white60),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              _showSearchResults = false;
                              _searchResults = [];
                            } else {
                              _showSearchResults = true;
                              _searchResults = _popularCities
                                  .where((city) => city['name']
                                      .toString()
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                  .map((city) => city['name'] as String)
                                  .toList();
                            }
                          });
                        },
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            _searchCity(value);
                          }
                        },
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white70, size: 20),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _showSearchResults = false;
                            _searchResults = [];
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),
            
            // Résultats de recherche
            if (_showSearchResults && _searchResults.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                constraints: const BoxConstraints(maxHeight: 250),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final cityName = _searchResults[index];
                    return ListTile(
                      leading: const Icon(Icons.location_city_rounded, color: Color(0xFF56CCF2), size: 20),
                      title: Text(
                        cityName,
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      onTap: () {
                        _searchCity(cityName);
                        setState(() {
                          _showSearchResults = false;
                          _searchController.clear();
                        });
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _searchCity(String cityName) async {
    setState(() {
      _isLoadingWeather = true;
      _showWeatherCard = false;
    });

    try {
      // Trouver la ville dans la liste
      final city = _popularCities.firstWhere(
        (c) => c['name'].toString().toLowerCase() == cityName.toLowerCase(),
        orElse: () => {},
      );

      if (city.isEmpty) {
        throw Exception('Ville non trouvée');
      }

      final position = LatLng(city['lat'], city['lon']);

      // Animer la caméra vers la ville
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(position, 12),
      );

      // Charger la météo
      await _onMapTapped(position);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingWeather = false;
        });
        
        _showErrorSnackBar('Ville non trouvée');
      }
    }
  }

  Widget _buildMapTypeButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF56CCF2), Color(0xFF2F80ED)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2F80ED).withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showMapTypeDialog(),
          borderRadius: BorderRadius.circular(16),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Icon(
              Icons.layers_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  void _showMapTypeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        title: const Text(
          'Type de carte',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMapTypeOption('Normal', MapType.normal, Icons.map),
            _buildMapTypeOption('Satellite', MapType.satellite, Icons.satellite_alt),
            _buildMapTypeOption('Terrain', MapType.terrain, Icons.terrain),
            _buildMapTypeOption('Hybride', MapType.hybrid, Icons.layers),
          ],
        ),
      ),
    );
  }

  Widget _buildMapTypeOption(String label, MapType type, IconData icon) {
    final isSelected = _currentMapType == type;
    
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? const Color(0xFF56CCF2) : Colors.white70,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? const Color(0xFF56CCF2) : Colors.white,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: Color(0xFF56CCF2))
          : null,
      onTap: () {
        setState(() {
          _currentMapType = type;
          _updateMapTheme();
        });
        Navigator.pop(context);
      },
    );
  }

  Widget _buildMyLocationButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF56CCF2), Color(0xFF2F80ED)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2F80ED).withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _goToMyLocation,
          borderRadius: BorderRadius.circular(16),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Icon(
              Icons.my_location_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _goToMyLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showErrorSnackBar('Activez la localisation');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showErrorSnackBar('Permission refusée');
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition();
      final latLng = LatLng(position.latitude, position.longitude);

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(latLng, 14),
      );

      await _onMapTapped(latLng);
    } catch (e) {
      _showErrorSnackBar('Erreur de localisation');
    }
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 12),
          Text(
            'Chargement...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherCard() {
    final weather = _selectedLocationWeather!;
    final isNight = DateTime.now().hour < 6 || DateTime.now().hour > 20;
    final gradientColors = WeatherIcons.getBackgroundGradient(weather.condition, isNight);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      _selectedCityName ?? weather.cityName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _showWeatherCard = false;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Météo principale
            Row(
              children: [
                Icon(
                  WeatherIcons.getIcon(weather.condition),
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${weather.temperature.round()}°',
                        style: const TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        weather.condition,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Détails
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMiniDetail(FontAwesomeIcons.wind, '${weather.windSpeed.round()} km/h'),
                  _buildMiniDetail(FontAwesomeIcons.droplet, '${weather.humidity}%'),
                  _buildMiniDetail(FontAwesomeIcons.cloudRain, '${weather.rainProbability}%'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniDetail(IconData icon, String value) {
    return Row(
      children: [
        FaIcon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
