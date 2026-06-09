library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/forecast_model.dart';
import 'glass_card.dart';

class ForecastTimeline extends StatelessWidget {
  final List<ForecastModel> hourlyData;

  const ForecastTimeline({
    super.key,
    required this.hourlyData,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: hourlyData.length,
        itemBuilder: (context, index) {
          final item = hourlyData[index];
          final timeStr = DateFormat('h a').format(item.dateTime).toLowerCase();
          final isRainy = item.popPercent > 0;

          return Container(
            width: 80,
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: GlassCard(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              borderRadius: 16,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    timeStr,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),
                  Image.network(
                    item.iconUrl,
                    width: 36,
                    height: 36,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.cloud_rounded,
                      size: 24,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    '${item.temperature.round()}°',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (isRainy)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.water_drop_rounded,
                          size: 10,
                          color: Color(0xFF56CCF2),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${item.popPercent}%',
                          style: const TextStyle(
                            fontSize: 9,
                            color: Color(0xFF56CCF2),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  else
                    const SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
