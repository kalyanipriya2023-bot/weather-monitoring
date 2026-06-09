package java_oop.services;

import java_oop.interfaces.IWeatherService;

/**
 * Design Pattern Demo: Singleton
 * - Private constructor
 * - Static instance reference
 * - Thread-safe lazy initialization
 */
public class WeatherManager {
    private static WeatherManager instance;
    private IWeatherService activeService;

    // Private constructor prevents instantiation outside
    private WeatherManager() {
        // Default initialized with mock key
        this.activeService = new WeatherService("78c80433cc4864225d5fec8518f7b566");
    }

    // Static access point
    public static synchronized WeatherManager getInstance() {
        if (instance == null) {
            instance = new WeatherManager();
        }
        return instance;
    }

    public IWeatherService getActiveService() {
        return activeService;
    }

    public void registerService(IWeatherService service) {
        if (service != null) {
            this.activeService = service;
        }
    }
}
