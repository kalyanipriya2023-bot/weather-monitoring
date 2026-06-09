library;

import 'package:flutter/material.dart';
import '../models/forecast_model.dart';
import '../services/forecast_service.dart';

class ForecastProvider extends ChangeNotifier {
  final ForecastService _forecastService = ForecastService();

  List<ForecastModel> _hourlyForecast = [];
  List<DailyForecast> _dailyForecast = [];
  bool _isLoading = false;
  String? _error;

  List<ForecastModel> get hourlyForecast => _hourlyForecast;
  List<DailyForecast> get dailyForecast => _dailyForecast;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchForecast(String cityName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _hourlyForecast = await _forecastService.getForecast(cityName);
      _dailyForecast = DailyForecast.fromHourlyList(_hourlyForecast);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
