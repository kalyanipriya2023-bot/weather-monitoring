library;

import 'package:flutter/material.dart';

class WeatherHelpers {
  WeatherHelpers._();

  static IconData getWeatherIcon(String condition) {
    return switch (condition.toLowerCase()) {
      'clear' => Icons.wb_sunny_rounded,
      'clouds' => Icons.cloud_rounded,
      'rain' || 'drizzle' => Icons.water_drop_rounded,
      'thunderstorm' => Icons.flash_on_rounded,
      'snow' => Icons.ac_unit_rounded,
      'mist' || 'haze' || 'fog' || 'smoke' || 'dust' => Icons.blur_on_rounded,
      _ => Icons.cloud_rounded,
    };
  }

  static String getUvLabel(int uvIndex) {
    if (uvIndex <= 2) return 'Low';
    if (uvIndex <= 5) return 'Moderate';
    if (uvIndex <= 7) return 'High';
    if (uvIndex <= 10) return 'Very High';
    return 'Extreme';
  }

  static Color getUvColor(int uvIndex) {
    if (uvIndex <= 2) return Colors.green;
    if (uvIndex <= 5) return Colors.yellow.shade700;
    if (uvIndex <= 7) return Colors.orange;
    if (uvIndex <= 10) return Colors.red;
    return Colors.purple;
  }

  static Color getAqiColor(int aqi) {
    if (aqi <= 50) return const Color(0xFF4CAF50);
    if (aqi <= 100) return const Color(0xFFFFEB3B);
    if (aqi <= 150) return const Color(0xFFFF9800);
    if (aqi <= 200) return const Color(0xFFF44336);
    if (aqi <= 300) return const Color(0xFF9C27B0);
    return const Color(0xFF800000);
  }

  static String getWindDirection(double degrees) {
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final index = ((degrees + 22.5) / 45).floor() % 8;
    return directions[index];
  }

  static String getWeatherAdvice(String condition) {
    return switch (condition.toLowerCase()) {
      'clear' => 'Perfect day to go outside! Don\'t forget sunscreen.',
      'clouds' => 'Partly cloudy skies. Comfortable weather.',
      'rain' || 'drizzle' => 'Don\'t forget your umbrella!',
      'thunderstorm' => 'Stay indoors if possible. Severe weather.',
      'snow' => 'Bundle up! Dress in warm layers.',
      'mist' || 'fog' => 'Drive carefully, visibility is reduced.',
      'haze' || 'smoke' => 'Consider wearing a mask outdoors.',
      _ => 'Check the forecast for updates.',
    };
  }
}
