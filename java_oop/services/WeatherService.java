package java_oop.services;

import java_oop.interfaces.IWeatherService;
import java_oop.models.WeatherData;
import java_oop.models.ForecastData;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Demonstrates Polymorphism (Interface implementation & method overriding):
 * - Implements IWeatherService interface contracts
 * - Simulates data fetching logic
 */
public class WeatherService implements IWeatherService {
    private String apiKey;

    public WeatherService(String apiKey) {
        this.apiKey = apiKey;
    }

    @Override
    public WeatherData fetchCurrentWeather(String city) throws Exception {
        // Mock remote data fetch
        System.out.println("Fetching current weather via service for: " + city);
        return new WeatherData(city, "GB", 18.5, 17.0, 72, 5.4, 1013, 10000, "Clouds", "overcast clouds", "04d");
    }

    @Override
    public List<ForecastData> fetchForecast(String city) throws Exception {
        // Mock forecast list fetch
        System.out.println("Fetching forecast via service for: " + city);
        List<ForecastData> list = new ArrayList<>();
        
        long oneDayMs = 24 * 60 * 60 * 1000L;
        Date now = new Date();
        
        list.add(new ForecastData(city, "GB", 19.0, 18.0, 65, 4.2, 1012, 10000, "Clear", "sky is clear", "01d", new Date(now.getTime() + oneDayMs), 0.1));
        list.add(new ForecastData(city, "GB", 17.5, 16.5, 78, 6.0, 1010, 8000, "Rain", "light rain", "10d", new Date(now.getTime() + 2 * oneDayMs), 0.8));
        
        return list;
    }
}
