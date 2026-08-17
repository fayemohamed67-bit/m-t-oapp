import 'package:flutter/material.dart';

/// Pictogramme météo simple basé sur la condition principale
/// renvoyée par OpenWeather ("Clear", "Rain", "Clouds", ...).
class WeatherIcon extends StatelessWidget {
  final String condition;
  final double size;

  const WeatherIcon({super.key, required this.condition, this.size = 32});

  IconData get _icon {
    switch (condition) {
      case 'Clear':
        return Icons.wb_sunny_rounded;
      case 'Clouds':
        return Icons.cloud_rounded;
      case 'Rain':
      case 'Drizzle':
        return Icons.water_drop_rounded;
      case 'Thunderstorm':
        return Icons.flash_on_rounded;
      case 'Snow':
        return Icons.ac_unit_rounded;
      case 'Mist':
      case 'Fog':
      case 'Haze':
        return Icons.blur_on_rounded;
      default:
        return Icons.cloud_queue_rounded;
    }
  }

  Color get _color {
    switch (condition) {
      case 'Clear':
        return Colors.orange;
      case 'Rain':
      case 'Drizzle':
      case 'Thunderstorm':
        return Colors.blueAccent;
      case 'Snow':
        return Colors.lightBlueAccent;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Icon(_icon, size: size, color: _color);
  }
}
