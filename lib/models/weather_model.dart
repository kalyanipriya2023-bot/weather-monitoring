library;

class WeatherModel {
  final String cityName;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final int visibility;
  final String weatherCondition;
  final String weatherDescription;
  final String iconCode;
  final String country;
  final int sunrise;
  final int sunset;
  final double tempMin;
  final double tempMax;
  final double? lat;
  final double? lon;
  final int? uvIndex;
  final int? aqi;

  const WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.visibility,
    required this.weatherCondition,
    required this.weatherDescription,
    required this.iconCode,
    required this.country,
    required this.sunrise,
    required this.sunset,
    required this.tempMin,
    required this.tempMax,
    this.lat,
    this.lon,
    this.uvIndex,
    this.aqi,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>? ?? {};
    final weatherList = json['weather'] as List? ?? [];
    final weather = weatherList.isNotEmpty ? weatherList.first as Map<String, dynamic> : {};
    final wind = json['wind'] as Map<String, dynamic>? ?? {};
    final sys = json['sys'] as Map<String, dynamic>? ?? {};
    final coord = json['coord'] as Map<String, dynamic>?;

    return WeatherModel(
      cityName: json['name'] as String? ?? 'Unknown',
      temperature: (main['temp'] as num?)?.toDouble() ?? 0.0,
      feelsLike: (main['feels_like'] as num?)?.toDouble() ?? 0.0,
      humidity: main['humidity'] as int? ?? 0,
      windSpeed: (wind['speed'] as num?)?.toDouble() ?? 0.0,
      pressure: main['pressure'] as int? ?? 1013,
      visibility: json['visibility'] as int? ?? 0,
      weatherCondition: weather['main'] as String? ?? 'Clouds',
      weatherDescription: weather['description'] as String? ?? 'scattered clouds',
      iconCode: weather['icon'] as String? ?? '03d',
      country: sys['country'] as String? ?? '',
      sunrise: sys['sunrise'] as int? ?? 0,
      sunset: sys['sunset'] as int? ?? 0,
      tempMin: (main['temp_min'] as num?)?.toDouble() ?? 0.0,
      tempMax: (main['temp_max'] as num?)?.toDouble() ?? 0.0,
      lat: (coord?['lat'] as num?)?.toDouble(),
      lon: (coord?['lon'] as num?)?.toDouble(),
    );
  }

  String get iconUrl => 'https://openweathermap.org/img/wn/$iconCode@4x.png';
  double get visibilityKm => visibility / 1000;
  double get windSpeedKmh => windSpeed * 3.6;
  DateTime get sunriseTime => DateTime.fromMillisecondsSinceEpoch(sunrise * 1000);
  DateTime get sunsetTime => DateTime.fromMillisecondsSinceEpoch(sunset * 1000);

  String get capitalizedDescription {
    if (weatherDescription.isEmpty) return '';
    return weatherDescription[0].toUpperCase() + weatherDescription.substring(1);
  }

  /// Estimated UV index based on weather condition (for free API tier)
  int get estimatedUvIndex {
    if (uvIndex != null) return uvIndex!;
    return switch (weatherCondition.toLowerCase()) {
      'clear' => 7,
      'clouds' => 3,
      'rain' || 'drizzle' => 1,
      'thunderstorm' => 1,
      'snow' => 2,
      _ => 4,
    };
  }

  /// Estimated AQI (for free API tier)
  int get estimatedAqi {
    if (aqi != null) return aqi!;
    return switch (weatherCondition.toLowerCase()) {
      'clear' => 35,
      'clouds' => 50,
      'rain' || 'drizzle' => 25,
      'mist' || 'haze' || 'fog' || 'smoke' => 120,
      _ => 45,
    };
  }

  String get aqiLabel {
    final v = estimatedAqi;
    if (v <= 50) return 'Good';
    if (v <= 100) return 'Moderate';
    if (v <= 150) return 'Unhealthy for Sensitive';
    if (v <= 200) return 'Unhealthy';
    if (v <= 300) return 'Very Unhealthy';
    return 'Hazardous';
  }

  Map<String, dynamic> toMap() => {
    'cityName': cityName, 'temperature': temperature, 'feelsLike': feelsLike,
    'humidity': humidity, 'windSpeed': windSpeed, 'pressure': pressure,
    'visibility': visibility, 'weatherCondition': weatherCondition,
    'weatherDescription': weatherDescription, 'iconCode': iconCode,
    'country': country, 'sunrise': sunrise, 'sunset': sunset,
    'tempMin': tempMin, 'tempMax': tempMax, 'lat': lat, 'lon': lon,
    'uvIndex': uvIndex, 'aqi': aqi,
  };

  factory WeatherModel.fromMap(Map<String, dynamic> map) => WeatherModel(
    cityName: map['cityName'] as String,
    temperature: (map['temperature'] as num).toDouble(),
    feelsLike: (map['feelsLike'] as num).toDouble(),
    humidity: map['humidity'] as int,
    windSpeed: (map['windSpeed'] as num).toDouble(),
    pressure: map['pressure'] as int,
    visibility: map['visibility'] as int,
    weatherCondition: map['weatherCondition'] as String,
    weatherDescription: map['weatherDescription'] as String,
    iconCode: map['iconCode'] as String,
    country: map['country'] as String,
    sunrise: map['sunrise'] as int,
    sunset: map['sunset'] as int,
    tempMin: (map['tempMin'] as num).toDouble(),
    tempMax: (map['tempMax'] as num).toDouble(),
    lat: (map['lat'] as num?)?.toDouble(),
    lon: (map['lon'] as num?)?.toDouble(),
    uvIndex: map['uvIndex'] as int?,
    aqi: map['aqi'] as int?,
  );
}
