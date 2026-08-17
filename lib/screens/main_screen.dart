import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/weather_provider.dart';
import '../widgets/animated_gauge.dart';
import '../widgets/city_weather_tile.dart';
import '../widgets/error_view.dart';
import 'detail_screen.dart';

/// "Écran principal" : jauge animée + appels API + messages d'attente,
/// puis tableau interactif des 5 villes. La jauge se transforme en
/// bouton "Recommencer" une fois le chargement terminé.
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WeatherProvider>(
      create: (_) => WeatherProvider()..startExperience(),
      child: const _MainScreenBody(),
    );
  }
}

class _MainScreenBody extends StatelessWidget {
  const _MainScreenBody();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Météo des 5 villes'),
        // Le bouton back natif de l'AppBar ramène toujours à l'accueil.
      ),
      body: SafeArea(
        child: provider.hasError
            ? Center(
                child: ErrorView(
                  message: provider.errorMessage ?? 'Erreur inconnue.',
                  onRetry: provider.retry,
                ),
              )
            : Column(
                children: [
                  const SizedBox(height: 24),
                  AnimatedGauge(
                    progress: provider.progress,
                    isCompleted: provider.isCompleted,
                    onRestart: provider.startExperience,
                  ),
                  const SizedBox(height: 16),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: provider.isLoading
                        ? Padding(
                            key: ValueKey(provider.loadingMessage),
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              provider.loadingMessage,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          )
                        : const SizedBox(
                            key: ValueKey('empty'),
                            height: 0,
                          ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: provider.isCompleted
                        ? ListView.builder(
                            padding: const EdgeInsets.only(top: 8, bottom: 24),
                            itemCount: provider.cities.length,
                            itemBuilder: (context, index) {
                              final city = provider.cities[index];
                              return CityWeatherTile(
                                weather: city,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => DetailScreen(weather: city),
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
      ),
    );
  }
}
