package java_oop.services;

import java_oop.interfaces.IAlertManager;
import java_oop.models.WeatherData;
import java.util.ArrayList;
import java.util.List;

// Observer interface
interface IWeatherObserver {
    void onWeatherAlert(String type, String message);
}

/**
 * Design Pattern Demo: Observer Pattern
 * - Maintains a list of observers
 * - Notifies all subscribers when weather alert thresholds are crossed
 */
public class AlertManager implements IAlertManager {
    private List<IWeatherObserver> observers = new ArrayList<>();
    private double maxTempThreshold = 35.0; // °C
    private double maxWindThreshold = 40.0; // km/h

    public void addObserver(IWeatherObserver observer) {
        observers.add(observer);
    }

    public void removeObserver(IWeatherObserver observer) {
        observers.remove(observer);
    }

    @Override
    public void setThresholds(double tempMax, double windMax) {
        this.maxTempThreshold = tempMax;
        this.maxWindThreshold = windMax;
    }

    @Override
    public void processWeatherAlerts(WeatherData weather) {
        // Check temperature threshold
        if (weather.getTemperature() > maxTempThreshold) {
            notifyObservers("Heat Wave Alert", "Dangerous temperature level detected: " + weather.getTemperature() + "°C");
        }
        
        // Check wind threshold
        double windKmh = weather.getWindSpeed() * 3.6;
        if (windKmh > maxWindThreshold) {
            notifyObservers("Storm Alert", "Severe wind speed detected: " + Math.round(windKmh) + " km/h");
        }
    }

    private void notifyObservers(String alertType, String message) {
        for (IWeatherObserver observer : observers) {
            observer.onWeatherAlert(alertType, message);
        }
    }
}
