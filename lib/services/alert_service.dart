library;

import '../database/database_helper.dart';
import '../models/weather_model.dart';
import '../models/weather_alert_model.dart';

class AlertService {
  final DatabaseHelper _db = DatabaseHelper();

  /// Check weather conditions and generate alerts
  List<WeatherAlertModel> checkAlerts(WeatherModel weather) {
    final alerts = <WeatherAlertModel>[];
    final now = DateTime.now();

    // Heat Wave: > 40°C
    if (weather.temperature > 40) {
      alerts.add(WeatherAlertModel(
        cityName: weather.cityName, alertType: AlertType.heatWave,
        severity: AlertSeverity.high,
        message: 'Extreme heat alert! Temperature is ${weather.temperature.round()}°C. Stay hydrated and avoid direct sunlight.',
        createdAt: now,
      ));
    } else if (weather.temperature > 35) {
      alerts.add(WeatherAlertModel(
        cityName: weather.cityName, alertType: AlertType.heatWave,
        severity: AlertSeverity.medium,
        message: 'Heat advisory: Temperature is ${weather.temperature.round()}°C.',
        createdAt: now,
      ));
    }

    // Extreme Cold: < 0°C
    if (weather.temperature < -10) {
      alerts.add(WeatherAlertModel(
        cityName: weather.cityName, alertType: AlertType.cold,
        severity: AlertSeverity.high,
        message: 'Extreme cold warning! Temperature is ${weather.temperature.round()}°C. Limit outdoor exposure.',
        createdAt: now,
      ));
    } else if (weather.temperature < 0) {
      alerts.add(WeatherAlertModel(
        cityName: weather.cityName, alertType: AlertType.cold,
        severity: AlertSeverity.medium,
        message: 'Freezing temperatures: ${weather.temperature.round()}°C.',
        createdAt: now,
      ));
    }

    // Storm
    if (weather.weatherCondition.toLowerCase() == 'thunderstorm') {
      alerts.add(WeatherAlertModel(
        cityName: weather.cityName, alertType: AlertType.storm,
        severity: AlertSeverity.critical,
        message: 'Thunderstorm warning! Seek shelter immediately.',
        createdAt: now,
      ));
    }

    // Rain
    if (weather.weatherCondition.toLowerCase() == 'rain') {
      alerts.add(WeatherAlertModel(
        cityName: weather.cityName, alertType: AlertType.rain,
        severity: AlertSeverity.low,
        message: 'Rain expected. Carry an umbrella.',
        createdAt: now,
      ));
    }

    // High Wind: > 50 km/h
    if (weather.windSpeedKmh > 50) {
      alerts.add(WeatherAlertModel(
        cityName: weather.cityName, alertType: AlertType.highWind,
        severity: AlertSeverity.high,
        message: 'High wind alert! Wind speed: ${weather.windSpeedKmh.round()} km/h.',
        createdAt: now,
      ));
    }

    // Snow
    if (weather.weatherCondition.toLowerCase() == 'snow') {
      alerts.add(WeatherAlertModel(
        cityName: weather.cityName, alertType: AlertType.snow,
        severity: AlertSeverity.medium,
        message: 'Snowfall expected. Roads may be slippery.',
        createdAt: now,
      ));
    }

    // Poor AQI
    if (weather.estimatedAqi > 100) {
      alerts.add(WeatherAlertModel(
        cityName: weather.cityName, alertType: AlertType.poorAqi,
        severity: weather.estimatedAqi > 200 ? AlertSeverity.high : AlertSeverity.medium,
        message: 'Air quality is ${weather.aqiLabel}. Consider wearing a mask.',
        createdAt: now,
      ));
    }

    return alerts;
  }

  Future<void> saveAlert(WeatherAlertModel alert) async {
    await _db.insert('weather_alerts', alert.toMap());
  }

  Future<List<WeatherAlertModel>> getAlerts({String? cityName}) async {
    final results = await _db.query('weather_alerts',
      where: cityName != null ? 'cityName = ?' : null,
      whereArgs: cityName != null ? [cityName] : null,
      orderBy: 'createdAt DESC', limit: 50);
    return results.map((e) => WeatherAlertModel.fromMap(e)).toList();
  }

  Future<void> markAsRead(int id) async {
    await _db.update('weather_alerts', {'isRead': 1}, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> getUnreadCount() async {
    final results = await _db.query('weather_alerts', where: 'isRead = ?', whereArgs: [0]);
    return results.length;
  }
}
