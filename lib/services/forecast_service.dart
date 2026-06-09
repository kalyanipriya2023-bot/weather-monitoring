library;

import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:http/http.dart' as http;
import '../core/app_constants.dart';
import '../core/app_exceptions.dart';
import '../models/forecast_model.dart';

class ForecastService {
  final http.Client _client;
  ForecastService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches 5-day/3-hour forecast data
  Future<List<ForecastModel>> getForecast(String cityName) async {
    developer.log('Fetching forecast for city: "$cityName"', name: 'ForecastService');
    try {
      final uri = Uri.parse('$kBaseUrl/forecast').replace(
        queryParameters: {'q': cityName.trim(), 'appid': kApiKey, 'units': kUnits},
      );
      developer.log('Request URI: $uri', name: 'ForecastService');
      final response = await _client.get(uri).timeout(Duration(seconds: kApiTimeoutSeconds));
      developer.log('Response status code: ${response.statusCode}', name: 'ForecastService');

      if (response.statusCode == 200) {
        try {
          final json = jsonDecode(response.body) as Map<String, dynamic>;
          final list = json['list'] as List? ?? [];
          return list.map((e) => ForecastModel.fromJson(e as Map<String, dynamic>)).toList();
        } catch (e) {
          developer.log('JSON parsing error in forecast: $e', name: 'ForecastService', error: e);
          throw ApiException('Error parsing forecast data: $e');
        }
      } else if (response.statusCode == 404) {
        developer.log('City not found response for forecast', name: 'ForecastService');
        throw const CityNotFoundException();
      } else {
        developer.log('Error response for forecast: ${response.statusCode}', name: 'ForecastService');
        throw ApiException('Forecast error (${response.statusCode})');
      }
    } on SocketException catch (e) {
      developer.log('SocketException fetching forecast: $e', name: 'ForecastService', error: e);
      throw const NoInternetException();
    } on CityNotFoundException {
      rethrow;
    } on ApiException {
      rethrow;
    } on NoInternetException {
      rethrow;
    } catch (e) {
      developer.log('Unexpected error fetching forecast: $e', name: 'ForecastService', error: e);
      throw ApiException('Forecast error: $e');
    }
  }

  /// Get daily aggregated forecasts
  Future<List<DailyForecast>> getDailyForecast(String cityName) async {
    final hourly = await getForecast(cityName);
    return DailyForecast.fromHourlyList(hourly);
  }

  void dispose() => _client.close();
}
