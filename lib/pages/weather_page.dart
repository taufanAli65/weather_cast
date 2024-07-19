import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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

    switch(mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cerah-berawan.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/hujan-ringan.json';
      case 'thunderstorm':
        return 'assets/hujan-deras.json';
      case 'clear':
        return 'assets/cerah.json';
      default :
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
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_weather?.cityName ?? "Memuat Kota..."),
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
            Text(_weather != null ? '${_weather!.temperature.round()} C' : 'Memuat Temperatur...'),
            Text(_weather?.mainCondition ?? "Memuat Cuaca...")
          ],
        ),
      ),
    );
  }
}
