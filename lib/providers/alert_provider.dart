library;

import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../models/weather_alert_model.dart';
import '../services/alert_service.dart';

class AlertProvider extends ChangeNotifier {
  final AlertService _alertService = AlertService();

  List<WeatherAlertModel> _activeAlerts = [];
  List<WeatherAlertModel> _alertHistory = [];
  int _unreadCount = 0;

  List<WeatherAlertModel> get activeAlerts => _activeAlerts;
  List<WeatherAlertModel> get alertHistory => _alertHistory;
  int get unreadCount => _unreadCount;

  /// Check weather and generate alerts
  Future<void> checkForAlerts(WeatherModel weather) async {
    _activeAlerts = _alertService.checkAlerts(weather);
    for (final alert in _activeAlerts) {
      await _alertService.saveAlert(alert);
    }
    _unreadCount = await _alertService.getUnreadCount();
    notifyListeners();
  }

  /// Load alert history from database
  Future<void> loadAlertHistory() async {
    _alertHistory = await _alertService.getAlerts();
    _unreadCount = await _alertService.getUnreadCount();
    notifyListeners();
  }

  /// Mark alert as read
  Future<void> markAsRead(int id) async {
    await _alertService.markAsRead(id);
    _unreadCount = await _alertService.getUnreadCount();
    _alertHistory = _alertHistory.map((a) {
      if (a.id == id) {
        return WeatherAlertModel(
          id: a.id, cityName: a.cityName, alertType: a.alertType,
          severity: a.severity, message: a.message, createdAt: a.createdAt, isRead: true,
        );
      }
      return a;
    }).toList();
    notifyListeners();
  }
}
