package java_oop.services;

import java_oop.models.WeatherData;
import java.util.List;

// Strategy Interface
interface IAnalyticsStrategy {
    double calculateMetric(List<WeatherData> history);
}

// Concrete Strategy: Mean calculation
class MeanTemperatureStrategy implements IAnalyticsStrategy {
    @Override
    public double calculateMetric(List<WeatherData> history) {
        if (history == null || history.isEmpty()) return 0.0;
        double sum = 0.0;
        for (WeatherData w : history) {
            sum += w.getTemperature();
        }
        return sum / history.size();
    }
}

// Concrete Strategy: Max temp calculation
class MaxTemperatureStrategy implements IAnalyticsStrategy {
    @Override
    public double calculateMetric(List<WeatherData> history) {
        if (history == null || history.isEmpty()) return -999.0;
        double max = -999.0;
        for (WeatherData w : history) {
            if (w.getTemperature() > max) {
                max = w.getTemperature();
            }
        }
        return max;
    }
}

/**
 * Design Pattern Demo: Strategy Pattern
 * - Encapsulates interchangeable analytics algorithms
 * - Switches calculation strategies at runtime
 */
public class AnalyticsManager {
    private IAnalyticsStrategy strategy;

    public void setStrategy(IAnalyticsStrategy strategy) {
        this.strategy = strategy;
    }

    public double compute(List<WeatherData> history) {
        if (strategy == null) {
            throw new IllegalStateException("Strategy not set");
        }
        return strategy.calculateMetric(history);
    }
}
