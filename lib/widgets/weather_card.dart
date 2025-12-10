import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/weather_model.dart';
import '../utils/weather_helper.dart';
import '../utils/color_helper.dart';

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white15,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.white30,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black10,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Date
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  WeatherHelper.formatDate(weather.date),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  weather.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.white80,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Icône météo
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white20,
              shape: BoxShape.circle,
            ),
            child: FaIcon(
              WeatherHelper.getWeatherIcon(weather.icon),
              color: WeatherHelper.getIconColor(weather.icon),
              size: 30,
            ),
          ),

          const SizedBox(width: 20),

          // Température
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${weather.temperature.round()}°',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.arrowDown,
                    size: 10,
                    color: AppColors.white70,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${weather.tempMin.round()}°',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.white70,
                    ),
                  ),
                  const SizedBox(width: 8),
                  FaIcon(
                    FontAwesomeIcons.arrowUp,
                    size: 10,
                    color: AppColors.white70,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${weather.tempMax.round()}°',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
