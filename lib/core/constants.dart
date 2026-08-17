

import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Constantes globales de l'application.
class AppConstants {
  AppConstants._();

  /// Les 5 villes affichées par l'application.
  /// Tu peux librement changer cette liste.
  static const List<String> cities = [
    'Dakar',
    'Paris',
    'New York',
    'Tokyo',
    'Dubai',
  ];

  /// Messages d'attente affichés en boucle pendant le chargement.
  static const List<String> loadingMessages = [
    'Nous téléchargeons les données…',
    'Interrogation du satellite météo…',
    'C\'est presque fini…',
    'Plus que quelques secondes avant d\'avoir le résultat…',
  ];

  /// Délai entre deux appels API (en secondes), pour respecter
  /// la consigne "toutes les quelques secondes".
  static const int secondsBetweenCalls = 2;

  /// Clé API OpenWeather, lue depuis le fichier .env (voir .env.example).
  static String get openWeatherApiKey => dotenv.env['OPENWEATHER_API_KEY'] ?? '';
}
