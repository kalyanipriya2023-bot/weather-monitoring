library;

import 'package:flutter/material.dart';
import '../core/app_constants.dart';
import '../database/database_helper.dart';
import '../models/city_model.dart';
import '../services/location_service.dart';

class CityProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  final DatabaseHelper _db = DatabaseHelper();

  List<CityModel> _favorites = [];
  List<CityModel> _recentSearches = [];
  List<CityModel> _searchResults = [];
  bool _isSearching = false;

  List<CityModel> get favorites => _favorites;
  List<CityModel> get recentSearches => _recentSearches;
  List<CityModel> get searchResults => _searchResults;
  bool get isSearching => _isSearching;

  Future<void> loadCities() async {
    final all = await _db.query('cities', orderBy: 'lastSearched DESC');
    final cities = all.map((e) => CityModel.fromMap(e)).toList();
    _favorites = cities.where((c) => c.isFavorite).toList();
    _recentSearches = cities.take(kMaxRecentSearches).toList();
    notifyListeners();
  }

  Future<void> searchCity(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }
    _isSearching = true;
    notifyListeners();
    _searchResults = await _locationService.searchCity(query);
    _isSearching = false;
    notifyListeners();
  }

  Future<void> addToRecent(CityModel city) async {
    // Remove existing entry for this city
    await _db.delete('cities', where: 'name = ? AND country = ?', whereArgs: [city.name, city.country]);
    await _db.insert('cities', city.toMap());
    await loadCities();
  }

  Future<void> toggleFavorite(CityModel city) async {
    if (city.id != null) {
      await _db.update('cities', {'isFavorite': city.isFavorite ? 0 : 1},
        where: 'id = ?', whereArgs: [city.id]);
    } else {
      await _db.insert('cities', city.copyWith(isFavorite: !city.isFavorite).toMap());
    }
    await loadCities();
  }

  Future<void> removeCity(int id) async {
    await _db.delete('cities', where: 'id = ?', whereArgs: [id]);
    await loadCities();
  }

  void clearSearchResults() {
    _searchResults = [];
    notifyListeners();
  }
}
