import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../models/weather_model_enhanced.dart';

class WeatherService {

  static const String apiKey = 'c60bab482b1d4069d6adc6128fa16af2';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  // ========== ANCIEN MODÈLE (compatibilité) ==========

  Future<WeatherModel> getCurrentWeather(String cityName) async {
    final url = '$baseUrl/weather?q=$cityName&appid=$apiKey&units=metric&lang=fr';
    
    try {
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data, cityName);
      } else {
        throw Exception('Erreur lors de la récupération de la météo');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  Future<ForecastModel> getForecast(String cityName) async {
    final url = '$baseUrl/forecast?q=$cityName&appid=$apiKey&units=metric&lang=fr';
    
    try {
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ForecastModel.fromJson(data);
      } else {
        throw Exception('Erreur lors de la récupération des prévisions');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  // Obtenir la météo par coordonnées
  Future<WeatherModel> getWeatherByCoordinates(double lat, double lon) async {
    final url = '$baseUrl/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=fr';
    
    try {
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherModel.fromJson(data, data['name']);
      } else {
        throw Exception('Erreur lors de la récupération de la météo');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  // Obtenir les prévisions par coordonnées
  Future<ForecastModel> getForecastByCoordinates(double lat, double lon) async {
    final url = '$baseUrl/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=fr';
    
    try {
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ForecastModel.fromJson(data);
      } else {
        throw Exception('Erreur lors de la récupération des prévisions');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  // ========== NOUVEAU MODÈLE ENRICHI ==========

  /// Obtenir la météo actuelle enrichie
  Future<WeatherDataEnhanced> getCurrentWeatherEnhanced(String cityName) async {
    final url = '$baseUrl/weather?q=$cityName&appid=$apiKey&units=metric&lang=fr';
    
    try {
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherDataEnhanced.fromJson(data, cityName);
      } else {
        throw Exception('Erreur lors de la récupération de la météo');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  /// Obtenir les prévisions horaires (aujourd'hui)
  Future<List<HourlyForecast>> getHourlyForecast(String cityName) async {
    final url = '$baseUrl/forecast?q=$cityName&appid=$apiKey&units=metric&lang=fr';
    
    try {
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List forecastList = data['list'];
        final String city = data['city']['name'];
        
        // Prendre les 8 premières prévisions (24 heures, toutes les 3h)
        final hourlyForecasts = <HourlyForecast>[];
        for (int i = 0; i < forecastList.length && i < 8; i++) {
          final weatherData = WeatherDataEnhanced.fromJson(forecastList[i], city);
          hourlyForecasts.add(HourlyForecast.fromWeatherData(weatherData));
        }
        
        return hourlyForecasts;
      } else {
        throw Exception('Erreur lors de la récupération des prévisions horaires');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  /// Obtenir les prévisions sur 7 jours
  Future<List<DailyForecast>> get7DayForecast(String cityName) async {
    final url = '$baseUrl/forecast?q=$cityName&appid=$apiKey&units=metric&lang=fr';
    
    try {
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List forecastList = data['list'];
        final String city = data['city']['name'];
        
        // Grouper par jour et calculer min/max
        final Map<String, List<WeatherDataEnhanced>> dailyData = {};
        
        for (var item in forecastList) {
          final weatherData = WeatherDataEnhanced.fromJson(item, city);
          final dateKey = '${weatherData.dateTime.year}-${weatherData.dateTime.month}-${weatherData.dateTime.day}';
          
          if (!dailyData.containsKey(dateKey)) {
            dailyData[dateKey] = [];
          }
          dailyData[dateKey]!.add(weatherData);
        }
        
        // Créer les prévisions journalières
        final dailyForecasts = <DailyForecast>[];
        
        dailyData.forEach((dateKey, dataList) {
          if (dailyForecasts.length < 7) {
            // Calculer les valeurs moyennes/min/max
            double tempMax = dataList.map((d) => d.tempMax).reduce((a, b) => a > b ? a : b);
            double tempMin = dataList.map((d) => d.tempMin).reduce((a, b) => a < b ? a : b);
            
            // Prendre la condition la plus fréquente ou celle de midi
            final middayData = dataList.firstWhere(
              (d) => d.dateTime.hour >= 12 && d.dateTime.hour <= 15,
              orElse: () => dataList.first,
            );
            
            // Calculer moyennes
            int avgHumidity = (dataList.map((d) => d.humidity).reduce((a, b) => a + b) / dataList.length).round();
            double avgWindSpeed = dataList.map((d) => d.windSpeed).reduce((a, b) => a + b) / dataList.length;
            int avgRainProb = (dataList.map((d) => d.rainProbability).reduce((a, b) => a + b) / dataList.length).round();
            
            dailyForecasts.add(DailyForecast(
              date: dataList.first.dateTime,
              tempMax: tempMax,
              tempMin: tempMin,
              condition: middayData.condition,
              icon: middayData.icon,
              rainProbability: avgRainProb,
              humidity: avgHumidity,
              windSpeed: avgWindSpeed,
            ));
          }
        });
        
        return dailyForecasts;
      } else {
        throw Exception('Erreur lors de la récupération des prévisions 7 jours');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  /// Obtenir la qualité de l'air (Air Quality Index)
  Future<Map<String, dynamic>?> getAirQuality(double lat, double lon) async {
    final url = 'http://api.openweathermap.org/data/2.5/air_pollution?lat=$lat&lon=$lon&appid=$apiKey';
    
    try {
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['list'][0];
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
