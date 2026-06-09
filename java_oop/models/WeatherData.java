package java_oop.models;

import java.util.Objects;

/**
 * Standard Data Class demonstrating OOP state fields, constructor logic,
 * and standard methods override (toString, equals, hashCode).
 */
public class WeatherData {
    private String cityName;
    private String country;
    private double temperature;
    private double feelsLike;
    private int humidity;
    private double windSpeed;
    private int pressure;
    private int visibility;
    private String weatherCondition;
    private String weatherDescription;
    private String iconCode;

    public WeatherData() {}

    public WeatherData(String cityName, String country, double temperature, double feelsLike, 
                       int humidity, double windSpeed, int pressure, int visibility, 
                       String weatherCondition, String weatherDescription, String iconCode) {
        this.cityName = cityName;
        this.country = country;
        this.temperature = temperature;
        this.feelsLike = feelsLike;
        this.humidity = humidity;
        this.windSpeed = windSpeed;
        this.pressure = pressure;
        this.visibility = visibility;
        this.weatherCondition = weatherCondition;
        this.weatherDescription = weatherDescription;
        this.iconCode = iconCode;
    }

    // Getters and Setters
    public String getCityName() { return cityName; }
    public void setCityName(String cityName) { this.cityName = cityName; }

    public String getCountry() { return country; }
    public void setCountry(String country) { this.country = country; }

    public double getTemperature() { return temperature; }
    public void setTemperature(double temperature) { this.temperature = temperature; }

    public double getFeelsLike() { return feelsLike; }
    public void setFeelsLike(double feelsLike) { this.feelsLike = feelsLike; }

    public int getHumidity() { return humidity; }
    public void setHumidity(int humidity) { this.humidity = humidity; }

    public double getWindSpeed() { return windSpeed; }
    public void setWindSpeed(double windSpeed) { this.windSpeed = windSpeed; }

    public int getPressure() { return pressure; }
    public void setPressure(int pressure) { this.pressure = pressure; }

    public int getVisibility() { return visibility; }
    public void setVisibility(int visibility) { this.visibility = visibility; }

    public String getWeatherCondition() { return weatherCondition; }
    public void setWeatherCondition(String weatherCondition) { this.weatherCondition = weatherCondition; }

    public String getWeatherDescription() { return weatherDescription; }
    public void setWeatherDescription(String weatherDescription) { this.weatherDescription = weatherDescription; }

    public String getIconCode() { return iconCode; }
    public void setIconCode(String iconCode) { this.iconCode = iconCode; }

    @Override
    public String toString() {
        return "WeatherData{" +
                "cityName='" + cityName + '\'' +
                ", temperature=" + temperature +
                ", condition='" + weatherCondition + '\'' +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        WeatherData that = (WeatherData) o;
        return Double.compare(that.temperature, temperature) == 0 &&
                Objects.equals(cityName, that.cityName) &&
                Objects.equals(country, that.country);
    }

    @Override
    public int hashCode() {
        return Objects.hash(cityName, country, temperature);
    }
}
