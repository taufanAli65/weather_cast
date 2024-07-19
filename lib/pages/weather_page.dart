import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:weather_cast/models/weather_model.dart';
import 'package:weather_cast/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('0ed8f03a0965babf5db9384c5be22fe7');
  Weather? _weather;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    print('Fetching weather for: $cityName'); // Log cityName

    try {
      final weather = await _weatherService.getWeather(cityName);
      print('Weather data: $weather'); // Log weather data

      setState(() {
        _weather = weather;
      });
    } catch (err) {
      print('Error: $err'); // Log error
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/cerah.json'; //default auto sunny

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/cerah-berawan.json';
      case 'fog':
        return 'assets/cerah-berawan.json';
      case 'rain':
        return 'assets/hujan-ringan.json';
      case 'shower rain':
        return 'assets/hujan-ringan.json';
      case 'thunderstorm':
        return 'assets/hujan-deras.json';
      case 'clear':
        return 'assets/cerah.json';
      default:
        return 'assets/cerah.json';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('EEEE, MMM d, yyyy').format(now);
    final String formattedTime = DateFormat('hh:mm a').format(now);

    return Scaffold(
      backgroundColor: Color(0xFF444575),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0), // Padding at the top
              child: Column(
                children: [
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    formattedTime,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    _weather?.cityName ?? "Memuat Kota...",
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(), // Spacer to push the Lottie animation to the center
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
            Spacer(), // Spacer to push the temperature and main condition to the bottom
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text(
                _weather != null ? '${_weather!.temperature.round()}°C' : 'Memuat Temperatur...',
                style: TextStyle(
                  fontSize: 60.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Text(
                _weather?.mainCondition ?? "Memuat Cuaca...",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}