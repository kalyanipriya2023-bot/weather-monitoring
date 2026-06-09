import 'package:flutter_test/flutter_test.dart';
import 'package:smart_weather_monitor_pro/models/weather_model.dart';

void main() {
  group('WeatherModel', () {
    test('fromJson parses valid API response', () {
      final json = {
        'name': 'London',
        'main': {
          'temp': 15.5,
          'feels_like': 14.2,
          'humidity': 72,
          'pressure': 1013,
          'temp_min': 13.0,
          'temp_max': 17.0,
        },
        'weather': [
          {
            'main': 'Clouds',
            'description': 'overcast clouds',
            'icon': '04d',
          }
        ],
        'wind': {'speed': 5.1},
        'visibility': 10000,
        'sys': {
          'country': 'GB',
          'sunrise': 1700000000,
          'sunset': 1700040000,
        },
      };

      final weather = WeatherModel.fromJson(json);

      expect(weather.cityName, 'London');
      expect(weather.temperature, 15.5);
      expect(weather.feelsLike, 14.2);
      expect(weather.humidity, 72);
      expect(weather.windSpeed, 5.1);
      expect(weather.pressure, 1013);
      expect(weather.visibility, 10000);
      expect(weather.weatherCondition, 'Clouds');
      expect(weather.weatherDescription, 'overcast clouds');
      expect(weather.iconCode, '04d');
      expect(weather.country, 'GB');
      expect(weather.visibilityKm, 10.0);
      expect(weather.capitalizedDescription, 'Overcast clouds');
    });
  });
}
