library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/weather_provider.dart';
import '../../providers/forecast_provider.dart';
import '../../models/forecast_model.dart';
import '../../widgets/animated_gradient_background.dart';
import '../../widgets/forecast_timeline.dart';
import '../../widgets/daily_forecast_card.dart';
import '../../widgets/shimmer_loading.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadForecast();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadForecast() {
    final weatherProvider = context.read<WeatherProvider>();
    final forecastProvider = context.read<ForecastProvider>();

    if (weatherProvider.currentWeather != null) {
      forecastProvider.fetchForecast(weatherProvider.currentWeather!.cityName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = context.watch<WeatherProvider>();
    final forecastProvider = context.watch<ForecastProvider>();

    final weather = weatherProvider.currentWeather;
    final forecastLoading = forecastProvider.isLoading;
    final forecastError = forecastProvider.error;
    final hourlyData = forecastProvider.hourlyForecast;
    final dailyData = forecastProvider.dailyForecast;

    final condition = weather?.weatherCondition ?? 'default';
    final cityName = weather?.cityName ?? 'Unknown City';

    return Scaffold(
      body: AnimatedGradientBackground(
        condition: condition,
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cityName.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white.withValues(alpha: 0.7),
                                letterSpacing: 1.0,
                              ),
                            ),
                            const Text(
                              'Weather Forecast',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                          onPressed: _loadForecast,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Tab Bar
              TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xFF2F80ED),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white38,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(text: 'Hourly Timeline'),
                  Tab(text: '5-Day Forecast'),
                ],
              ),
              const SizedBox(height: 12),

              // Tab Views
              Expanded(
                child: forecastLoading
                    ? _buildShimmerLoading()
                    : forecastError != null
                        ? _buildErrorView(forecastError)
                        : TabBarView(
                            controller: _tabController,
                            children: [
                              // Hourly View
                              _buildHourlyTab(hourlyData),
                              // Daily View
                              _buildDailyTab(dailyData),
                            ],
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const ShimmerLoading(height: 140),
        const SizedBox(height: 20),
        ...List.generate(5, (_) => const Padding(
              padding: EdgeInsets.only(bottom: 12.0),
              child: ShimmerLoading(height: 80),
            )),
      ],
    );
  }

  Widget _buildErrorView(String err) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.white70, size: 48),
            const SizedBox(height: 16),
            Text(
              'Failed to load forecast data:\n$err',
              style: const TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadForecast,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHourlyTab(List<ForecastModel> hourlyData) {
    if (hourlyData.isEmpty) {
      return const Center(
        child: Text(
          'No hourly data available',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            'Next 24 Hours',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ForecastTimeline(hourlyData: hourlyData.take(8).toList()),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            'Extended Hourly',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const BouncingScrollPhysics(),
            itemCount: hourlyData.length - 8 > 0 ? hourlyData.length - 8 : 0,
            itemBuilder: (context, index) {
              final item = hourlyData[index + 8];
              final timeStr = "${item.dateTime.month}/${item.dateTime.day}  "
                  "${item.dateTime.hour.toString().padLeft(2, '0')}:00";
              return Card(
                color: Colors.white.withValues(alpha: 0.05),
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: Image.network(
                    item.iconUrl,
                    width: 36,
                    height: 36,
                    errorBuilder: (_, __, ___) => const Icon(Icons.cloud_rounded, color: Colors.white70),
                  ),
                  title: Text(
                    '${item.temperature.round()}°C - ${item.capitalizedDescription}',
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    'Wind: ${item.windSpeedKmh.toStringAsFixed(1)} km/h | Humidity: ${item.humidity}%',
                    style: const TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                  trailing: Text(
                    timeStr,
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDailyTab(List<DailyForecast> dailyData) {
    if (dailyData.isEmpty) {
      return const Center(
        child: Text(
          'No daily data available',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: dailyData.length,
      itemBuilder: (context, index) {
        final day = dailyData[index];
        return DailyForecastCard(
          forecast: day,
          onTap: () {
            // Show detailed bottom sheet of daily hourly data
            _showDailyDetailsBottomSheet(context, day);
          },
        );
      },
    );
  }

  void _showDailyDetailsBottomSheet(BuildContext context, DailyForecast day) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Hourly Details - ${day.weatherCondition}',
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: day.hourlyData.length,
                  itemBuilder: (context, index) {
                    final item = day.hourlyData[index];
                    final timeStr = "${item.dateTime.hour.toString().padLeft(2, '0')}:00";
                    return Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(timeStr, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                          Image.network(
                            item.iconUrl,
                            width: 32,
                            height: 32,
                            errorBuilder: (_, __, ___) => const Icon(Icons.cloud_rounded, color: Colors.white70),
                          ),
                          Text('${item.temperature.round()}°C', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
