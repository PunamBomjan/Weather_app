import 'package:flutter/material.dart';

class WeatherDisplay extends StatelessWidget {
  final String condition;

  const WeatherDisplay({super.key, required this.condition});

  @override
  Widget build(BuildContext context) {
    String backgroundImage;

    switch (condition) {
      case 'sunny':
        backgroundImage = 'assets/sunny_background.jpg';
        break;
      case 'partly_cloudy':
        backgroundImage = 'assets/partly_cloudy_background.jpg';
        break;
      case 'cloudy':
        backgroundImage = 'assets/cloudy_background.jpg';
        break;
      case 'rainy':
        backgroundImage = 'assets/rainy_background.jpg';
        break;
      case 'thunder':
        backgroundImage = 'assets/thunder_background.jpg';
        break;
      case 'humidity':
        backgroundImage = 'assets/humidity_background.jpg';
        break;
      case 'snow':
        backgroundImage = 'assets/snow_background.jpg';
        break;
      case 'fog':
        backgroundImage = 'assets/fog_background.jpg';
        break;
      default:
        backgroundImage = 'assets/default_background.jpg';
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundImage),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
