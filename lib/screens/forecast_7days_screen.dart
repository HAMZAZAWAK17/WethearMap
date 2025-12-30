import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui';
import '../models/weather_model_enhanced.dart';
import '../utils/weather_icons.dart';
import '../services/weather_service.dart';

/// Écran des prévisions 7 jours - Design moderne inspiré de l'image
class Forecast7DaysScreen extends StatefulWidget {
  final String cityName;

  const Forecast7DaysScreen({
    super.key,
    required this.cityName,
  });

  @override
  State<Forecast7DaysScreen> createState() => _Forecast7DaysScreenState();
}

class _Forecast7DaysScreenState extends State<Forecast7DaysScreen>
    with SingleTickerProviderStateMixin {
  List<DailyForecast> _dailyForecasts = [];
  DailyForecast? _selectedDay;
  bool _isLoading = true;
  String? _error;

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadForecastData();
  }

  void _setupAnimations() {
    _animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );
  }

  Future<void> _loadForecastData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final weatherService = WeatherService();
      final forecasts = await weatherService.get7DayForecast(widget.cityName);

      setState(() {
        _dailyForecasts = forecasts;
        _selectedDay = forecasts.isNotEmpty ? forecasts[0] : null;
        _isLoading = false;
      });

      _animController.forward();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNight = DateTime.now().hour < 6 || DateTime.now().hour > 20;
    final gradientColors = _selectedDay != null
        ? WeatherIcons.getBackgroundGradient(_selectedDay!.condition, isNight)
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
                  : _buildForecastContent(),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 20),
          Text(
            'Loading forecast...',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.white70, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Erreur de chargement',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? 'Erreur inconnue',
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadForecastData,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastContent() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildSelectedDayCard(),
          const SizedBox(height: 24),
          _buildWeekForecastList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
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
          
          // Title
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.calendar_month_rounded, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  '7 days',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          // More options
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedDayCard() {
    if (_selectedDay == null) return const SizedBox.shrink();

    final isToday = _selectedDay!.date.day == DateTime.now().day;
    final isTomorrow = _selectedDay!.date.day == DateTime.now().add(const Duration(days: 1)).day;

    String dayLabel = _selectedDay!.dayNameFr;
    if (isToday) dayLabel = 'Aujourd\'hui';
    if (isTomorrow) dayLabel = 'Tomorrow';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.25),
              Colors.white.withOpacity(0.15),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Day label
            Text(
              dayLabel,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // Weather icon and temperature
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    WeatherIcons.getIcon(_selectedDay!.condition),
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 24),
                
                // Temperature
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_selectedDay!.tempMax.round()}°/${_selectedDay!.tempMin.round()}°',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      _selectedDay!.condition,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Details row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMiniDetail(
                  FontAwesomeIcons.wind,
                  '${_selectedDay!.windSpeed.round()} km/h',
                  'Wind',
                ),
                _buildMiniDetail(
                  FontAwesomeIcons.droplet,
                  '${_selectedDay!.humidity}%',
                  'Humidity',
                ),
                _buildMiniDetail(
                  FontAwesomeIcons.cloudRain,
                  '${_selectedDay!.rainProbability}%',
                  'Rain',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniDetail(IconData icon, String value, String label) {
    return Column(
      children: [
        FaIcon(icon, color: Colors.white70, size: 18),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildWeekForecastList() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              itemCount: _dailyForecasts.length,
              itemBuilder: (context, index) {
                final forecast = _dailyForecasts[index];
                final isSelected = _selectedDay == forecast;
                final isToday = index == 0;
                
                return _buildDayForecastItem(forecast, isSelected, isToday);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayForecastItem(DailyForecast forecast, bool isSelected, bool isToday) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDay = forecast;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF56CCF2), Color(0xFF2F80ED)],
                )
              : null,
          color: isSelected ? null : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(isSelected ? 0.4 : 0.15),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Day name
            SizedBox(
              width: 50,
              child: Text(
                isToday ? 'Mon' : forecast.dayNameFr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Weather icon
            Icon(
              WeatherIcons.getIcon(forecast.condition),
              color: Colors.white,
              size: 32,
            ),
            
            const SizedBox(width: 16),
            
            // Condition
            Expanded(
              child: Text(
                forecast.condition,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            
            // Temperature range
            Text(
              '+${forecast.tempMax.round()}° +${forecast.tempMin.round()}°',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
