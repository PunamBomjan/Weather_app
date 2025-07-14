import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';
import '../utilities/constants.dart'; // Make sure apiKey is defined here

class WeatherService {
  /// Fetch weather data by city name
  Future<Weather> fetchWeather(String cityName) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return Weather.fromJson(jsonBody);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to load weather data');
    }
  }

  /// Fetch weather data using current location (latitude & longitude)
  Future<Weather> fetchWeatherByLocation(Position position) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return Weather.fromJson(jsonBody);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Failed to load weather data');
    }
  }
}
