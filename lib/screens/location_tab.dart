import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:ui';
import '../models/weather_model_enhanced.dart';
import '../services/weather_service.dart';
import '../services/geocoding_service.dart';
import '../utils/weather_icons.dart';

/// Onglet Location - Météo basée sur la position actuelle
class LocationTab extends StatefulWidget {
  const LocationTab({super.key});

  @override
  State<LocationTab> createState() => _LocationTabState();
}

class _LocationTabState extends State<LocationTab> with AutomaticKeepAliveClientMixin {
  WeatherDataEnhanced? _currentWeather;
  List<HourlyForecast> _hourlyForecasts = [];
  List<DailyForecast> _dailyForecasts = [];
  bool _isLoading = true;
  bool _isRefreshing = false;
  String? _error;
  String? _currentCityName;
  Position? _currentPosition;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadCurrentLocationWeather();
  }

  Future<void> _loadCurrentLocationWeather() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Vérifier les permissions
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Les services de localisation sont désactivés');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Permission de localisation refusée');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Permission de localisation refusée définitivement');
      }

      // Obtenir la position actuelle
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
      });

      // Obtenir le nom de la ville
      final cityName = await GeocodingService.getCityNameFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Obtenir la météo
      final weatherService = WeatherService();
      final currentData = await weatherService.getCurrentWeatherEnhanced(cityName);
      final hourlyData = await weatherService.getHourlyForecast(cityName);
      final dailyData = await weatherService.get7DayForecast(cityName);

      if (mounted) {
        setState(() {
          _currentCityName = cityName;
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
    await _loadCurrentLocationWeather();
    setState(() => _isRefreshing = false);
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_searching_rounded,
              color: Colors.white,
              size: 64,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Localisation en cours...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Obtention de votre position',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 32),
          const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 3,
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
                Icons.location_off_rounded,
                color: Colors.white70,
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Erreur de localisation',
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
              onPressed: _loadCurrentLocationWeather,
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
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
                  Icons.my_location_rounded,
                  color: Color(0xFF56CCF2),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ma Position',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _currentCityName ?? _currentWeather?.cityName ?? 'Chargement...',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        if (_isRefreshing)
          Container(
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
          AnimatedWeatherIcon(
            condition: _currentWeather!.condition,
            size: 160,
          ),
          const SizedBox(height: 24),
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
