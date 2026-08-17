import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data/models/city_weather.dart';
import '../widgets/weather_icon.dart';

/// Page de détail d'une ville : infos météo complètes
/// + localisation exacte sur Google Maps.
class DetailScreen extends StatelessWidget {
  final CityWeather weather;

  const DetailScreen({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final position = LatLng(weather.coord.lat, weather.coord.lon);

    return Scaffold(
      appBar: AppBar(title: Text(weather.cityName)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WeatherIcon(condition: weather.mainCondition, size: 56),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${weather.main.temp.round()}°C',
                            style: theme.textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(weather.descriptionCapitalized),
                          const SizedBox(height: 6),
                          Text(
                            'Ressenti ${weather.main.feelsLike.round()}°C · '
                            'Humidité ${weather.main.humidity}%',
                            style: theme.textTheme.bodySmall,
                          ),
                          Text(
                            'Vent ${weather.wind.speed.round()} km/h'
                            '${weather.sys.country != null ? ' · ${weather.sys.country}' : ''}',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Localisation exacte',
                style: theme.textTheme.titleSmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(target: position, zoom: 10),
                markers: {
                  Marker(
                    markerId: MarkerId(weather.cityName),
                    position: position,
                    infoWindow: InfoWindow(
                      title: weather.cityName,
                      snippet: weather.descriptionCapitalized,
                    ),
                  ),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
