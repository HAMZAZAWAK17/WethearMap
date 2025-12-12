import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Service pour gérer le stockage local des données
class StorageService {
  static const String _favoritesKey = 'favorite_cities';
  static const String _historyKey = 'search_history';
  static const String _themeKey = 'theme_mode';
  static const String _autoLocationKey = 'auto_location';

  /// Obtenir les villes favorites
  static Future<List<String>> getFavoriteCities() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getString(_favoritesKey);
    if (favoritesJson == null) return [];
    
    final List<dynamic> favoritesList = json.decode(favoritesJson);
    return favoritesList.cast<String>();
  }

  /// Ajouter une ville aux favoris
  static Future<bool> addFavoriteCity(String cityName) async {
    final favorites = await getFavoriteCities();
    
    // Vérifier si la ville n'est pas déjà dans les favoris
    if (favorites.contains(cityName)) {
      return false;
    }
    
    favorites.add(cityName);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_favoritesKey, json.encode(favorites));
    return true;
  }

  /// Retirer une ville des favoris
  static Future<bool> removeFavoriteCity(String cityName) async {
    final favorites = await getFavoriteCities();
    
    if (!favorites.contains(cityName)) {
      return false;
    }
    
    favorites.remove(cityName);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_favoritesKey, json.encode(favorites));
    return true;
  }

  /// Vérifier si une ville est dans les favoris
  static Future<bool> isFavorite(String cityName) async {
    final favorites = await getFavoriteCities();
    return favorites.contains(cityName);
  }

  /// Obtenir l'historique de recherche
  static Future<List<String>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_historyKey);
    if (historyJson == null) return [];
    
    final List<dynamic> historyList = json.decode(historyJson);
    return historyList.cast<String>();
  }

  /// Ajouter une recherche à l'historique
  static Future<void> addToHistory(String cityName) async {
    final history = await getSearchHistory();
    
    // Retirer la ville si elle existe déjà (pour la mettre en premier)
    history.remove(cityName);
    
    // Ajouter en premier
    history.insert(0, cityName);
    
    // Limiter l'historique à 10 éléments
    if (history.length > 10) {
      history.removeRange(10, history.length);
    }
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_historyKey, json.encode(history));
  }

  /// Effacer l'historique de recherche
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

  /// Obtenir le mode thème (true = dark, false = light)
  static Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }

  /// Définir le mode thème
  static Future<void> setDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }

  /// Obtenir la préférence de localisation automatique
  static Future<bool> isAutoLocationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_autoLocationKey) ?? false; // Désactivé par défaut pour éviter les erreurs
  }

  /// Définir la préférence de localisation automatique
  static Future<void> setAutoLocationEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoLocationKey, enabled);
  }
}
