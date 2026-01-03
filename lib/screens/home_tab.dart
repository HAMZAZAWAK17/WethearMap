import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui';
import '../models/weather_model_enhanced.dart';
import '../services/weather_service.dart';
import '../utils/weather_icons.dart';
import '../services/storage_service.dart';

/// Onglet Home - Météo principale de la ville sélectionnée
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
  WeatherDataEnhanced? _currentWeather;
  List<HourlyForecast> _hourlyForecasts = [];
  List<DailyForecast> _dailyForecasts = [];
  bool _isLoading = true;
  bool _isRefreshing = false;
  String? _error;
  String _selectedCity = 'Paris'; // Ville par défaut
  
  // Recherche de ville
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchBar = false;
  bool _showSearchResults = false;
  List<String> _searchResults = [];
  
  // Villes populaires pour suggestions
  final List<String> _popularCities = [
    'Paris', 'London', 'New York', 'Tokyo', 'Dubai',
    'Madrid', 'Rome', 'Berlin', 'Casablanca', 'Rabat',
    'Amsterdam', 'Barcelona', 'Lisbon', 'Moscow', 'Cairo',
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadLastCity();
    _loadWeatherData();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadLastCity() async {
    final cities = await StorageService.getSavedCities();
    if (cities.isNotEmpty) {
      setState(() {
        _selectedCity = cities.first.name;
      });
    }
  }

  Future<void> _loadWeatherData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final weatherService = WeatherService();
      
      final currentData = await weatherService.getCurrentWeatherEnhanced(_selectedCity);
      final hourlyData = await weatherService.getHourlyForecast(_selectedCity);
      final dailyData = await weatherService.get7DayForecast(_selectedCity);

      if (mounted) {
        setState(() {
          _currentWeather = currentData;
          _hourlyForecasts = hourlyData;
          _dailyForecasts = dailyData;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshWeather() async {
    setState(() => _isRefreshing = true);
    await _loadWeatherData();
    setState(() => _isRefreshing = false);
  }

  Future<void> _showCitySelector() async {
    final cities = await StorageService.getSavedCities();
    
    if (!mounted) return;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildCitySelector(cities),
    );
  }

  Widget _buildCitySelector(List<SavedCity> cities) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF1a1a2e).withOpacity(0.98),
            const Color(0xFF16213e),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Sélectionner une ville',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: cities.length,
              itemBuilder: (context, index) {
                final city = cities[index];
                final isSelected = city.name == _selectedCity;
                
                return ListTile(
                  leading: Icon(
                    Icons.location_city_rounded,
                    color: isSelected ? const Color(0xFF56CCF2) : Colors.white70,
                  ),
                  title: Text(
                    city.name,
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
                      _selectedCity = city.name;
                    });
                    Navigator.pop(context);
                    _loadWeatherData();
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    final isNight = DateTime.now().hour < 6 || DateTime.now().hour > 20;
    final gradientColors = _currentWeather != null
        ? WeatherIcons.getBackgroundGradient(_currentWeather!.condition, isNight)
        : [const Color(0xFF1e3c72), const Color(0xFF2a5298), const Color(0xFF7e22ce)];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors,
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? _buildLoadingState()
              : _error != null
                  ? _buildErrorState()
                  : _buildWeatherContent(),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 3,
          ),
          SizedBox(height: 20),
          Text(
            'Chargement...',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                color: Colors.white70,
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Erreur de chargement',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _error ?? 'Erreur inconnue',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _loadWeatherData,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF56CCF2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherContent() {
    return RefreshIndicator(
      onRefresh: _refreshWeather,
      color: const Color(0xFF56CCF2),
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 30),
              _buildMainWeatherCard(),
              const SizedBox(height: 24),
              _buildWeatherDetails(),
              const SizedBox(height: 32),
              _buildSectionTitle('Aujourd\'hui', 'Prévisions horaires'),
              const SizedBox(height: 16),
              _buildHourlyForecast(),
              const SizedBox(height: 32),
              _buildSectionTitle('Cette semaine', '7 jours'),
              const SizedBox(height: 16),
              _buildDailyForecast(),
              const SizedBox(height: 100), // Espace pour la bottom nav
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    if (_showSearchBar) {
      return Column(
        children: [
          // Barre de recherche
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.search_rounded,
                  color: Colors.white70,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
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
                              .where((city) => city
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        }
                      });
                    },
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        _selectCity(value);
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                  onPressed: () {
                    setState(() {
                      _showSearchBar = false;
                      _showSearchResults = false;
                      _searchController.clear();
                    });
                  },
                ),
              ],
            ),
          ),
          
          // Résultats de recherche
          if (_showSearchResults && _searchResults.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 12),
              constraints: const BoxConstraints(maxHeight: 250),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
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
                    leading: const Icon(
                      Icons.location_city_rounded,
                      color: Color(0xFF56CCF2),
                      size: 20,
                    ),
                    title: Text(
                      cityName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    onTap: () => _selectCity(cityName),
                  );
                },
              ),
            ),
        ],
      );
    }
    
    // Header normal
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // City name
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _currentWeather?.cityName ?? _selectedCity,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(width: 12),
        
        // Search button
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: IconButton(
            icon: const Icon(Icons.search_rounded, color: Colors.white),
            onPressed: () {
              setState(() {
                _showSearchBar = true;
              });
            },
          ),
        ),
        
        // Refresh indicator
        if (_isRefreshing)
          Container(
            margin: const EdgeInsets.only(left: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
  
  void _selectCity(String cityName) {
    setState(() {
      _selectedCity = cityName;
      _showSearchBar = false;
      _showSearchResults = false;
      _searchController.clear();
    });
    _loadWeatherData();
  }

  Widget _buildMainWeatherCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.25),
            Colors.white.withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          // Icône météo 3D
          AnimatedWeatherIcon(
            condition: _currentWeather!.condition,
            size: 160,
          ),
          const SizedBox(height: 24),
          
          // Température
          Text(
            '${_currentWeather!.temperature.round()}°',
            style: const TextStyle(
              fontSize: 96,
              fontWeight: FontWeight.w200,
              color: Colors.white,
              height: 1,
              letterSpacing: -4,
            ),
          ),
          const SizedBox(height: 12),
          
          // Condition
          Text(
            _currentWeather!.condition,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          
          // Min/Max
          Text(
            'Max: ${_currentWeather!.tempMax.round()}° • Min: ${_currentWeather!.tempMin.round()}°',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetails() {
    return Row(
      children: [
        Expanded(
          child: _buildDetailCard(
            icon: FontAwesomeIcons.wind,
            value: '${_currentWeather!.windSpeed.round()}',
            unit: 'km/h',
            label: 'Vent',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildDetailCard(
            icon: FontAwesomeIcons.droplet,
            value: '${_currentWeather!.humidity}',
            unit: '%',
            label: 'Humidité',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildDetailCard(
            icon: FontAwesomeIcons.cloudRain,
            value: '${_currentWeather!.rainProbability}',
            unit: '%',
            label: 'Pluie',
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String value,
    required String unit,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          FaIcon(icon, color: Colors.white70, size: 24),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 2),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  unit,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildHourlyForecast() {
    if (_hourlyForecasts.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _hourlyForecasts.length,
        itemBuilder: (context, index) {
          final forecast = _hourlyForecasts[index];
          final isNow = index == 0;
          
          return Container(
            width: 90,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              gradient: isNow
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF56CCF2), Color(0xFF2F80ED)],
                    )
                  : null,
              color: isNow ? null : Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(isNow ? 0.4 : 0.2),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isNow ? 'Maintenant' : '${forecast.time.hour}:00',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: isNow ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                Icon(
                  WeatherIcons.getIcon(forecast.condition),
                  color: Colors.white,
                  size: 36,
                ),
                Text(
                  '${forecast.temperature.round()}°',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDailyForecast() {
    if (_dailyForecasts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: _dailyForecasts.take(7).map((forecast) {
        final isToday = forecast.date.day == DateTime.now().day;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 70,
                child: Text(
                  isToday ? 'Aujourd\'hui' : forecast.dayNameFr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                WeatherIcons.getIcon(forecast.condition),
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  forecast.condition,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                '${forecast.tempMax.round()}° / ${forecast.tempMin.round()}°',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
