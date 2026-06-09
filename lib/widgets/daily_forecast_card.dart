library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/forecast_model.dart';
import 'glass_card.dart';

class DailyForecastCard extends StatelessWidget {
  final DailyForecast forecast;
  final VoidCallback? onTap;

  const DailyForecastCard({
    super.key,
    required this.forecast,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dayName = DateFormat('EEEE').format(forecast.date);
    final dateStr = DateFormat('MMM d').format(forecast.date);
    final isRainy = forecast.maxPop > 0;

    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        borderRadius: 18,
        child: Row(
          children: [
            // Date section
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dayName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateStr,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),

            // Icon + POP
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Image.network(
                    'https://openweathermap.org/img/wn/${forecast.iconCode}@2x.png',
                    width: 40,
                    height: 40,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.cloud_rounded,
                      size: 24,
                      color: Colors.white70,
                    ),
                  ),
                  if (isRainy)
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.water_drop_rounded,
                            size: 12,
                            color: Color(0xFF56CCF2),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${(forecast.maxPop * 100).round()}%',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF56CCF2),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const Spacer(),
                ],
              ),
            ),

            // Temp Min/Max
            Expanded(
              flex: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Min Temp
                  Text(
                    '${forecast.tempMin.round()}°',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Temperature Bar
                  Container(
                    width: 50,
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF56CCF2), Color(0xFFFFB74D)],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Max Temp
                  Text(
                    '${forecast.tempMax.round()}°',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
