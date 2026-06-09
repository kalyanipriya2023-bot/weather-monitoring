library;

class WeatherHistoryModel {
  final int? id;
  final String cityName;
  final double temperature;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final String weatherCondition;
  final DateTime recordedAt;

  const WeatherHistoryModel({
    this.id,
    required this.cityName,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.weatherCondition,
    required this.recordedAt,
  });

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'cityName': cityName, 'temperature': temperature,
    'humidity': humidity, 'windSpeed': windSpeed,
    'pressure': pressure, 'weatherCondition': weatherCondition,
    'recordedAt': recordedAt.toIso8601String(),
  };

  factory WeatherHistoryModel.fromMap(Map<String, dynamic> map) => WeatherHistoryModel(
    id: map['id'] as int?,
    cityName: map['cityName'] as String,
    temperature: (map['temperature'] as num).toDouble(),
    humidity: map['humidity'] as int,
    windSpeed: (map['windSpeed'] as num).toDouble(),
    pressure: map['pressure'] as int,
    weatherCondition: map['weatherCondition'] as String,
    recordedAt: DateTime.parse(map['recordedAt'] as String),
  );
}
