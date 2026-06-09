library;

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand Colors
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color primaryCyan = Color(0xFF29B6F6);
  static const Color accentCyan = Color(0xFF00E5FF);
  static const Color primaryPurple = Color(0xFF667eea);
  static const Color accentOrange = Color(0xFFFFB74D);
  static const Color accentGreen = Color(0xFF81C784);

  // Weather Condition Gradients (Dark)
  static const List<Color> clearDark = [Color(0xFF0a1628), Color(0xFF1a237e), Color(0xFF0d47a1)];
  static const List<Color> cloudsDark = [Color(0xFF1a1a2e), Color(0xFF2d3436), Color(0xFF1e272e)];
  static const List<Color> rainDark = [Color(0xFF0c1445), Color(0xFF1a237e), Color(0xFF283593)];
  static const List<Color> stormDark = [Color(0xFF1a0a2e), Color(0xFF2d1b69), Color(0xFF11001c)];
  static const List<Color> snowDark = [Color(0xFF1a2a3a), Color(0xFF2c3e50), Color(0xFF34495e)];
  static const List<Color> mistDark = [Color(0xFF1a1a2e), Color(0xFF2c3e50), Color(0xFF2d3436)];
  static const List<Color> defaultDark = [Color(0xFF0F0C29), Color(0xFF302b63), Color(0xFF24243e)];

  // Weather Condition Gradients (Light)
  static const List<Color> clearLight = [primaryCyan, primaryBlue];
  static const List<Color> cloudsLight = [Color(0xFF8EC5FC), Color(0xFFE0C3FC)];
  static const List<Color> rainLight = [Color(0xFF667eea), Color(0xFF764ba2)];
  static const List<Color> stormLight = [Color(0xFF4a00e0), Color(0xFF8e2de2)];
  static const List<Color> snowLight = [Color(0xFFe0eafc), Color(0xFFcfdef3)];
  static const List<Color> mistLight = [Color(0xFFbdc3c7), Color(0xFF2c3e50)];
  static const List<Color> defaultLight = [Color(0xFF667eea), Color(0xFF764ba2)];

  // Card detail icon colors
  static const Color humidityColor = Color(0xFF4FC3F7);
  static const Color windColor = Color(0xFF81C784);
  static const Color pressureColor = Color(0xFFFFB74D);
  static const Color visibilityColor = Color(0xFFBA68C8);
  static const Color uvColor = Color(0xFFFF7043);
  static const Color aqiColor = Color(0xFF66BB6A);

  // AQI Level Colors
  static const Color aqiGood = Color(0xFF4CAF50);
  static const Color aqiModerate = Color(0xFFFFEB3B);
  static const Color aqiUnhealthySensitive = Color(0xFFFF9800);
  static const Color aqiUnhealthy = Color(0xFFF44336);
  static const Color aqiVeryUnhealthy = Color(0xFF9C27B0);
  static const Color aqiHazardous = Color(0xFF800000);

  // Alert Severity Colors
  static const Color alertLow = Color(0xFF4CAF50);
  static const Color alertMedium = Color(0xFFFF9800);
  static const Color alertHigh = Color(0xFFF44336);
  static const Color alertCritical = Color(0xFF9C27B0);

  /// Returns the gradient colors for a weather condition.
  static List<Color> getWeatherGradient(String condition, {required bool isDark}) {
    final c = condition.toLowerCase();
    if (isDark) {
      return switch (c) {
        'clear' => clearDark,
        'clouds' => cloudsDark,
        'rain' || 'drizzle' => rainDark,
        'thunderstorm' => stormDark,
        'snow' => snowDark,
        'mist' || 'haze' || 'fog' || 'smoke' || 'dust' => mistDark,
        _ => defaultDark,
      };
    } else {
      return switch (c) {
        'clear' => clearLight,
        'clouds' => cloudsLight,
        'rain' || 'drizzle' => rainLight,
        'thunderstorm' => stormLight,
        'snow' => snowLight,
        'mist' || 'haze' || 'fog' || 'smoke' || 'dust' => mistLight,
        _ => defaultLight,
      };
    }
  }
}
