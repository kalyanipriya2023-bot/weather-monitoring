library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/city_provider.dart';
import '../../providers/weather_provider.dart';
import '../../providers/forecast_provider.dart';
import '../../services/pdf_service.dart';
import '../../core/app_router.dart';
import '../../widgets/animated_gradient_background.dart';
import '../../widgets/glass_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final PdfService _pdfService = PdfService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CityProvider>().loadCities();
    });
  }

  Future<void> _exportPdfReport(BuildContext context) async {
    final weatherProvider = context.read<WeatherProvider>();
    final forecastProvider = context.read<ForecastProvider>();

    final weather = weatherProvider.currentWeather;
    final forecasts = forecastProvider.dailyForecast;

    if (weather == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please load weather data first on the Home screen.'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Generating PDF Report...')),
      );
      await _pdfService.generateAndShareReport(weather: weather, forecasts: forecasts);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to export PDF: ${e.toString()}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final cityProvider = context.watch<CityProvider>();
    final weatherProvider = context.watch<WeatherProvider>();

    final user = authProvider.currentUser;
    final isGuest = authProvider.isGuest;
    final name = user?.name ?? 'Guest';
    final email = user?.email ?? 'guest@local';

    final weather = weatherProvider.currentWeather;
    final condition = weather?.weatherCondition ?? 'default';

    return Scaffold(
      body: AnimatedGradientBackground(
        condition: condition,
        child: SafeArea(
          child: Column(
            children: [
              // Header
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'USER PROFILE',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        'Account & Settings',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content List
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Profile Info Card
                    GlassCard(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white12,
                            child: Text(
                              name.isNotEmpty ? name[0].toUpperCase() : 'G',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  email,
                                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          if (isGuest)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'GUEST',
                                style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // App Settings Section
                    const SizedBox(height: 16),
                    const Text(
                      'App Settings',
                      style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    // Dark Mode Toggle
                    GlassCard(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: themeProvider.isDarkMode,
                        onChanged: (val) {
                          themeProvider.toggleTheme();
                        },
                        title: const Text('Dark Mode', style: TextStyle(color: Colors.white)),
                        secondary: const Icon(Icons.dark_mode_outlined, color: Colors.white70),
                        activeThumbColor: Theme.of(context).colorScheme.primary,
                        activeTrackColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                      ),
                    ),

                    // Export PDF Report
                    GlassCard(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.picture_as_pdf_outlined, color: Colors.white70),
                        title: const Text('Export Weather Report (PDF)', style: TextStyle(color: Colors.white)),
                        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white30),
                        onTap: () => _exportPdfReport(context),
                      ),
                    ),

                    // Saved Favorite Cities Overview
                    const SizedBox(height: 16),
                    const Text(
                      'Saved Locations',
                      style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    if (cityProvider.favorites.isEmpty)
                      GlassCard(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'No favorite cities saved.',
                              style: TextStyle(color: Colors.white38, fontSize: 13),
                            ),
                          ),
                        ),
                      )
                    else
                      ...cityProvider.favorites.map(
                        (city) => Card(
                          color: Colors.white.withValues(alpha: 0.05),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: const Icon(Icons.location_on_outlined, color: Colors.white54),
                            title: Text(city.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                            subtitle: Text(city.country, style: const TextStyle(color: Colors.white30, fontSize: 12)),
                            trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white30, size: 14),
                            onTap: () {
                              // Switch to Home tab and load this city
                              final wProvider = context.read<WeatherProvider>();
                              wProvider.fetchWeather(city.name);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Switched to ${city.name}')),
                              );
                            },
                          ),
                        ),
                      ),

                    // Logout Button
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await authProvider.logout();
                        if (context.mounted) {
                          Navigator.pushReplacementNamed(context, AppRouter.login);
                        }
                      },
                      icon: const Icon(Icons.logout_rounded),
                      label: const Text('Log Out'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
