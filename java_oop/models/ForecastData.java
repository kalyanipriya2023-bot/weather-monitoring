package java_oop.models;

import java.util.Date;

/**
 * Demonstrates Inheritance:
 * - Extends WeatherData
 * - Adds specific fields for forecast prediction (dateTime, pop - probability of precipitation)
 * - Uses super() to invoke parent constructor
 */
public class ForecastData extends WeatherData {
    private Date forecastDate;
    private double precipitationProbability; // POP: 0.0 - 1.0

    public ForecastData() {
        super();
    }

    public ForecastData(String cityName, String country, double temperature, double feelsLike, 
                        int humidity, double windSpeed, int pressure, int visibility, 
                        String weatherCondition, String weatherDescription, String iconCode,
                        Date forecastDate, double precipitationProbability) {
        // Call parent constructor
        super(cityName, country, temperature, feelsLike, humidity, windSpeed, pressure, visibility, 
              weatherCondition, weatherDescription, iconCode);
        this.forecastDate = forecastDate;
        this.precipitationProbability = precipitationProbability;
    }

    // Getters and Setters
    public Date getForecastDate() {
        return forecastDate;
    }

    public void setForecastDate(Date forecastDate) {
        this.forecastDate = forecastDate;
    }

    public double getPrecipitationProbability() {
        return precipitationProbability;
    }

    public void setPrecipitationProbability(double precipitationProbability) {
        if (precipitationProbability >= 0.0 && precipitationProbability <= 1.0) {
            this.precipitationProbability = precipitationProbability;
        }
    }

    @Override
    public String toString() {
        return "ForecastData{date=" + forecastDate + ", pop=" + precipitationProbability + "} extends " + super.toString();
    }
}
