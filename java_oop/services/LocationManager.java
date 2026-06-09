package java_oop.services;

// Product Interface
interface ILocationProvider {
    String getProviderName();
    double[] getCoords(String city);
}

// Concrete Product A: GPS Provider
class GpsLocationProvider implements ILocationProvider {
    @Override
    public String getProviderName() { return "GPS_HARDWARE"; }

    @Override
    public double[] getCoords(String city) {
        // Mock hardware coordinate fetch
        return new double[]{51.5074, -0.1278}; // London
    }
}

// Concrete Product B: IP Geo Provider
class IpGeoProvider implements ILocationProvider {
    @Override
    public String getProviderName() { return "IP_GEO_SERVICE"; }

    @Override
    public double[] getCoords(String city) {
        // Mock IP trace fetch
        return new double[]{40.7128, -74.0060}; // New York
    }
}

/**
 * Design Pattern Demo: Factory Pattern
 * - Decouples object creation logic from client usage
 * - Creates different location providers dynamically
 */
public class LocationManager {
    public static ILocationProvider getProvider(String type) {
        if ("GPS".equalsIgnoreCase(type)) {
            return new GpsLocationProvider();
        } else if ("IP".equalsIgnoreCase(type)) {
            return new IpGeoProvider();
        }
        throw new IllegalArgumentException("Unknown provider type: " + type);
    }
}
