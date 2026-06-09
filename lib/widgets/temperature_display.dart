library;

import 'package:flutter/material.dart';

class TemperatureDisplay extends StatelessWidget {
  final double temp;
  final double fontSize;
  final Color? color;

  const TemperatureDisplay({
    super.key,
    required this.temp,
    this.fontSize = 72,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Colors.white;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${temp.round()}',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w200,
            color: effectiveColor,
            height: 1.0,
          ),
        ),
        Text(
          '°',
          style: TextStyle(
            fontSize: fontSize * 0.65,
            fontWeight: FontWeight.w300,
            color: effectiveColor.withValues(alpha: 0.8),
            height: 1.0,
          ),
        ),
        Text(
          'C',
          style: TextStyle(
            fontSize: fontSize * 0.35,
            fontWeight: FontWeight.w400,
            color: effectiveColor.withValues(alpha: 0.6),
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
