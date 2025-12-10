import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WeatherHelper {
  // Obtenir l'icône appropriée selon le code météo (design moderne et amélioré)
  static IconData getWeatherIcon(String iconCode) {
    switch (iconCode) {
      case '01d': // Soleil clair - jour
        return FontAwesomeIcons.solidSun;
      case '01n': // Nuit claire
        return FontAwesomeIcons.solidMoon;
      case '02d': // Peu nuageux - jour
        return FontAwesomeIcons.cloudSun;
      case '02n': // Peu nuageux - nuit
        return FontAwesomeIcons.cloudMoon;
      case '03d': // Nuages épars - jour
        return FontAwesomeIcons.cloud;
      case '03n': // Nuages épars - nuit
        return FontAwesomeIcons.solidCloud;
      case '04d': // Nuageux - jour
        return FontAwesomeIcons.solidCloud;
      case '04n': // Nuageux - nuit
        return FontAwesomeIcons.solidCloud;
      case '09d': // Pluie légère - jour
      case '09n': // Pluie légère - nuit
        return FontAwesomeIcons.cloudShowersHeavy;
      case '10d': // Pluie - jour
        return FontAwesomeIcons.cloudSunRain;
      case '10n': // Pluie - nuit
        return FontAwesomeIcons.cloudMoonRain;
      case '11d': // Orage - jour
      case '11n': // Orage - nuit
        return FontAwesomeIcons.cloudBolt;
      case '13d': // Neige - jour
      case '13n': // Neige - nuit
        return FontAwesomeIcons.solidSnowflake;
      case '50d': // Brouillard - jour
      case '50n': // Brouillard - nuit
        return FontAwesomeIcons.smog;
      default:
        return FontAwesomeIcons.cloudSun;
    }
  }

  // Obtenir la couleur de fond selon la météo
  static List<Color> getWeatherGradient(String iconCode, bool isDark) {
    if (isDark) {
      switch (iconCode) {
        case '01d':
        case '01n':
          return [const Color(0xFF1a1a2e), const Color(0xFF16213e)];
        case '02d':
        case '02n':
          return [const Color(0xFF0f2027), const Color(0xFF203a43)];
        case '03d':
        case '03n':
        case '04d':
        case '04n':
          return [const Color(0xFF2c3e50), const Color(0xFF3498db)];
        case '09d':
        case '09n':
        case '10d':
        case '10n':
          return [const Color(0xFF141e30), const Color(0xFF243b55)];
        case '11d':
        case '11n':
          return [const Color(0xFF000000), const Color(0xFF434343)];
        case '13d':
        case '13n':
          return [const Color(0xFF304352), const Color(0xFFd7d2cc)];
        case '50d':
        case '50n':
          return [const Color(0xFF606c88), const Color(0xFF3f4c6b)];
        default:
          return [const Color(0xFF1a1a2e), const Color(0xFF16213e)];
      }
    } else {
      switch (iconCode) {
        case '01d':
        case '01n':
          return [const Color(0xFF56CCF2), const Color(0xFF2F80ED)];
        case '02d':
        case '02n':
          return [const Color(0xFF4facfe), const Color(0xFF00f2fe)];
        case '03d':
        case '03n':
        case '04d':
        case '04n':
          return [const Color(0xFF667eea), const Color(0xFF764ba2)];
        case '09d':
        case '09n':
        case '10d':
        case '10n':
          return [const Color(0xFF4e54c8), const Color(0xFF8f94fb)];
        case '11d':
        case '11n':
          return [const Color(0xFF2c3e50), const Color(0xFF4ca1af)];
        case '13d':
        case '13n':
          return [const Color(0xFFe0eafc), const Color(0xFFcfdef3)];
        case '50d':
        case '50n':
          return [const Color(0xFFbdc3c7), const Color(0xFF2c3e50)];
        default:
          return [const Color(0xFF56CCF2), const Color(0xFF2F80ED)];
      }
    }
  }

  // Obtenir la couleur de l'icône
  static Color getIconColor(String iconCode) {
    switch (iconCode) {
      case '01d':
      case '01n':
        return const Color(0xFFFFD700);
      case '02d':
      case '02n':
        return const Color(0xFFFFE066);
      case '03d':
      case '03n':
      case '04d':
      case '04n':
        return const Color(0xFFB0C4DE);
      case '09d':
      case '09n':
      case '10d':
      case '10n':
        return const Color(0xFF4682B4);
      case '11d':
      case '11n':
        return const Color(0xFFFFD700);
      case '13d':
      case '13n':
        return const Color(0xFFFFFFFF);
      case '50d':
      case '50n':
        return const Color(0xFF708090);
      default:
        return const Color(0xFFFFFFFF);
    }
  }

  // Formater la date
  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dayAfterTomorrow = today.add(const Duration(days: 2));
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return "Aujourd'hui";
    } else if (dateToCheck == tomorrow) {
      return "Demain";
    } else if (dateToCheck == dayAfterTomorrow) {
      return "Après-demain";
    } else {
      final weekdays = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
      return weekdays[date.weekday - 1];
    }
  }

  // Obtenir le nom du jour
  static String getDayName(DateTime date) {
    final weekdays = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'];
    return weekdays[date.weekday - 1];
  }
}
