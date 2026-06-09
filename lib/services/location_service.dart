library;

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../core/app_constants.dart';
import '../core/app_exceptions.dart';
import '../models/city_model.dart';

class LocationService {
  final http.Client _client;
  LocationService({http.Client? client}) : _client = client ?? http.Client();

  /// Search cities by name using OpenWeatherMap Geocoding API
  Future<List<CityModel>> searchCity(String query) async {
    try {
      final uri = Uri.parse('$kGeoUrl/direct').replace(
        queryParameters: {'q': query.trim(), 'limit': '5', 'appid': kApiKey},
      );
      final response = await _client.get(uri).timeout(Duration(seconds: kApiTimeoutSeconds));
      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List;
        return list.map((e) {
          final map = e as Map<String, dynamic>;
          return CityModel(
            name: map['name'] as String,
            country: map['country'] as String? ?? '',
            lat: (map['lat'] as num).toDouble(),
            lon: (map['lon'] as num).toDouble(),
            lastSearched: DateTime.now(),
          );
        }).toList();
      }
      return [];
    } on SocketException {
      throw const NoInternetException();
    } catch (e) {
      if (e is NoInternetException) rethrow;
      return [];
    }
  }

  void dispose() => _client.close();
}
