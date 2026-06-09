library;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/app_constants.dart';
import '../core/app_exceptions.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../services/cache_service.dart';
import '../services/analytics_service.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final CacheService _cacheService = CacheService();
  final AnalyticsService _analyticsService = AnalyticsService();

  WeatherModel? _currentWeather;
  bool _isLoading = false;
  String? _error;
  String? _lastCity;
  bool _isOffline = false;

  WeatherModel? get currentWeather => _currentWeather;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get lastCity => _lastCity;
  bool get isOffline => _isOffline;

  /// Load the last searched city and fetch its weather
  Future<void> loadInitial() async {
    final prefs = await SharedPreferences.getInstance();
    _lastCity = prefs.getString(kLastCityKey);
    await fetchWeather(_lastCity ?? kDefaultCity);
  }

  /// Fetch weather for a city
  Future<void> fetchWeather(String cityName) async {
    _isLoading = true;
    _error = null;
    _isOffline = false;
    notifyListeners();

    try {
      _currentWeather = await _weatherService.getWeather(cityName);
      _lastCity = cityName;

      // Save to preferences, cache, and history
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(kLastCityKey, cityName);
      await _cacheService.cacheWeather(_currentWeather!);
      await _analyticsService.recordWeather(_currentWeather!);

      _isLoading = false;
      notifyListeners();
    } on NoInternetException {
      // Try cache
      final cached = await _cacheService.getCachedWeather(cityName);
      if (cached != null) {
        _currentWeather = cached;
        _isOffline = true;
        _isLoading = false;
        notifyListeners();
      } else {
        _error = 'No internet connection and no cached data available.';
        _isLoading = false;
        notifyListeners();
      }
    } on CityNotFoundException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'An unexpected error occurred.';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh current weather
  Future<void> refresh() async {
    if (_lastCity != null) await fetchWeather(_lastCity!);
  }
}
