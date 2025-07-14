import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/location_service.dart';
import '../services/weather_service.dart';
import 'home_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key}); // uses super.key as recommended

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final LocationService _locationService = LocationService();
  final WeatherService _weatherService = WeatherService();

  @override
  void initState() {
    super.initState();
    getLocationAndWeather();
  }

  Future<void> getLocationAndWeather() async {
    try {
      final position = await _locationService.getCurrentLocation();
      final weather = await _weatherService.fetchWeatherByLocation(position);

      if (!mounted) return; // ✅ avoid using context if widget is disposed

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(weather: weather),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              HomeScreen(weather: null, errorMessage: e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: const Center(
        child: SpinKitFadingCircle(
          color: Colors.white,
          size: 80.0,
        ),
      ),
    );
  }
}
