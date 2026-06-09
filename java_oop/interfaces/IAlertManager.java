package java_oop.interfaces;

import java_oop.models.WeatherData;

/**
 * Standard interface defining the Alert Manager contract.
 */
public interface IAlertManager {
    void processWeatherAlerts(WeatherData weather);
    void setThresholds(double tempMax, double windMax);
}
