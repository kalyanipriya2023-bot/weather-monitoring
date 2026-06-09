/// Weather Monitoring App — Entry Point
///
/// A beautiful Flutter weather app that uses the OpenWeatherMap API
/// to display current weather conditions with Material 3 design,
/// dark/light theme support, and glassmorphic UI.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/app_router.dart';
import 'themes/app_theme.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/weather_provider.dart';
import 'providers/forecast_provider.dart';
import 'providers/city_provider.dart';
import 'providers/alert_provider.dart';

void main() async {
  // Ensure Flutter bindings are initialized before using platform channels
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait mode for optimal layout
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style for immersive experience
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()..checkAuthStatus()),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ChangeNotifierProvider(create: (_) => ForecastProvider()),
        ChangeNotifierProvider(create: (_) => CityProvider()),
        ChangeNotifierProvider(create: (_) => AlertProvider()),
      ],
      child: const WeatherMonitoringApp(),
    ),
  );
}

class WeatherMonitoringApp extends StatelessWidget {
  const WeatherMonitoringApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'Smart Weather Monitor Pro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      initialRoute: AppRouter.splash,
      routes: AppRouter.getRoutes(),
    );
  }
}
