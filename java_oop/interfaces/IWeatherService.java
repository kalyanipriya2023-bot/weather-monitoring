package java_oop.interfaces;

import java_oop.models.WeatherData;
import java_oop.models.ForecastData;
import java.util.List;

/**
 * Demonstrates Abstraction:
 * - Defines interface methods without implementation
 * - Standardizes weather fetch telemetry contracts
 */
public interface IWeatherService {
    WeatherData fetchCurrentWeather(String city) throws Exception;
    List<ForecastData> fetchForecast(String city) throws Exception;
}
