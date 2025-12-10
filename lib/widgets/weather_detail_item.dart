import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/color_helper.dart';

class WeatherDetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const WeatherDetailItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  /// Obtenir le dégradé de couleur selon le type de détail
  List<Color> _getGradientColors() {
    // Température / Ressenti
    if (icon == FontAwesomeIcons.temperatureHalf) {
      return [
        const Color(0xFFFF6B6B).withOpacity(0.3),
        const Color(0xFFFF8E53).withOpacity(0.2),
      ];
    }
    // Humidité
    else if (icon == FontAwesomeIcons.droplet) {
      return [
        const Color(0xFF4FC3F7).withOpacity(0.3),
        const Color(0xFF29B6F6).withOpacity(0.2),
      ];
    }
    // Vent
    else if (icon == FontAwesomeIcons.wind) {
      return [
        const Color(0xFF81C784).withOpacity(0.3),
        const Color(0xFF66BB6A).withOpacity(0.2),
      ];
    }
    // Pression
    else if (icon == FontAwesomeIcons.gaugeHigh) {
      return [
        const Color(0xFFBA68C8).withOpacity(0.3),
        const Color(0xFFAB47BC).withOpacity(0.2),
      ];
    }
    // Par défaut
    return [
      AppColors.white10,
      AppColors.white10,
    ];
  }

  /// Obtenir la couleur de l'icône selon le type
  Color _getIconColor() {
    if (icon == FontAwesomeIcons.temperatureHalf) {
      return const Color(0xFFFF6B6B);
    } else if (icon == FontAwesomeIcons.droplet) {
      return const Color(0xFF4FC3F7);
    } else if (icon == FontAwesomeIcons.wind) {
      return const Color(0xFF81C784);
    } else if (icon == FontAwesomeIcons.gaugeHigh) {
      return const Color(0xFFBA68C8);
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _getGradientColors(),
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: _getIconColor().withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _getIconColor().withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _getIconColor().withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: FaIcon(
              icon,
              color: _getIconColor(),
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.white80,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
