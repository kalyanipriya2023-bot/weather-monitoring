library;

class CityNotFoundException implements Exception {
  final String message;
  const CityNotFoundException([this.message = 'City not found. Please check the name and try again.']);
  @override
  String toString() => message;
}

class NoInternetException implements Exception {
  final String message;
  const NoInternetException([this.message = 'No internet connection. Please check your network.']);
  @override
  String toString() => message;
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  const ApiException([this.message = 'Something went wrong', this.statusCode]);
  @override
  String toString() => message;
}

class AuthException implements Exception {
  final String message;
  const AuthException([this.message = 'Authentication error']);
  @override
  String toString() => message;
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Cache error']);
  @override
  String toString() => message;
}
