//from as5 foodfinder weather_checker.dart
import 'package:yourlittlepal/providers/weather_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yourlittlepal/weather_conditions.dart';

class WeatherChecker {
  final WeatherProvider weatherProvider;
  double _latitude = 0;
  double _longitude = 0;
  http.Client? client;

  WeatherChecker(this.weatherProvider, {this.client});

  void updateLocation(double latitude, double longitude){
    _longitude = longitude;
    _latitude = latitude;
  }

  Future<void> fetchAndUpdateCurrentWeather() async {
    try {
      final http.Client client = this.client ?? http.Client();
      final gridResponse = await client.get(
          Uri.parse('https://api.weather.gov/points/$_latitude,$_longitude'));
      final gridParsed = (jsonDecode(gridResponse.body));
      final String? forecastURL = gridParsed['properties']?['forecast'];
      if (forecastURL == null) {
        // do nothing
      } else {
        final weatherResponse = await client.get(Uri.parse(forecastURL));
        final weatherParsed = jsonDecode(weatherResponse.body);
        final currentPeriod = weatherParsed['properties']?['periods']?[0];
        if (currentPeriod != null) {
          final temperature = currentPeriod['temperature'];
          final shortForecast = currentPeriod['shortForecast'];
          print(
              'Got the weather at ${DateTime.now()}. $temperature F and $shortForecast');
          if (temperature != null && shortForecast != null) {
            final condition = _shortForecastToCondition(shortForecast);
            weatherProvider.updateWeather(temperature, condition);
          }
        }
      }
    } catch (_) {
      weatherProvider.updateData();
    } finally {
      client?.close();
      client = null;
    }
  }

  WeatherCondition _shortForecastToCondition(String shortForecast) {
    final lowercased = shortForecast.toLowerCase();
    if (lowercased.startsWith('rain')) return WeatherCondition.rainy;
    if (lowercased.startsWith('sun') || lowercased.startsWith('partly')) {
      return WeatherCondition.sunny;
    }
    return WeatherCondition.gloomy;
  }
}  
