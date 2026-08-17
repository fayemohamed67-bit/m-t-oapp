import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/constants.dart';
import '../data/models/city_weather.dart';
import '../data/repository/weather_repository.dart';

enum LoadingStatus { idle, loading, completed, error }

/// Pilote toute la logique de "l'écran principal" :
/// - fait avancer la jauge de progression pendant les appels API,
/// - fait défiler les messages d'attente,
/// - va chercher la météo des 5 villes (toutes les quelques secondes),
/// - gère les erreurs et permet de relancer l'expérience.
class WeatherProvider extends ChangeNotifier {
  final WeatherRepository _repository;

  WeatherProvider({WeatherRepository? repository})
      : _repository = repository ?? WeatherRepository();

  LoadingStatus status = LoadingStatus.idle;
  double progress = 0.0;
  int _messageIndex = 0;
  String? errorMessage;

  final List<CityWeather> cities = [];

  Timer? _messageTimer;

  String get loadingMessage =>
      AppConstants.loadingMessages[_messageIndex % AppConstants.loadingMessages.length];

  bool get isLoading => status == LoadingStatus.loading;
  bool get isCompleted => status == LoadingStatus.completed;
  bool get hasError => status == LoadingStatus.error;

  /// Lance (ou relance depuis zéro) toute l'expérience : jauge à 0,
  /// puis récupération séquentielle de la météo des 5 villes.
  Future<void> startExperience() async {
    _messageTimer?.cancel();
    status = LoadingStatus.loading;
    progress = 0.0;
    _messageIndex = 0;
    errorMessage = null;
    cities.clear();
    notifyListeners();

    _messageTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) {
        _messageIndex++;
        notifyListeners();
      },
    );

    final citiesToFetch = AppConstants.cities;
    final total = citiesToFetch.length;

    for (var i = 0; i < total; i++) {
      try {
        final weather = await _repository.fetchWeather(citiesToFetch[i]);
        cities.add(weather);
        progress = (i + 1) / total;
        notifyListeners();
      } catch (e) {
        _messageTimer?.cancel();
        status = LoadingStatus.error;
        errorMessage = e.toString();
        notifyListeners();
        return;
      }

      if (i < total - 1) {
        await Future.delayed(
          const Duration(seconds: AppConstants.secondsBetweenCalls),
        );
      }
    }

    _messageTimer?.cancel();
    status = LoadingStatus.completed;
    progress = 1.0;
    notifyListeners();
  }

  /// Relance l'expérience après une erreur (bouton "Réessayer").
  void retry() => startExperience();

  /// Remet tout à zéro (retour à l'écran d'accueil).
  void reset() {
    _messageTimer?.cancel();
    status = LoadingStatus.idle;
    progress = 0.0;
    _messageIndex = 0;
    errorMessage = null;
    cities.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    super.dispose();
  }
}
