import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui';
import '../models/weather_model_enhanced.dart';
import '../services/weather_service.dart';
import '../services/storage_service.dart';
import 'modern_weather_screen.dart';

/// Écran de sélection et gestion des villes
class CitiesScreen extends StatefulWidget {
  const CitiesScreen({super.key});

  @override
  State<CitiesScreen> createState() => _CitiesScreenState();
}

class _CitiesScreenState extends State<CitiesScreen>
    with SingleTickerProviderStateMixin {
  List<SavedCity> _savedCities = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadSavedCities();
  }

  void _setupAnimations() {
    _animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animController.forward();
  }

  Future<void> _loadSavedCities() async {
    setState(() => _isLoading = true);

    try {
      // Charger les villes sauvegardées
      final cities = await StorageService.getSavedCities();
      
      // Charger la météo pour chaque ville
      final weatherService = WeatherService();
      final citiesWithWeather = <SavedCity>[];

      for (var city in cities) {
        try {
          final weather = await weatherService.getCurrentWeatherEnhanced(city.name);
          citiesWithWeather.add(SavedCity(
            name: city.name,
            lat: weather.lat,
            lon: weather.lon,
            currentWeather: weather,
            lastUpdated: DateTime.now(),
          ));
        } catch (e) {
          // Garder la ville même si la météo n'a pas pu être chargée
          citiesWithWeather.add(city);
        }
      }

      setState(() {
        _savedCities = citiesWithWeather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addCity(String cityName) async {
    if (cityName.trim().isEmpty) return;

    try {
      final weatherService = WeatherService();
      final weather = await weatherService.getCurrentWeatherEnhanced(cityName);

      final newCity = SavedCity(
        name: weather.cityName,
        lat: weather.lat,
        lon: weather.lon,
        currentWeather: weather,
        lastUpdated: DateTime.now(),
      );

      // Sauvegarder
      final updatedCities = [..._savedCities, newCity];
      await StorageService.saveCities(updatedCities);

      setState(() {
        _savedCities = updatedCities;
      });

      _searchController.clear();
      
      // Afficher un message de succès
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${weather.cityName} ajoutée'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ville non trouvée: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _removeCity(SavedCity city) async {
    final updatedCities = _savedCities.where((c) => c.name != city.name).toList();
    await StorageService.saveCities(updatedCities);

    setState(() {
      _savedCities = updatedCities;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${city.name} supprimée'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1e3c72),
              Color(0xFF2a5298),
              Color(0xFF7e22ce),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 24),
              Expanded(
                child: _isLoading
                    ? _buildLoadingState()
                    : _savedCities.isEmpty
                        ? _buildEmptyState()
                        : _buildCitiesList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const Text(
            'Mes Villes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              onPressed: _loadSavedCities,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            const FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              color: Colors.white70,
              size: 18,
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
                onSubmitted: _addCity,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_rounded, color: Colors.white),
              onPressed: () => _addCity(_searchController.text),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(color: Colors.white),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const FaIcon(
              FontAwesomeIcons.locationDot,
              size: 60,
              color: Colors.white60,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Aucune ville sauvegardée',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Ajoutez une ville pour commencer',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCitiesList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _savedCities.length,
      itemBuilder: (context, index) {
        final city = _savedCities[index];
        return _buildCityCard(city);
      },
    );
  }

  Widget _buildCityCard(SavedCity city) {
    final hasWeather = city.currentWeather != null;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ModernWeatherScreen(
              cityName: city.name,
              lat: city.lat,
              lon: city.lon,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.2),
              Colors.white.withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: hasWeather
            ? Row(
                children: [
                  // Icône météo
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      _getWeatherIcon(city.currentWeather!.condition),
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Infos ville
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          city.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          city.currentWeather!.condition,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Température
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${city.currentWeather!.temperature.round()}°',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        '${city.currentWeather!.tempMax.round()}°/${city.currentWeather!.tempMin.round()}°',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Bouton supprimer
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white70),
                    onPressed: () => _removeCity(city),
                  ),
                ],
              )
            : Row(
                children: [
                  const Icon(Icons.location_city_rounded, color: Colors.white70, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      city.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white70),
                    onPressed: () => _removeCity(city),
                  ),
                ],
              ),
      ),
    );
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'thunderclouds':
      case 'thunderstorm':
        return Icons.thunderstorm_rounded;
      case 'rainy':
      case 'rain':
        return Icons.water_drop_rounded;
      case 'snow':
        return Icons.ac_unit_rounded;
      case 'sunny':
      case 'clear':
        return Icons.wb_sunny_rounded;
      case 'cloudy':
      case 'clouds':
        return Icons.cloud_rounded;
      default:
        return Icons.wb_cloudy_rounded;
    }
  }
}
