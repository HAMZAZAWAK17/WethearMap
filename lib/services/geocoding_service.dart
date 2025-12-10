import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeocodingService {
  static const String apiKey = 'AIzaSyDpzM3RwHngFx6Js3qpFEACTT3urCgsEcQ';
  static const String baseUrl = 'https://maps.googleapis.com/maps/api/geocode/json';

  // Base de données de secours pour les villes courantes
  // Utilisée si la Geocoding API n'est pas activée
  static final Map<String, LatLng> _cityDatabase = {
    // Maroc
    'casablanca': LatLng(33.5731, -7.5898),
    'rabat': LatLng(34.0209, -6.8416),
    'marrakech': LatLng(31.6295, -7.9811),
    'fes': LatLng(34.0181, -5.0078),
    'tangier': LatLng(35.7595, -5.8340),
    'agadir': LatLng(30.4278, -9.5981),
    'meknes': LatLng(33.8935, -5.5473),
    'oujda': LatLng(34.6814, -1.9086),
    'kenitra': LatLng(34.2610, -6.5802),
    'tetouan': LatLng(35.5889, -5.3626),
    
    // France
    'paris': LatLng(48.8566, 2.3522),
    'lyon': LatLng(45.7640, 4.8357),
    'marseille': LatLng(43.2965, 5.3698),
    'nice': LatLng(43.7102, 7.2620),
    'bordeaux': LatLng(44.8378, -0.5792),
    'toulouse': LatLng(43.6047, 1.4442),
    'nantes': LatLng(47.2184, -1.5536),
    'strasbourg': LatLng(48.5734, 7.7521),
    'lille': LatLng(50.6292, 3.0573),
    'rennes': LatLng(48.1173, -1.6778),
    
    // Monde
    'london': LatLng(51.5074, -0.1278),
    'new york': LatLng(40.7128, -74.0060),
    'tokyo': LatLng(35.6762, 139.6503),
    'dubai': LatLng(25.2048, 55.2708),
    'madrid': LatLng(40.4168, -3.7038),
    'rome': LatLng(41.9028, 12.4964),
    'berlin': LatLng(52.5200, 13.4050),
    'amsterdam': LatLng(52.3676, 4.9041),
    'barcelona': LatLng(41.3851, 2.1734),
    'lisbon': LatLng(38.7223, -9.1393),
  };

  /// Obtenir les coordonnées d'une ville à partir de son nom
  static Future<LatLng?> getCityCoordinates(String cityName) async {
    try {
      // D'abord, vérifier dans la base de données locale
      final normalizedCity = cityName.toLowerCase().trim();
      if (_cityDatabase.containsKey(normalizedCity)) {
        debugPrint('✅ Ville trouvée dans la base locale: $cityName');
        return _cityDatabase[normalizedCity];
      }

      // Ensuite, essayer avec l'API Google
      final encodedCity = Uri.encodeComponent(cityName);
      final url = Uri.parse('$baseUrl?address=$encodedCity&key=$apiKey');
      
      debugPrint('🔍 Recherche de ville via API: $cityName');
      debugPrint('📡 URL: $url');
      
      final response = await http.get(url);
      debugPrint('📊 Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('📦 Response status: ${data['status']}');
        
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];
          final foundCity = data['results'][0]['formatted_address'];
          debugPrint('✅ Ville trouvée via API: $foundCity');
          debugPrint('📍 Coordonnées: ${location['lat']}, ${location['lng']}');
          return LatLng(location['lat'], location['lng']);
        } else if (data['status'] == 'ZERO_RESULTS') {
          debugPrint('❌ Aucun résultat pour: $cityName');
        } else if (data['status'] == 'REQUEST_DENIED') {
          debugPrint('🚫 Requête refusée - Vérifiez votre clé API');
          debugPrint('💡 Conseil: Activez la Geocoding API dans Google Cloud Console');
          debugPrint('Error message: ${data['error_message']}');
        } else {
          debugPrint('⚠️ Statut inattendu: ${data['status']}');
        }
      } else {
        debugPrint('❌ Erreur HTTP: ${response.statusCode}');
      }
      
      debugPrint('💡 Astuce: Essayez avec une ville de la base locale');
      debugPrint('Villes disponibles: ${_cityDatabase.keys.take(5).join(", ")}...');
      
      return null;
    } catch (e) {
      debugPrint('💥 Erreur lors du géocodage: $e');
      return null;
    }
  }

  /// Obtenir le nom de la ville à partir de coordonnées
  static Future<String?> getCityName(LatLng coordinates) async {
    try {
      final url = Uri.parse(
        '$baseUrl?latlng=${coordinates.latitude},${coordinates.longitude}&key=$apiKey'
      );
      
      debugPrint('🔍 Recherche inverse: ${coordinates.latitude}, ${coordinates.longitude}');
      
      final response = await http.get(url);
      debugPrint('📊 Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('📦 Response status: ${data['status']}');
        
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          // Chercher la localité dans les composants d'adresse
          for (var result in data['results']) {
            for (var component in result['address_components']) {
              if (component['types'].contains('locality')) {
                final cityName = component['long_name'];
                debugPrint('✅ Ville trouvée: $cityName');
                return cityName;
              }
            }
          }
          // Si pas de localité trouvée, retourner le premier résultat formaté
          final address = data['results'][0]['formatted_address'];
          debugPrint('✅ Adresse trouvée: $address');
          return address;
        } else {
          debugPrint('⚠️ Statut: ${data['status']}');
        }
      } else {
        debugPrint('❌ Erreur HTTP: ${response.statusCode}');
      }
      return null;
    } catch (e) {
      debugPrint('💥 Erreur lors du géocodage inverse: $e');
      return null;
    }
  }
}
