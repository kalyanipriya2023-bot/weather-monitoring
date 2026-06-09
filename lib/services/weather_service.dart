library;

import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:http/http.dart' as http;
import '../core/app_constants.dart';
import '../core/app_exceptions.dart';
import '../models/weather_model.dart';

class WeatherService {
  final http.Client _client;
  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  Future<WeatherModel> getWeather(String cityName) async {
    developer.log('Fetching weather for city: "$cityName"', name: 'WeatherService');
    try {
      final uri = Uri.parse('$kBaseUrl/weather').replace(
        queryParameters: {'q': cityName.trim(), 'appid': kApiKey, 'units': kUnits},
      );
      developer.log('Request URI: $uri', name: 'WeatherService');
      final response = await _client.get(uri).timeout(Duration(seconds: kApiTimeoutSeconds));
      developer.log('Response status code: ${response.statusCode}', name: 'WeatherService');
      developer.log('Response body: ${response.body}', name: 'WeatherService');
      return _handleResponse(response);
    } on SocketException catch (e) {
      developer.log('SocketException fetching weather: $e', name: 'WeatherService', error: e);
      throw const NoInternetException();
    } on http.ClientException catch (e) {
      developer.log('ClientException fetching weather: $e', name: 'WeatherService', error: e);
      throw const NoInternetException('Network error. Please check your connection.');
    } on CityNotFoundException {
      rethrow;
    } on ApiException {
      rethrow;
    } on NoInternetException {
      rethrow;
    } catch (e) {
      developer.log('Unexpected error fetching weather: $e', name: 'WeatherService', error: e);
      throw ApiException('Unexpected error: $e');
    }
  }

  Future<WeatherModel> getWeatherByCoords(double lat, double lon) async {
    developer.log('Fetching weather for coordinates: lat=$lat, lon=$lon', name: 'WeatherService');
    try {
      final uri = Uri.parse('$kBaseUrl/weather').replace(
        queryParameters: {'lat': '$lat', 'lon': '$lon', 'appid': kApiKey, 'units': kUnits},
      );
      developer.log('Request URI: $uri', name: 'WeatherService');
      final response = await _client.get(uri).timeout(Duration(seconds: kApiTimeoutSeconds));
      developer.log('Response status code: ${response.statusCode}', name: 'WeatherService');
      developer.log('Response body: ${response.body}', name: 'WeatherService');
      return _handleResponse(response);
    } on SocketException catch (e) {
      developer.log('SocketException fetching weather by coords: $e', name: 'WeatherService', error: e);
      throw const NoInternetException();
    } catch (e) {
      developer.log('Error fetching weather by coords: $e', name: 'WeatherService', error: e);
      if (e is CityNotFoundException || e is ApiException || e is NoInternetException) rethrow;
      throw ApiException('Unexpected error: $e');
    }
  }

  WeatherModel _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        try {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          return WeatherModel.fromJson(data);
        } catch (e) {
          developer.log('JSON parsing error: $e', name: 'WeatherService', error: e);
          throw ApiException('Error parsing weather data: $e');
        }
      case 404:
        developer.log('City not found response from API', name: 'WeatherService');
        throw const CityNotFoundException();
      case 401:
        developer.log('Invalid API key response from API', name: 'WeatherService');
        throw const ApiException('Invalid API key.', 401);
      case 429:
        developer.log('Too many requests response from API', name: 'WeatherService');
        throw const ApiException('Too many requests. Try again later.', 429);
      default:
        developer.log('Server error response from API: ${response.statusCode}', name: 'WeatherService');
        throw ApiException('Server error (${response.statusCode}).', response.statusCode);
    }
  }

  void dispose() => _client.close();
}
