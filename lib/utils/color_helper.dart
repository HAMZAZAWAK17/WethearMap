import 'package:flutter/material.dart';

/// Helper pour créer des couleurs avec opacité
Color colorWithOpacity(Color color, double opacity) {
  return color.withValues(alpha: opacity);
}

/// Couleurs prédéfinies avec opacité pour l'application
class AppColors {
  // Blanc avec différentes opacités
  static Color white10 = Colors.white.withValues(alpha: 0.1);
  static Color white15 = Colors.white.withValues(alpha: 0.15);
  static Color white20 = Colors.white.withValues(alpha: 0.2);
  static Color white30 = Colors.white.withValues(alpha: 0.3);
  static Color white50 = Colors.white.withValues(alpha: 0.5);
  static Color white70 = Colors.white.withValues(alpha: 0.7);
  static Color white80 = Colors.white.withValues(alpha: 0.8);
  static Color white90 = Colors.white.withValues(alpha: 0.9);
  
  // Noir avec différentes opacités
  static Color black10 = Colors.black.withValues(alpha: 0.1);
  static Color black20 = Colors.black.withValues(alpha: 0.2);
  static Color black30 = Colors.black.withValues(alpha: 0.3);
  static Color black50 = Colors.black.withValues(alpha: 0.5);
}
