import 'package:flutter/material.dart';
import '../services/storage_service.dart';

/// Provider pour gérer le thème de l'application
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  /// Charger le thème depuis le stockage
  Future<void> _loadTheme() async {
    _isDarkMode = await StorageService.isDarkMode();
    notifyListeners();
  }

  /// Basculer entre le mode sombre et clair
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await StorageService.setDarkMode(_isDarkMode);
    notifyListeners();
  }

  /// Définir le thème
  Future<void> setTheme(bool isDark) async {
    _isDarkMode = isDark;
    await StorageService.setDarkMode(isDark);
    notifyListeners();
  }

  /// Obtenir le ThemeData pour le mode clair
  ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      fontFamily: 'Roboto',
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1e3c72),
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.grey[50],
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1e3c72),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  /// Obtenir le ThemeData pour le mode sombre
  ThemeData get darkTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      fontFamily: 'Roboto',
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1e3c72),
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1e1e1e),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        color: const Color(0xFF1e1e1e),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  /// Obtenir le thème actuel
  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;
}
