import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'geocoding_service.dart';

/// Service pour gérer la localisation de l'utilisateur
class LocationService {
  /// Vérifier si les services de localisation sont activés
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Vérifier les permissions de localisation
  static Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Demander les permissions de localisation
  static Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Obtenir la position actuelle de l'utilisateur
  /// Retourne un Map avec 'position' (LatLng) et 'cityName' (String)
  static Future<Map<String, dynamic>?> getCurrentLocation() async {
    try {
      // Vérifier si le service de localisation est activé
      bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('❌ Service de localisation désactivé');
        return null;
      }

      // Vérifier les permissions
      LocationPermission permission = await checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('❌ Permission de localisation refusée');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('❌ Permission de localisation refusée définitivement');
        return null;
      }

      // Obtenir la position
      debugPrint('📍 Obtention de la position...');
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      debugPrint('✅ Position obtenue: ${position.latitude}, ${position.longitude}');

      LatLng userLocation = LatLng(position.latitude, position.longitude);

      // Obtenir le nom de la ville
      final cityName = await GeocodingService.getCityName(userLocation);
      
      if (cityName != null) {
        // Extraire juste le nom de la ville
        final cleanCityName = _extractCityName(cityName);
        debugPrint('✅ Ville trouvée: $cleanCityName');
        
        return {
          'position': userLocation,
          'cityName': cleanCityName,
          'fullAddress': cityName,
        };
      } else {
        debugPrint('⚠️ Impossible de déterminer le nom de la ville');
        return {
          'position': userLocation,
          'cityName': 'Position actuelle',
          'fullAddress': 'Lat: ${position.latitude}, Lng: ${position.longitude}',
        };
      }
    } catch (e) {
      debugPrint('💥 Erreur lors de l\'obtention de la localisation: $e');
      return null;
    }
  }

  /// Extraire le nom de la ville de l'adresse complète
  static String _extractCityName(String fullAddress) {
    if (fullAddress.contains(',')) {
      return fullAddress.split(',')[0].trim();
    }
    return fullAddress;
  }

  /// Obtenir la distance entre deux positions (en kilomètres)
  static double getDistanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    ) / 1000; // Convertir en km
  }

  /// Vérifier si l'utilisateur a accordé les permissions
  static Future<bool> hasPermission() async {
    final permission = await checkPermission();
    return permission == LocationPermission.always ||
           permission == LocationPermission.whileInUse;
  }

  /// Ouvrir les paramètres de localisation
  static Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  /// Ouvrir les paramètres d'application
  static Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }
}
