library;

import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

class AnimatedGradientBackground extends StatelessWidget {
  final String condition;
  final Widget child;

  const AnimatedGradientBackground({
    super.key,
    required this.condition,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colors = AppColors.getWeatherGradient(condition, isDark: isDark);

    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: child,
    );
  }
}
