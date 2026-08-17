import 'package:json_annotation/json_annotation.dart';

part 'city_weather.g.dart';

/// Représente les données météo d'une ville, telles que renvoyées
/// par l'API OpenWeather (endpoint /data/2.5/weather).
@JsonSerializable()
class CityWeather {
  @JsonKey(name: 'name')
  final String cityName;

  @JsonKey(name: 'main')
  final MainInfo main;

  @JsonKey(name: 'weather')
  final List<WeatherDescription> weather;

  @JsonKey(name: 'wind')
  final WindInfo wind;

  @JsonKey(name: 'coord')
  final Coordinates coord;

  @JsonKey(name: 'sys')
  final SysInfo sys;

  CityWeather({
    required this.cityName,
    required this.main,
    required this.weather,
    required this.wind,
    required this.coord,
    required this.sys,
  });

  factory CityWeather.fromJson(Map<String, dynamic> json) =>
      _$CityWeatherFromJson(json);

  Map<String, dynamic> toJson() => _$CityWeatherToJson(this);

  /// Description principale (ex: "ciel dégagé"), avec majuscule.
  String get descriptionCapitalized {
    if (weather.isEmpty) return '';
    final desc = weather.first.description;
    if (desc.isEmpty) return desc;
    return desc[0].toUpperCase() + desc.substring(1);
  }

  /// Code icône OpenWeather (ex: "01d") utilisé pour choisir un pictogramme.
  String get iconCode => weather.isNotEmpty ? weather.first.icon : '01d';

  /// Condition météo principale (ex: "Clear", "Rain", "Clouds"...).
  String get mainCondition =>
      weather.isNotEmpty ? weather.first.main : 'Clear';
}

@JsonSerializable()
class MainInfo {
  final double temp;

  @JsonKey(name: 'feels_like')
  final double feelsLike;

  final int humidity;

  @JsonKey(name: 'temp_min')
  final double tempMin;

  @JsonKey(name: 'temp_max')
  final double tempMax;

  MainInfo({
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    required this.tempMin,
    required this.tempMax,
  });

  factory MainInfo.fromJson(Map<String, dynamic> json) =>
      _$MainInfoFromJson(json);

  Map<String, dynamic> toJson() => _$MainInfoToJson(this);
}

@JsonSerializable()
class WeatherDescription {
  final int id;
  final String main;
  final String description;
  final String icon;

  WeatherDescription({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory WeatherDescription.fromJson(Map<String, dynamic> json) =>
      _$WeatherDescriptionFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherDescriptionToJson(this);
}

@JsonSerializable()
class WindInfo {
  final double speed;

  WindInfo({required this.speed});

  factory WindInfo.fromJson(Map<String, dynamic> json) =>
      _$WindInfoFromJson(json);

  Map<String, dynamic> toJson() => _$WindInfoToJson(this);
}

@JsonSerializable()
class Coordinates {
  final double lat;
  final double lon;

  Coordinates({required this.lat, required this.lon});

  factory Coordinates.fromJson(Map<String, dynamic> json) =>
      _$CoordinatesFromJson(json);

  Map<String, dynamic> toJson() => _$CoordinatesToJson(this);
}

@JsonSerializable()
class SysInfo {
  final String? country;

  SysInfo({this.country});

  factory SysInfo.fromJson(Map<String, dynamic> json) =>
      _$SysInfoFromJson(json);

  Map<String, dynamic> toJson() => _$SysInfoToJson(this);
}
