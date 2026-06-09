library;

enum AlertSeverity { low, medium, high, critical }
enum AlertType { heatWave, rain, storm, highWind, poorAqi, cold, snow }

class WeatherAlertModel {
  final int? id;
  final String cityName;
  final AlertType alertType;
  final AlertSeverity severity;
  final String message;
  final DateTime createdAt;
  final bool isRead;

  const WeatherAlertModel({
    this.id,
    required this.cityName,
    required this.alertType,
    required this.severity,
    required this.message,
    required this.createdAt,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'cityName': cityName,
    'alertType': alertType.index,
    'severity': severity.index,
    'message': message,
    'createdAt': createdAt.toIso8601String(),
    'isRead': isRead ? 1 : 0,
  };

  factory WeatherAlertModel.fromMap(Map<String, dynamic> map) => WeatherAlertModel(
    id: map['id'] as int?,
    cityName: map['cityName'] as String,
    alertType: AlertType.values[map['alertType'] as int],
    severity: AlertSeverity.values[map['severity'] as int],
    message: map['message'] as String,
    createdAt: DateTime.parse(map['createdAt'] as String),
    isRead: (map['isRead'] as int?) == 1,
  );

  String get alertTypeLabel => switch (alertType) {
    AlertType.heatWave => 'Heat Wave',
    AlertType.rain => 'Heavy Rain',
    AlertType.storm => 'Thunderstorm',
    AlertType.highWind => 'High Wind',
    AlertType.poorAqi => 'Poor Air Quality',
    AlertType.cold => 'Extreme Cold',
    AlertType.snow => 'Heavy Snow',
  };

  String get severityLabel => switch (severity) {
    AlertSeverity.low => 'Low',
    AlertSeverity.medium => 'Medium',
    AlertSeverity.high => 'High',
    AlertSeverity.critical => 'Critical',
  };
}
