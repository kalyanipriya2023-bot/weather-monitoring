library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/weather_provider.dart';
import '../../providers/alert_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/date_helpers.dart';
import '../../widgets/animated_gradient_background.dart';
import '../../widgets/temperature_display.dart';
import '../../widgets/weather_icon_widget.dart';
import '../../widgets/weather_card.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/alert_banner.dart';
import '../../widgets/aqi_gauge.dart';
import '../../widgets/shimmer_loading.dart';
import 'city_search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final weatherProvider = context.read<WeatherProvider>();
    await weatherProvider.loadInitial();

    if (weatherProvider.currentWeather != null && mounted) {
      context.read<AlertProvider>().checkForAlerts(weatherProvider.currentWeather!);
    }
  }

  Future<void> _onRefresh() async {
    final weatherProvider = context.read<WeatherProvider>();
    await weatherProvider.refresh();
    if (weatherProvider.currentWeather != null && mounted) {
      context.read<AlertProvider>().checkForAlerts(weatherProvider.currentWeather!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = context.watch<WeatherProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final authProvider = context.watch<AuthProvider>();
    final alertProvider = context.watch<AlertProvider>();

    final weather = weatherProvider.currentWeather;
    final isLoading = weatherProvider.isLoading;
    final error = weatherProvider.error;
    final isOffline = weatherProvider.isOffline;

    final condition = weather?.weatherCondition ?? 'default';

    return Scaffold(
      body: AnimatedGradientBackground(
        condition: condition,
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
              _buildTopBar(context, themeProvider, authProvider),

              // Content Area
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  color: Colors.white,
                  backgroundColor: Colors.black26,
                  child: isLoading
                      ? _buildShimmerLoading()
                      : error != null
                          ? _buildErrorView(error)
                          : weather == null
                              ? const Center(
                                  child: Text(
                                    'No weather data loaded.',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                )
                              : _buildMainContent(context, weather, isOffline, alertProvider),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(
    BuildContext context,
    ThemeProvider themeProvider,
    AuthProvider authProvider,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24, width: 1.5),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SMART WEATHER MONITOR PRO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    'Predict. Analyze. Stay Ahead.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              // Search Icon Button
              IconButton(
                icon: const Icon(Icons.search_rounded, color: Colors.white, size: 26),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CitySearchScreen()),
                  );
                },
              ),
              const SizedBox(width: 4),
              // Theme Toggle
              IconButton(
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  color: Colors.white,
                  size: 26,
                ),
                onPressed: () {
                  themeProvider.toggleTheme();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const SizedBox(height: 20),
        const ShimmerLoading(height: 30, width: 200),
        const SizedBox(height: 30),
        const Center(child: ShimmerLoading(height: 120, width: 120, borderRadius: 60)),
        const SizedBox(height: 20),
        const Center(child: ShimmerLoading(height: 80, width: 180)),
        const SizedBox(height: 40),
        const ShimmerLoading(height: 100),
        const SizedBox(height: 20),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1.15,
          children: List.generate(4, (_) => const ShimmerLoading(height: 100)),
        ),
      ],
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: Colors.white,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _onRefresh,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(
    BuildContext context,
    dynamic weather,
    bool isOffline,
    AlertProvider alertProvider,
  ) {
    final now = DateTime.now();
    final dateStr = DateHelpers.formatFullDate(now);
    final timeStr = DateHelpers.formatTime(now);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      children: [
        if (isOffline)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.orangeAccent.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi_off_rounded, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text(
                  'Offline Mode - Showing Cached Data',
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

        // Date / Time
        Center(
          child: Column(
            children: [
              Text(
                dateStr,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              Text(
                'Updated at $timeStr',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Weather Icon + Temp
        Column(
          children: [
            WeatherIconWidget(iconUrl: weather.iconUrl, size: 120),
            TemperatureDisplay(temp: weather.temperature, fontSize: 76),
            const SizedBox(height: 4),
            Text(
              weather.capitalizedDescription,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on_rounded, color: Colors.white70, size: 18),
                const SizedBox(width: 4),
                Text(
                  '${weather.cityName}, ${weather.country}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Active Alert Banner
        if (alertProvider.activeAlerts.isNotEmpty)
          ...alertProvider.activeAlerts.map((alert) => AlertBanner(
                alert: alert,
                onTap: () {
                  // Switch to Alerts tab or show alerts screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(alert.message), duration: const Duration(seconds: 4)),
                  );
                },
              )),

        // Main Weather Detail Row (Min/Max/FeelsLike)
        _buildTempRangeRow(weather),
        const SizedBox(height: 20),

        // Grid of 4 Detail Cards
        _buildDetailsGrid(weather),
        const SizedBox(height: 20),

        // Air Quality and UV Index Glass Card
        _buildAirQualityCard(weather),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildTempRangeRow(dynamic weather) {
    return GlassCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTempItem(
            'Feels Like',
            '${weather.feelsLike.round()}°C',
            Icons.thermostat_rounded,
          ),
          Container(width: 1, height: 30, color: Colors.white12),
          _buildTempItem(
            'Min Temp',
            '${weather.tempMin.round()}°C',
            Icons.arrow_downward_rounded,
          ),
          Container(width: 1, height: 30, color: Colors.white12),
          _buildTempItem(
            'Max Temp',
            '${weather.tempMax.round()}°C',
            Icons.arrow_upward_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildTempItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildDetailsGrid(dynamic weather) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 1.15,
      children: [
        WeatherCard(
          icon: Icons.water_drop_rounded,
          label: 'HUMIDITY',
          value: '${weather.humidity}%',
          iconColor: const Color(0xFF4FC3F7),
        ),
        WeatherCard(
          icon: Icons.air_rounded,
          label: 'WIND SPEED',
          value: '${weather.windSpeedKmh.toStringAsFixed(1)} km/h',
          iconColor: const Color(0xFF81C784),
        ),
        WeatherCard(
          icon: Icons.speed_rounded,
          label: 'PRESSURE',
          value: '${weather.pressure} hPa',
          iconColor: const Color(0xFFFFB74D),
        ),
        WeatherCard(
          icon: Icons.visibility_rounded,
          label: 'VISIBILITY',
          value: '${weather.visibilityKm.toStringAsFixed(1)} km',
          iconColor: const Color(0xFFBA68C8),
        ),
      ],
    );
  }

  Widget _buildAirQualityCard(dynamic weather) {
    return GlassCard(
      margin: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // AQI Gauge
          Expanded(
            child: AqiGauge(
              aqi: weather.estimatedAqi,
              label: weather.aqiLabel,
            ),
          ),
          Container(width: 1, height: 100, color: Colors.white12),
          // UV Index Info
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.wb_sunny_outlined,
                    color: Colors.orange,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'UV Index',
                  style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  '${weather.estimatedUvIndex}',
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  _getUvLabel(weather.estimatedUvIndex),
                  style: TextStyle(
                    color: _getUvColor(weather.estimatedUvIndex),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getUvLabel(int uv) {
    if (uv <= 2) return 'Low';
    if (uv <= 5) return 'Moderate';
    if (uv <= 7) return 'High';
    if (uv <= 10) return 'Very High';
    return 'Extreme';
  }

  Color _getUvColor(int uv) {
    if (uv <= 2) return Colors.green;
    if (uv <= 5) return Colors.yellow;
    if (uv <= 7) return Colors.orange;
    if (uv <= 10) return Colors.red;
    return Colors.purple;
  }
}
