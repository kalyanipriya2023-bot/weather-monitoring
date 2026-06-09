library;

import 'package:flutter/material.dart';
import '../models/weather_alert_model.dart';

class AlertBanner extends StatelessWidget {
  final WeatherAlertModel alert;
  final VoidCallback? onTap;

  const AlertBanner({
    super.key,
    required this.alert,
    this.onTap,
  });

  Color _getSeverityColor(AlertSeverity severity) {
    return switch (severity) {
      AlertSeverity.low => const Color(0xFF81C784),
      AlertSeverity.medium => const Color(0xFFFFB74D),
      AlertSeverity.high => const Color(0xFFE57373),
      AlertSeverity.critical => const Color(0xFFD32F2F),
    };
  }

  IconData _getAlertIcon(AlertType type) {
    return switch (type) {
      AlertType.heatWave => Icons.wb_sunny_rounded,
      AlertType.cold => Icons.ac_unit_rounded,
      AlertType.storm => Icons.thunderstorm_rounded,
      AlertType.rain => Icons.water_drop_rounded,
      AlertType.snow => Icons.ac_unit_rounded,
      AlertType.highWind => Icons.air_rounded,
      AlertType.poorAqi => Icons.warning_amber_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = _getSeverityColor(alert.severity);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ListTile(
          onTap: onTap,
          leading: CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.2),
            child: Icon(_getAlertIcon(alert.alertType), color: color),
          ),
          title: Row(
            children: [
              Text(
                alert.alertType.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  alert.severity.name.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              alert.message,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white70,
              ),
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right_rounded,
            color: Colors.white54,
          ),
        ),
      ),
    );
  }
}
