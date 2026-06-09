library;

import 'dart:convert';
import '../core/app_constants.dart';
import '../database/database_helper.dart';
import '../models/weather_model.dart';

class CacheService {
  final DatabaseHelper _db = DatabaseHelper();

  Future<void> cacheWeather(WeatherModel weather) async {
    // Remove old cache for this city
    await _db.delete('weather_cache', where: 'cityName = ?', whereArgs: [weather.cityName]);
    await _db.insert('weather_cache', {
      'cityName': weather.cityName,
      'data': jsonEncode(weather.toMap()),
      'cachedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<WeatherModel?> getCachedWeather(String cityName) async {
    final results = await _db.query('weather_cache',
      where: 'cityName = ?', whereArgs: [cityName], limit: 1);
    if (results.isEmpty) return null;
    final cachedAt = DateTime.parse(results.first['cachedAt'] as String);
    if (DateTime.now().difference(cachedAt).inMinutes > kCacheValidityMinutes) {
      await _db.delete('weather_cache', where: 'cityName = ?', whereArgs: [cityName]);
      return null;
    }
    final data = jsonDecode(results.first['data'] as String) as Map<String, dynamic>;
    return WeatherModel.fromMap(data);
  }

  Future<bool> isCacheValid(String cityName) async {
    final results = await _db.query('weather_cache',
      where: 'cityName = ?', whereArgs: [cityName], limit: 1);
    if (results.isEmpty) return false;
    final cachedAt = DateTime.parse(results.first['cachedAt'] as String);
    return DateTime.now().difference(cachedAt).inMinutes <= kCacheValidityMinutes;
  }

  Future<void> clearCache() async {
    final db = await _db.database;
    await db.delete('weather_cache');
  }
}
