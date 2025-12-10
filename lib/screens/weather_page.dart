import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../utils/weather_helper.dart';
import '../utils/color_helper.dart';
import '../widgets/weather_card.dart';
import '../widgets/weather_detail_item.dart';
import '../widgets/animated_weather_icon.dart';
import 'package:shimmer/shimmer.dart';


class WeatherPage extends StatefulWidget {
  final String cityName;

  const WeatherPage({super.key, required this.cityName});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherService _weatherService = WeatherService();
  WeatherModel? _currentWeather;
  List<WeatherModel>? _forecasts;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  Future<void> _loadWeatherData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final current = await _weatherService.getCurrentWeather(widget.cityName);
      final forecast = await _weatherService.getForecast(widget.cityName);
      
      setState(() {
        _currentWeather = current;
        _forecasts = forecast.getDailyForecasts();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? _buildLoadingState()
          : _error != null
              ? _buildErrorState()
              : _buildWeatherContent(),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1e3c72), Color(0xFF7e22ce)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Shimmer.fromColors(
                      baseColor: AppColors.white30,
                      highlightColor: AppColors.white50,
                      child: const FaIcon(
                        FontAwesomeIcons.cloudSun,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Chargement de la météo...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1e3c72), Color(0xFF7e22ce)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.triangleExclamation,
                        size: 80,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Erreur de chargement',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Vérifiez votre clé API OpenWeatherMap',
                        style: TextStyle(
                          color: AppColors.white80,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton.icon(
                        onPressed: _loadWeatherData,
                        icon: const FaIcon(FontAwesomeIcons.arrowsRotate, size: 18),
                        label: const Text('Réessayer'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF1e3c72),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherContent() {
    if (_currentWeather == null) return const SizedBox();

    final gradientColors = WeatherHelper.getWeatherGradient(
      _currentWeather!.icon,
      false,
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildCurrentWeather(),
                      const SizedBox(height: 30),
                      _buildWeatherDetails(),
                      const SizedBox(height: 30),
                      _buildForecastSection(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.white20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const Spacer(),
          if (!_isLoading && _currentWeather != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _currentWeather!.cityName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  WeatherHelper.getDayName(DateTime.now()),
                  style: TextStyle(
                    color: AppColors.white80,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          const SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: AppColors.white20,
            child: IconButton(
              icon: const FaIcon(FontAwesomeIcons.arrowsRotate, 
                color: Colors.white, size: 18),
              onPressed: _loadWeatherData,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentWeather() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: AppColors.white15,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.white30,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black10,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          AnimatedWeatherIcon(
            icon: WeatherHelper.getWeatherIcon(_currentWeather!.icon),
            color: WeatherHelper.getIconColor(_currentWeather!.icon),
            size: 100,
            animate: true,
          ),
          const SizedBox(height: 20),
          Text(
            '${_currentWeather!.temperature.round()}°',
            style: const TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _currentWeather!.description.toUpperCase(),
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              letterSpacing: 2,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Min ${_currentWeather!.tempMin.round()}° • Max ${_currentWeather!.tempMax.round()}°',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.white80,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white15,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: AppColors.white30,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Détails',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: WeatherDetailItem(
                  icon: FontAwesomeIcons.temperatureHalf,
                  label: 'Ressenti',
                  value: '${_currentWeather!.feelsLike.round()}°',
                ),
              ),
              Expanded(
                child: WeatherDetailItem(
                  icon: FontAwesomeIcons.droplet,
                  label: 'Humidité',
                  value: '${_currentWeather!.humidity}%',
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: WeatherDetailItem(
                  icon: FontAwesomeIcons.wind,
                  label: 'Vent',
                  value: '${_currentWeather!.windSpeed.round()} km/h',
                ),
              ),
              Expanded(
                child: WeatherDetailItem(
                  icon: FontAwesomeIcons.gaugeHigh,
                  label: 'Pression',
                  value: '${_currentWeather!.pressure.round()} hPa',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildForecastSection() {
    if (_forecasts == null || _forecasts!.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            'Prévisions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 15),
        ..._forecasts!.map((forecast) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: WeatherCard(weather: forecast),
        )),
      ],
    );
  }
}
