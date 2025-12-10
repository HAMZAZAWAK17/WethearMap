import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  // IMPORTANT: Remplacez par votre clé API OpenWeatherMap
  static const String apiKey = 'c60bab482b1d4069d6adc6128fa16af2';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  // Obtenir la météo actuelle pour une ville
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

  // Obtenir les prévisions sur 3 jours
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
}
