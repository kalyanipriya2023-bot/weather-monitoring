library;

import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

class AqiGauge extends StatelessWidget {
  final int aqi;
  final String label;

  const AqiGauge({
    super.key,
    required this.aqi,
    required this.label,
  });

  Color _getAqiColor(int value) {
    if (value <= 50) return AppColors.aqiGood;
    if (value <= 100) return AppColors.aqiModerate;
    if (value <= 150) return AppColors.aqiUnhealthySensitive;
    if (value <= 200) return AppColors.aqiUnhealthy;
    if (value <= 300) return AppColors.aqiVeryUnhealthy;
    return AppColors.aqiHazardous;
  }

  @override
  Widget build(BuildContext context) {
    final aqiColor = _getAqiColor(aqi);
    // Normalized value for indicator (max AQI is 500)
    final double normalizedValue = (aqi / 500.0).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  value: normalizedValue,
                  strokeWidth: 10,
                  backgroundColor: Colors.white12,
                  valueColor: AlwaysStoppedAnimation<Color>(aqiColor),
                ),
              ),
              Column(
                children: [
                  Text(
                    '$aqi',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'AQI',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.6),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: aqiColor,
            ),
          ),
        ],
      ),
    );
  }
}
