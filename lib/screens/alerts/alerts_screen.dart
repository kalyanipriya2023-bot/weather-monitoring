library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/weather_provider.dart';
import '../../providers/alert_provider.dart';
import '../../widgets/animated_gradient_background.dart';
import '../../widgets/alert_banner.dart';
import '../../models/weather_alert_model.dart';
import '../../widgets/glass_card.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AlertProvider>().loadAlertHistory();
    });
  }

  Color _getSeverityColor(AlertSeverity severity) {
    return switch (severity) {
      AlertSeverity.low => const Color(0xFF81C784),
      AlertSeverity.medium => const Color(0xFFFFB74D),
      AlertSeverity.high => const Color(0xFFE57373),
      AlertSeverity.critical => const Color(0xFFD32F2F),
    };
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = context.watch<WeatherProvider>();
    final alertProvider = context.watch<AlertProvider>();

    final weather = weatherProvider.currentWeather;
    final activeAlerts = alertProvider.activeAlerts;
    final history = alertProvider.alertHistory;

    final condition = weather?.weatherCondition ?? 'default';

    return Scaffold(
      body: AnimatedGradientBackground(
        condition: condition,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SYSTEM ALERTS',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                            letterSpacing: 1.0,
                          ),
                        ),
                        Text(
                          'Weather Alert Panel',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    if (alertProvider.unreadCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${alertProvider.unreadCount} New',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ),

              // Sub-Tabs or Lists
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await alertProvider.loadAlertHistory();
                  },
                  color: Colors.white,
                  backgroundColor: Colors.black26,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                    children: [
                      // Active Alerts Section
                      const Text(
                        'Active Alerts (Current City)',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      if (activeAlerts.isEmpty)
                        GlassCard(
                          margin: EdgeInsets.zero,
                          padding: const EdgeInsets.all(24),
                          child: const Row(
                            children: [
                              Icon(Icons.check_circle_outline_rounded, color: Colors.greenAccent, size: 28),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'All Clear',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'No severe weather alerts active for current city.',
                                      style: TextStyle(color: Colors.white60, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ...activeAlerts.map((alert) => AlertBanner(alert: alert)),

                      const SizedBox(height: 28),

                      // Historical Log Section
                      const Text(
                        'Alert History & Logs',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      if (history.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Text(
                              'No alert logs recorded yet.',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: history.length,
                          itemBuilder: (context, index) {
                            final alert = history[index];
                            final timeStr = DateFormat('MMM d, h:mm a').format(alert.createdAt);
                            final severityColor = _getSeverityColor(alert.severity);

                            return Opacity(
                              opacity: alert.isRead ? 0.6 : 1.0,
                              child: GlassCard(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.all(12),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: CircleAvatar(
                                    backgroundColor: severityColor.withValues(alpha: 0.15),
                                    child: Icon(
                                      alert.isRead ? Icons.notifications_none_rounded : Icons.notifications_active_rounded,
                                      color: severityColor,
                                    ),
                                  ),
                                  title: Row(
                                    children: [
                                      Text(
                                        alert.cityName,
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        alert.alertType.name.toUpperCase(),
                                        style: TextStyle(color: severityColor, fontSize: 10, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 2),
                                      Text(alert.message, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                                      const SizedBox(height: 4),
                                      Text(timeStr, style: const TextStyle(color: Colors.white38, fontSize: 10)),
                                    ],
                                  ),
                                  trailing: !alert.isRead
                                      ? IconButton(
                                          icon: Icon(Icons.mark_email_read_outlined, color: Theme.of(context).colorScheme.primary, size: 20),
                                          onPressed: () {
                                            if (alert.id != null) {
                                              alertProvider.markAsRead(alert.id!);
                                            }
                                          },
                                          tooltip: 'Mark as read',
                                        )
                                      : const Icon(Icons.check_rounded, color: Colors.white24, size: 18),
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
