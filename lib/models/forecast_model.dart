library;

class ForecastModel {
  final DateTime dateTime;
  final double temperature;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double windSpeed;
  final String weatherCondition;
  final String weatherDescription;
  final String iconCode;
  final double pop; // probability of precipitation

  const ForecastModel({
    required this.dateTime,
    required this.temperature,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCondition,
    required this.weatherDescription,
    required this.iconCode,
    required this.pop,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>? ?? {};
    final weatherList = json['weather'] as List? ?? [];
    final weather = weatherList.isNotEmpty ? weatherList.first as Map<String, dynamic> : {};
    final wind = json['wind'] as Map<String, dynamic>? ?? {};

    return ForecastModel(
      dateTime: DateTime.fromMillisecondsSinceEpoch(((json['dt'] as int? ?? 0)) * 1000),
      temperature: (main['temp'] as num?)?.toDouble() ?? 0.0,
      tempMin: (main['temp_min'] as num?)?.toDouble() ?? 0.0,
      tempMax: (main['temp_max'] as num?)?.toDouble() ?? 0.0,
      humidity: main['humidity'] as int? ?? 0,
      windSpeed: (wind['speed'] as num?)?.toDouble() ?? 0.0,
      weatherCondition: weather['main'] as String? ?? 'Clouds',
      weatherDescription: weather['description'] as String? ?? 'scattered clouds',
      iconCode: weather['icon'] as String? ?? '03d',
      pop: ((json['pop'] as num?) ?? 0).toDouble(),
    );
  }

  String get iconUrl => 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  double get windSpeedKmh => windSpeed * 3.6;
  int get popPercent => (pop * 100).round();

  String get capitalizedDescription {
    if (weatherDescription.isEmpty) return '';
    return weatherDescription[0].toUpperCase() + weatherDescription.substring(1);
  }
}

/// Aggregated daily forecast from 3-hour data
class DailyForecast {
  final DateTime date;
  final double tempMin;
  final double tempMax;
  final double avgHumidity;
  final double maxWindSpeed;
  final String weatherCondition;
  final String iconCode;
  final double maxPop;
  final List<ForecastModel> hourlyData;

  const DailyForecast({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.avgHumidity,
    required this.maxWindSpeed,
    required this.weatherCondition,
    required this.iconCode,
    required this.maxPop,
    required this.hourlyData,
  });

  /// Aggregate hourly forecasts into daily summaries
  static List<DailyForecast> fromHourlyList(List<ForecastModel> hourly) {
    final Map<String, List<ForecastModel>> grouped = {};
    for (final f in hourly) {
      final key = '${f.dateTime.year}-${f.dateTime.month}-${f.dateTime.day}';
      grouped.putIfAbsent(key, () => []).add(f);
    }

    return grouped.entries.map((entry) {
      final items = entry.value;
      final temps = items.map((e) => e.temperature).toList();
      final humidities = items.map((e) => e.humidity).toList();

      // Most common condition
      final condMap = <String, int>{};
      for (final i in items) {
        condMap[i.weatherCondition] = (condMap[i.weatherCondition] ?? 0) + 1;
      }
      final topCondition = condMap.entries.reduce((a, b) => a.value > b.value ? a : b).key;
      final topIcon = items.firstWhere((i) => i.weatherCondition == topCondition).iconCode;

      return DailyForecast(
        date: DateTime(items.first.dateTime.year, items.first.dateTime.month, items.first.dateTime.day),
        tempMin: temps.reduce((a, b) => a < b ? a : b),
        tempMax: temps.reduce((a, b) => a > b ? a : b),
        avgHumidity: humidities.reduce((a, b) => a + b) / humidities.length,
        maxWindSpeed: items.map((e) => e.windSpeed).reduce((a, b) => a > b ? a : b),
        weatherCondition: topCondition,
        iconCode: topIcon,
        maxPop: items.map((e) => e.pop).reduce((a, b) => a > b ? a : b),
        hourlyData: items,
      );
    }).toList();
  }
}
