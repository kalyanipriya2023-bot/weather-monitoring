library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/city_provider.dart';
import '../../providers/weather_provider.dart';
import '../../providers/alert_provider.dart';
import '../../models/city_model.dart';
import '../../widgets/glass_card.dart';

class CitySearchScreen extends StatefulWidget {
  const CitySearchScreen({super.key});

  @override
  State<CitySearchScreen> createState() => _CitySearchScreenState();
}

class _CitySearchScreenState extends State<CitySearchScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CityProvider>().loadCities();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onCitySelected(CityModel city) async {
    final weatherProvider = context.read<WeatherProvider>();
    final cityProvider = context.read<CityProvider>();

    // Add to recent search database
    await cityProvider.addToRecent(city);

    // Fetch weather for this city
    await weatherProvider.fetchWeather(city.name);

    if (weatherProvider.currentWeather != null && mounted) {
      context.read<AlertProvider>().checkForAlerts(weatherProvider.currentWeather!);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cityProvider = context.watch<CityProvider>();
    final isSearching = cityProvider.isSearching;
    final searchResults = cityProvider.searchResults;
    final favorites = cityProvider.favorites;
    final recentSearches = cityProvider.recentSearches;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F0C29), Color(0xFF302b63), Color(0xFF24243e)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Search Input Row
              _buildSearchHeader(context, cityProvider),

              // Results / Favorites / History list
              Expanded(
                child: _searchController.text.isNotEmpty
                    ? _buildSearchResultsList(searchResults, isSearching)
                    : _buildFavoritesAndHistory(favorites, recentSearches, cityProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchHeader(BuildContext context, CityProvider cityProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () {
              cityProvider.clearSearchResults();
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                textInputAction: TextInputAction.search,
                onSubmitted: (val) {
                  cityProvider.searchCity(val);
                },
                decoration: InputDecoration(
                  hintText: 'Search city...',
                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                  border: InputBorder.none,
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, color: Colors.white70, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            cityProvider.clearSearchResults();
                          },
                        )
                      : null,
                ),
                onChanged: (val) {
                  setState(() {});
                  if (val.isEmpty) {
                    cityProvider.clearSearchResults();
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Colors.white),
            onPressed: () {
              cityProvider.searchCity(_searchController.text);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultsList(List<CityModel> results, bool isSearching) {
    if (isSearching) {
      return Center(
        child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
      );
    }

    if (results.isEmpty) {
      return const Center(
        child: Text(
          'No cities found. Try another search.',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final city = results[index];
        return GlassCard(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(
              backgroundColor: Colors.white12,
              child: Icon(Icons.location_city_rounded, color: Colors.white70),
            ),
            title: Text(
              city.name,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              city.country,
              style: const TextStyle(color: Colors.white54),
            ),
            trailing: IconButton(
              icon: Icon(
                city.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: city.isFavorite ? Colors.redAccent : Colors.white60,
              ),
              onPressed: () {
                context.read<CityProvider>().toggleFavorite(city);
              },
            ),
            onTap: () => _onCitySelected(city),
          ),
        );
      },
    );
  }

  Widget _buildFavoritesAndHistory(
    List<CityModel> favorites,
    List<CityModel> history,
    CityProvider cityProvider,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      children: [
        // Favorites Section
        if (favorites.isNotEmpty) ...[
          const Row(
            children: [
              Icon(Icons.favorite_rounded, color: Colors.redAccent, size: 20),
              SizedBox(width: 8),
              Text(
                'Favorite Cities',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final city = favorites[index];
              return Card(
                color: Colors.white.withValues(alpha: 0.05),
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Text(city.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text(city.country, style: const TextStyle(color: Colors.white54)),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite_rounded, color: Colors.redAccent),
                    onPressed: () {
                      cityProvider.toggleFavorite(city);
                    },
                  ),
                  onTap: () => _onCitySelected(city),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
        ],

        // Search History Section
        if (history.isNotEmpty) ...[
          const Row(
            children: [
              Icon(Icons.history_rounded, color: Colors.white70, size: 20),
              SizedBox(width: 8),
              Text(
                'Recent Searches',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final city = history[index];
              return ListTile(
                leading: const Icon(Icons.search_rounded, color: Colors.white30),
                title: Text(city.name, style: const TextStyle(color: Colors.white70)),
                subtitle: Text(city.country, style: const TextStyle(color: Colors.white30, fontSize: 12)),
                trailing: IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white30, size: 18),
                  onPressed: () {
                    if (city.id != null) {
                      cityProvider.removeCity(city.id!);
                    }
                  },
                ),
                onTap: () => _onCitySelected(city),
              );
            },
          ),
        ] else if (favorites.isEmpty) ...[
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 80),
              child: Column(
                children: [
                  const Icon(Icons.search_rounded, size: 64, color: Colors.white24),
                  const SizedBox(height: 16),
                  Text(
                    'Search for a city above to see weather intelligence',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
