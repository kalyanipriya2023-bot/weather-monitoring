library;

import '../database/database_helper.dart';
import '../models/weather_model.dart';
import '../models/weather_history_model.dart';

class AnalyticsService {
  final DatabaseHelper _db = DatabaseHelper();

  /// Record current weather for historical tracking
  Future<void> recordWeather(WeatherModel weather, {DateTime? recordedAt}) async {
    final record = WeatherHistoryModel(
      cityName: weather.cityName,
      temperature: weather.temperature,
      humidity: weather.humidity,
      windSpeed: weather.windSpeed,
      pressure: weather.pressure,
      weatherCondition: weather.weatherCondition,
      recordedAt: recordedAt ?? DateTime.now(),
    );
    await _db.insert('weather_history', record.toMap());
  }

  /// Get temperature trend for a city
  Future<List<WeatherHistoryModel>> getHistory(String cityName, {int days = 7}) async {
    final since = DateTime.now().subtract(Duration(days: days));
    final results = await _db.query('weather_history',
      where: 'cityName = ? AND recordedAt > ?',
      whereArgs: [cityName, since.toIso8601String()],
      orderBy: 'recordedAt ASC');
    return results.map((e) => WeatherHistoryModel.fromMap(e)).toList();
  }

  /// Get average temperature for period
  Future<double?> getAverageTemperature(String cityName, {int days = 7}) async {
    final history = await getHistory(cityName, days: days);
    if (history.isEmpty) return null;
    return history.map((e) => e.temperature).reduce((a, b) => a + b) / history.length;
  }

  /// Get weather condition distribution
  Future<Map<String, int>> getConditionDistribution(String cityName, {int days = 30}) async {
    final history = await getHistory(cityName, days: days);
    final dist = <String, int>{};
    for (final h in history) {
      dist[h.weatherCondition] = (dist[h.weatherCondition] ?? 0) + 1;
    }
    return dist;
  }

  /// Clear old history
  Future<void> clearOldHistory({int keepDays = 90}) async {
    final cutoff = DateTime.now().subtract(Duration(days: keepDays));
    await _db.delete('weather_history',
      where: 'recordedAt < ?', whereArgs: [cutoff.toIso8601String()]);
  }
}
