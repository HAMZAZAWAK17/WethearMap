import 'package:flutter/material.dart';

/// Classe utilitaire pour obtenir les icônes météo personnalisées
class WeatherIcons {
  /// Obtenir l'icône correspondant à la condition météo
  static IconData getIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'thunderclouds':
      case 'thunderstorm':
        return Icons.thunderstorm_rounded;
      case 'rainy':
      case 'rain':
      case 'drizzle':
        return Icons.water_drop_rounded;
      case 'snow':
      case 'slow':
        return Icons.ac_unit_rounded;
      case 'sunny':
      case 'clear':
        return Icons.wb_sunny_rounded;
      case 'partly cloudy':
        return Icons.wb_cloudy_rounded;
      case 'cloudy':
      case 'clouds':
      case 'overcast':
        return Icons.cloud_rounded;
      case 'foggy':
      case 'mist':
      case 'fog':
        return Icons.cloud_queue_rounded;
      case 'storm':
        return Icons.flash_on_rounded;
      default:
        return Icons.wb_cloudy_rounded;
    }
  }

  /// Obtenir la couleur de l'icône selon la condition
  static Color getIconColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'thunderclouds':
      case 'thunderstorm':
      case 'storm':
        return const Color(0xFFFFD700); // Jaune doré pour l'éclair
      case 'rainy':
      case 'rain':
      case 'drizzle':
        return const Color(0xFF64B5F6); // Bleu clair
      case 'snow':
      case 'slow':
        return const Color(0xFFE3F2FD); // Blanc bleuté
      case 'sunny':
      case 'clear':
        return const Color(0xFFFFA726); // Orange soleil
      case 'partly cloudy':
        return const Color(0xFFB0BEC5); // Gris clair
      case 'cloudy':
      case 'clouds':
      case 'overcast':
        return const Color(0xFF90A4AE); // Gris
      case 'foggy':
      case 'mist':
      case 'fog':
        return const Color(0xFFCFD8DC); // Gris très clair
      default:
        return Colors.white70;
    }
  }

  /// Obtenir le gradient de fond selon la condition et l'heure
  static List<Color> getBackgroundGradient(String condition, bool isNight) {
    if (isNight) {
      // Gradients de nuit
      switch (condition.toLowerCase()) {
        case 'thunderclouds':
        case 'thunderstorm':
        case 'storm':
          return [
            const Color(0xFF1a1a2e),
            const Color(0xFF16213e),
            const Color(0xFF0f3460),
          ];
        case 'rainy':
        case 'rain':
          return [
            const Color(0xFF2c3e50),
            const Color(0xFF34495e),
            const Color(0xFF4a5f7f),
          ];
        case 'clear':
        case 'sunny':
          return [
            const Color(0xFF0f2027),
            const Color(0xFF203a43),
            const Color(0xFF2c5364),
          ];
        default:
          return [
            const Color(0xFF1e1e2e),
            const Color(0xFF2d2d44),
            const Color(0xFF3a3a52),
          ];
      }
    } else {
      // Gradients de jour
      switch (condition.toLowerCase()) {
        case 'thunderclouds':
        case 'thunderstorm':
        case 'storm':
          return [
            const Color(0xFF2c3e50),
            const Color(0xFF34495e),
            const Color(0xFF4a5f7f),
          ];
        case 'rainy':
        case 'rain':
        case 'drizzle':
          return [
            const Color(0xFF4b6cb7),
            const Color(0xFF5a7fc4),
            const Color(0xFF6991d1),
          ];
        case 'snow':
          return [
            const Color(0xFFe0eafc),
            const Color(0xFFcfdef3),
            const Color(0xFFb8d0ea),
          ];
        case 'sunny':
        case 'clear':
          return [
            const Color(0xFF56CCF2),
            const Color(0xFF2F80ED),
            const Color(0xFF1e3c72),
          ];
        case 'partly cloudy':
          return [
            const Color(0xFF667eea),
            const Color(0xFF764ba2),
            const Color(0xFF8e54e9),
          ];
        case 'cloudy':
        case 'clouds':
        case 'overcast':
          return [
            const Color(0xFF757F9A),
            const Color(0xFF8892a6),
            const Color(0xFF9ba5b3),
          ];
        default:
          return [
            const Color(0xFF56CCF2),
            const Color(0xFF2F80ED),
            const Color(0xFF1e3c72),
          ];
      }
    }
  }

  /// Obtenir l'emoji correspondant à la condition
  static String getEmoji(String condition) {
    switch (condition.toLowerCase()) {
      case 'thunderclouds':
      case 'thunderstorm':
      case 'storm':
        return '⛈️';
      case 'rainy':
      case 'rain':
        return '🌧️';
      case 'drizzle':
        return '🌦️';
      case 'snow':
      case 'slow':
        return '❄️';
      case 'sunny':
      case 'clear':
        return '☀️';
      case 'partly cloudy':
        return '⛅';
      case 'cloudy':
      case 'clouds':
      case 'overcast':
        return '☁️';
      case 'foggy':
      case 'mist':
      case 'fog':
        return '🌫️';
      default:
        return '🌤️';
    }
  }
}

/// Widget pour afficher une icône météo animée
class AnimatedWeatherIcon extends StatefulWidget {
  final String condition;
  final double size;
  final bool animate;

  const AnimatedWeatherIcon({
    super.key,
    required this.condition,
    this.size = 120,
    this.animate = true,
  });

  @override
  State<AnimatedWeatherIcon> createState() => _AnimatedWeatherIconState();
}

class _AnimatedWeatherIconState extends State<AnimatedWeatherIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.animate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: WeatherIcons.getIconColor(widget.condition).withOpacity(0.3),
              blurRadius: 30,
              spreadRadius: 10,
            ),
          ],
        ),
        child: Icon(
          WeatherIcons.getIcon(widget.condition),
          size: widget.size * 0.7,
          color: WeatherIcons.getIconColor(widget.condition),
        ),
      ),
    );
  }
}

/// Widget pour créer une icône météo 3D avec effet de glassmorphism
class GlassmorphicWeatherIcon extends StatelessWidget {
  final String condition;
  final double size;

  const GlassmorphicWeatherIcon({
    super.key,
    required this.condition,
    this.size = 150,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 3),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          WeatherIcons.getIcon(condition),
          size: size * 0.5,
          color: WeatherIcons.getIconColor(condition),
        ),
      ),
    );
  }
}
