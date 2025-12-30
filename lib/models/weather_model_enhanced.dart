/// Modèle de données météo enrichi pour l'application premium
class WeatherDataEnhanced {
  final String cityName;
  final double temperature;
  final String condition; // "Thunderclouds", "Rainy", "Cloudy", "Sunny", etc.
  final String description;
  final String icon;
  
  // Détails météo
  final double feelsLike;
  final int humidity;
  final double pressure;
  final double windSpeed;
  final String windDirection;
  final int rainProbability;
  final double? rainVolume;
  
  // Températures
  final double tempMin;
  final double tempMax;
  
  // Qualité de l'air
  final int? aqi; // Air Quality Index
  final String? aqiLevel; // "Good", "Moderate", "Unhealthy", etc.
  
  // Soleil
  final DateTime? sunrise;
  final DateTime? sunset;
  
  // Alertes
  final List<WeatherAlert> alerts;
  
  // Date et heure
  final DateTime dateTime;
  
  // Coordonnées
  final double? lat;
  final double? lon;

  WeatherDataEnhanced({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.description,
    required this.icon,
    required this.feelsLike,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.windDirection,
    required this.rainProbability,
    this.rainVolume,
    required this.tempMin,
    required this.tempMax,
    this.aqi,
    this.aqiLevel,
    this.sunrise,
    this.sunset,
    this.alerts = const [],
    required this.dateTime,
    this.lat,
    this.lon,
  });

  factory WeatherDataEnhanced.fromJson(Map<String, dynamic> json, String city) {
    // Extraction des données de base
    final main = json['main'];
    final weather = json['weather'][0];
    final wind = json['wind'];
    final sys = json['sys'];
    
    // Calcul de la probabilité de pluie (si disponible)
    int rainProb = 0;
    if (json.containsKey('pop')) {
      rainProb = (json['pop'] * 100).toInt();
    } else if (json.containsKey('rain')) {
      rainProb = 80; // Estimation si pluie détectée
    }
    
    // Volume de pluie
    double? rainVol;
    if (json.containsKey('rain') && json['rain'] is Map) {
      rainVol = json['rain']['1h']?.toDouble() ?? json['rain']['3h']?.toDouble();
    }
    
    // Direction du vent
    String windDir = _getWindDirection(wind['deg']?.toDouble() ?? 0);
    
    // Condition météo traduite
    String condition = _translateCondition(weather['main'], weather['description']);
    
    return WeatherDataEnhanced(
      cityName: city,
      temperature: main['temp'].toDouble(),
      condition: condition,
      description: weather['description'],
      icon: weather['icon'],
      feelsLike: main['feels_like'].toDouble(),
      humidity: main['humidity'],
      pressure: main['pressure'].toDouble(),
      windSpeed: wind['speed'].toDouble(),
      windDirection: windDir,
      rainProbability: rainProb,
      rainVolume: rainVol,
      tempMin: main['temp_min'].toDouble(),
      tempMax: main['temp_max'].toDouble(),
      sunrise: sys['sunrise'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(sys['sunrise'] * 1000)
          : null,
      sunset: sys['sunset'] != null
          ? DateTime.fromMillisecondsSinceEpoch(sys['sunset'] * 1000)
          : null,
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      lat: json['coord']?['lat']?.toDouble(),
      lon: json['coord']?['lon']?.toDouble(),
    );
  }
  
  static String _translateCondition(String main, String description) {
    switch (main.toLowerCase()) {
      case 'thunderstorm':
        return 'Thunderclouds';
      case 'drizzle':
      case 'rain':
        return 'Rainy';
      case 'snow':
        return 'Snow';
      case 'clear':
        return 'Sunny';
      case 'clouds':
        if (description.contains('few')) return 'Partly Cloudy';
        if (description.contains('scattered')) return 'Cloudy';
        return 'Overcast';
      case 'mist':
      case 'fog':
        return 'Foggy';
      default:
        return main;
    }
  }
  
  static String _getWindDirection(double degree) {
    if (degree >= 337.5 || degree < 22.5) return 'N';
    if (degree >= 22.5 && degree < 67.5) return 'NE';
    if (degree >= 67.5 && degree < 112.5) return 'E';
    if (degree >= 112.5 && degree < 157.5) return 'SE';
    if (degree >= 157.5 && degree < 202.5) return 'S';
    if (degree >= 202.5 && degree < 247.5) return 'SW';
    if (degree >= 247.5 && degree < 292.5) return 'W';
    return 'NW';
  }
}

/// Modèle pour les alertes météo
class WeatherAlert {
  final String title;
  final String description;
  final String severity; // "Extreme", "Severe", "Moderate", "Minor"
  final DateTime start;
  final DateTime end;

  WeatherAlert({
    required this.title,
    required this.description,
    required this.severity,
    required this.start,
    required this.end,
  });

  factory WeatherAlert.fromJson(Map<String, dynamic> json) {
    return WeatherAlert(
      title: json['event'] ?? 'Weather Alert',
      description: json['description'] ?? '',
      severity: json['severity'] ?? 'Moderate',
      start: DateTime.fromMillisecondsSinceEpoch(json['start'] * 1000),
      end: DateTime.fromMillisecondsSinceEpoch(json['end'] * 1000),
    );
  }
}

/// Modèle pour les prévisions horaires
class HourlyForecast {
  final DateTime time;
  final double temperature;
  final String icon;
  final String condition;
  final int rainProbability;

  HourlyForecast({
    required this.time,
    required this.temperature,
    required this.icon,
    required this.condition,
    required this.rainProbability,
  });

  factory HourlyForecast.fromWeatherData(WeatherDataEnhanced data) {
    return HourlyForecast(
      time: data.dateTime,
      temperature: data.temperature,
      icon: data.icon,
      condition: data.condition,
      rainProbability: data.rainProbability,
    );
  }
}

/// Modèle pour les prévisions journalières (7 jours)
class DailyForecast {
  final DateTime date;
  final double tempMax;
  final double tempMin;
  final String condition;
  final String icon;
  final int rainProbability;
  final int humidity;
  final double windSpeed;

  DailyForecast({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.condition,
    required this.icon,
    required this.rainProbability,
    required this.humidity,
    required this.windSpeed,
  });

  String get dayName {
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[date.weekday % 7];
  }
  
  String get dayNameFr {
    final days = ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam'];
    return days[date.weekday % 7];
  }
}

/// Modèle pour une ville sauvegardée
class SavedCity {
  final String name;
  final double? lat;
  final double? lon;
  final WeatherDataEnhanced? currentWeather;
  final DateTime? lastUpdated;

  SavedCity({
    required this.name,
    this.lat,
    this.lon,
    this.currentWeather,
    this.lastUpdated,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lat': lat,
      'lon': lon,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  factory SavedCity.fromJson(Map<String, dynamic> json) {
    return SavedCity(
      name: json['name'],
      lat: json['lat'],
      lon: json['lon'],
      lastUpdated: json['lastUpdated'] != null 
          ? DateTime.parse(json['lastUpdated'])
          : null,
    );
  }
}
