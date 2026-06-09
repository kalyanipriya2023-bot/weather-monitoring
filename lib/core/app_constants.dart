library;

// API Configuration
const String kApiKey = '78c80433cc4864225d5fec8518f7b566';
const String kBaseUrl = 'https://api.openweathermap.org/data/2.5';
const String kGeoUrl = 'https://api.openweathermap.org/geo/1.0';
const String kIconUrl = 'https://openweathermap.org/img/wn/';
const String kIconSuffix = '@4x.png';
const String kUnits = 'metric';

// SharedPreferences Keys
const String kLastCityKey = 'last_searched_city';
const String kThemeModeKey = 'theme_mode';
const String kOnboardingCompleteKey = 'onboarding_complete';
const String kUserIdKey = 'current_user_id';
const String kIsGuestKey = 'is_guest';

// Defaults
const String kDefaultCity = 'London';
const int kCacheValidityMinutes = 30;
const int kApiTimeoutSeconds = 10;
const int kMaxRecentSearches = 10;

// App Info
const String kAppName = 'Smart Weather Monitor Pro';
const String kAppTagline = 'Predict. Analyze. Stay Ahead.';
const String kAppVersion = '2.0.0';
