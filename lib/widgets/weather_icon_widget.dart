library;

import 'package:flutter/material.dart';

class WeatherIconWidget extends StatefulWidget {
  final String iconUrl;
  final double size;

  const WeatherIconWidget({
    super.key,
    required this.iconUrl,
    this.size = 100,
  });

  @override
  State<WeatherIconWidget> createState() => _WeatherIconWidgetState();
}

class _WeatherIconWidgetState extends State<WeatherIconWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child,
        );
      },
      child: Image.network(
        widget.iconUrl,
        width: widget.size,
        height: widget.size,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            width: widget.size,
            height: widget.size,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.cloud_rounded,
            size: widget.size * 0.8,
            color: Colors.white70,
          );
        },
      ),
    );
  }
}
