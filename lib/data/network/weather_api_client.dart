import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/city_weather.dart';

part 'weather_api_client.g.dart';

/// Client Retrofit pour l'API OpenWeather.
/// Doc: https://openweathermap.org/current
@RestApi(baseUrl: 'https://api.openweathermap.org/data/2.5')
abstract class WeatherApiClient {
  factory WeatherApiClient(Dio dio, {String baseUrl}) = _WeatherApiClient;

  @GET('/weather')
  Future<CityWeather> getWeatherByCity(
    @Query('q') String city,
    @Query('appid') String apiKey, {
    @Query('units') String units = 'metric',
    @Query('lang') String lang = 'fr',
  });
}
