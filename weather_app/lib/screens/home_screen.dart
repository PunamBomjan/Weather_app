import 'package:flutter/material.dart';
import 'package:weather_app/services/weather_service.dart';
import '../models/weather_model.dart';
import '../widgets/weather_detail_card.dart';
import '../widgets/weather_display.dart';
import 'location_screen.dart';

class HomeScreen extends StatefulWidget {
  final Weather? weather;
  final String? errorMessage;

  const HomeScreen({super.key, this.weather, this.errorMessage});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Weather? currentWeather;
  String? error;

  @override
  void initState() {
    super.initState();
    currentWeather = widget.weather;
    error = widget.errorMessage;
  }

  void updateWeather(Weather newWeather) {
    setState(() {
      currentWeather = newWeather;
      error = null;
    });
  }

  void updateError(String msg) {
    setState(() {
      error = msg;
      currentWeather = null;
    });
  }

  String _mapWeatherToCondition(String iconCode) {
    if (iconCode.contains('01')) return 'sunny';
    if (iconCode.contains('02')) return 'partly_cloudy';
    if (iconCode.contains('03') || iconCode.contains('04')) return 'cloudy';
    if (iconCode.contains('09') || iconCode.contains('10')) return 'rainy';
    if (iconCode.contains('11')) return 'thunder';
    if (iconCode.contains('13')) return 'snow';
    if (iconCode.contains('50')) return 'fog';
    return 'sunny';
  }

  String _getEmoji(String condition) {
    switch (condition) {
      case 'sunny':
        return '☀️☀️';
      case 'partly_cloudy':
        return '⛅🌤️';
      case 'cloudy':
        return '☁️☁️';
      case 'rainy':
        return '🌧️🌧️';
      case 'thunder':
        return '⚡⛈️';
      case 'humidity':
        return '💧💧';
      case 'snow':
        return '❄️🌨️';
      case 'fog':
        return '🌫️🌁';
      default:
        return '☀️☀️';
    }
  }

  @override
  Widget build(BuildContext context) {
    final condition = currentWeather != null
        ? _mapWeatherToCondition(currentWeather!.icon)
        : '';

    final emoji = _getEmoji(condition);

    return Scaffold(
      body: currentWeather == null
          ? Center(
              child: error != null
                  ? Text(
                      error!,
                      style: const TextStyle(color: Colors.red, fontSize: 20),
                    )
                  : const CircularProgressIndicator(),
            )
          : Stack(
              children: [
                // Background only
                WeatherDisplay(condition: condition),

                // AppBar
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AppBar(
                    title: const Text('Weather App'),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.search,
                            color: Color.fromARGB(255, 255, 255, 255)),
                        onPressed: () async {
                          final typedCity = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LocationScreen()),
                          );
                          if (typedCity is String && typedCity.isNotEmpty) {
                            final weatherService = WeatherService();
                            try {
                              final weather =
                                  await weatherService.fetchWeather(typedCity);
                              updateWeather(weather);
                            } catch (e) {
                              updateError('City not found or error occurred.');
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),

                // Main Weather Content
                Positioned.fill(
                  top: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Centered Emoji
                      Text(
                        emoji,
                        style: const TextStyle(fontSize: 70),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 10),

                      // City name
                      Text(
                        currentWeather!.cityName,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Temperature
                      Text(
                        '${currentWeather!.temperature.toStringAsFixed(1)}°C',
                        style: const TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Weather condition name
                      Text(
                        condition.toUpperCase().replaceAll('_', ' '),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Humidity and Wind Cards
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            WeatherDetailCard(
                              icon: Icons.water_drop,
                              label: 'Humidity',
                              value: '${currentWeather!.humidity}%',
                            ),
                            WeatherDetailCard(
                              icon: Icons.air,
                              label: 'Wind',
                              value:
                                  '${currentWeather!.windSpeed.toStringAsFixed(1)} m/s',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
