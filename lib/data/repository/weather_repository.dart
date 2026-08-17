import 'package:dio/dio.dart';

import '../../core/constants.dart';
import '../models/city_weather.dart';
import '../network/weather_api_client.dart';

/// Exception applicative levée quand la récupération météo échoue,
/// avec un message lisible destiné à l'utilisateur.
class WeatherFetchException implements Exception {
  final String message;
  WeatherFetchException(this.message);

  @override
  String toString() => message;
}

/// Couche d'accès aux données météo : encapsule Dio + Retrofit
/// et transforme les erreurs réseau en messages compréhensibles.
class WeatherRepository {
  final WeatherApiClient _apiClient;

  WeatherRepository({Dio? dio})
      : _apiClient = WeatherApiClient(
          dio ??
              Dio(
                BaseOptions(
                  connectTimeout: const Duration(seconds: 10),
                  receiveTimeout: const Duration(seconds: 10),
                ),
              ),
        );

  Future<CityWeather> fetchWeather(String city) async {
    try {
      if (AppConstants.openWeatherApiKey.isEmpty) {
        throw WeatherFetchException(
          'Clé API météo manquante. Ajoute-la dans le fichier .env '
          '(voir .env.example).',
        );
      }
      return await _apiClient.getWeatherByCity(
        city,
        AppConstants.openWeatherApiKey,
      );
    } on DioException catch (e) {
      throw WeatherFetchException(_messageFromDioException(e, city));
    }
  }

  String _messageFromDioException(DioException e, String city) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'La connexion a expiré en récupérant la météo de $city. '
            'Vérifie ta connexion internet.';
      case DioExceptionType.connectionError:
        return 'Impossible de contacter le serveur météo. '
            'Vérifie ta connexion internet.';
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode;
        if (status == 401) {
          return 'Clé API invalide ou non activée. '
              'Vérifie ta clé OpenWeather dans le fichier .env.';
        }
        if (status == 404) {
          return 'Ville "$city" introuvable.';
        }
        return 'Erreur serveur ($status) pour $city.';
      default:
        return 'Une erreur est survenue en récupérant la météo de $city.';
    }
  }
}
