library;

class Tables {
  Tables._();

  static const String users = '''
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      passwordHash TEXT NOT NULL,
      profilePicturePath TEXT,
      createdAt TEXT NOT NULL
    )
  ''';

  static const String cities = '''
    CREATE TABLE IF NOT EXISTS cities (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      country TEXT,
      lat REAL NOT NULL,
      lon REAL NOT NULL,
      isFavorite INTEGER DEFAULT 0,
      lastSearched TEXT NOT NULL
    )
  ''';

  static const String weatherCache = '''
    CREATE TABLE IF NOT EXISTS weather_cache (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      cityName TEXT NOT NULL,
      data TEXT NOT NULL,
      cachedAt TEXT NOT NULL
    )
  ''';

  static const String weatherHistory = '''
    CREATE TABLE IF NOT EXISTS weather_history (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      cityName TEXT NOT NULL,
      temperature REAL NOT NULL,
      humidity INTEGER NOT NULL,
      windSpeed REAL NOT NULL,
      pressure INTEGER NOT NULL,
      weatherCondition TEXT NOT NULL,
      recordedAt TEXT NOT NULL
    )
  ''';

  static const String weatherAlerts = '''
    CREATE TABLE IF NOT EXISTS weather_alerts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      cityName TEXT NOT NULL,
      alertType INTEGER NOT NULL,
      severity INTEGER NOT NULL,
      message TEXT NOT NULL,
      createdAt TEXT NOT NULL,
      isRead INTEGER DEFAULT 0
    )
  ''';
}
