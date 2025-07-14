import 'package:flutter/material.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final TextEditingController cityController = TextEditingController();

  void submitCity() {
    final cityName = cityController.text.trim();
    if (cityName.isNotEmpty) {
      Navigator.pop(context, cityName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search City'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: cityController,
              decoration: const InputDecoration(
                labelText: 'Enter city name',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => submitCity(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitCity,
              child: const Text('Get Weather'),
            ),
          ],
        ),
      ),
    );
  }
}
