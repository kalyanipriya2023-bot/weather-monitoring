library;

class CityModel {
  final int? id;
  final String name;
  final String country;
  final double lat;
  final double lon;
  final bool isFavorite;
  final DateTime lastSearched;

  const CityModel({
    this.id,
    required this.name,
    required this.country,
    required this.lat,
    required this.lon,
    this.isFavorite = false,
    required this.lastSearched,
  });

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'name': name, 'country': country,
    'lat': lat, 'lon': lon,
    'isFavorite': isFavorite ? 1 : 0,
    'lastSearched': lastSearched.toIso8601String(),
  };

  factory CityModel.fromMap(Map<String, dynamic> map) => CityModel(
    id: map['id'] as int?,
    name: map['name'] as String,
    country: map['country'] as String? ?? '',
    lat: (map['lat'] as num).toDouble(),
    lon: (map['lon'] as num).toDouble(),
    isFavorite: (map['isFavorite'] as int?) == 1,
    lastSearched: DateTime.parse(map['lastSearched'] as String),
  );

  CityModel copyWith({bool? isFavorite}) => CityModel(
    id: id, name: name, country: country, lat: lat, lon: lon,
    isFavorite: isFavorite ?? this.isFavorite, lastSearched: lastSearched,
  );

  String get displayName => country.isNotEmpty ? '$name, $country' : name;
}
