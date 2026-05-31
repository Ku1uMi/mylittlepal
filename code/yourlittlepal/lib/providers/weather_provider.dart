//from as5 foodfinder weather_provider.dart

import 'package:flutter/material.dart';
import 'package:yourlittlepal/weather_conditions.dart';
import 'package:yourlittlepal/weather_checker.dart';
import 'dart:async';

class WeatherProvider extends ChangeNotifier {
  int tempInFahrenheit = 0;
  WeatherCondition condition = WeatherCondition.unknown;
  late WeatherChecker _checker;
  bool isValid = false;
  bool error = false;

  WeatherProvider(){
    _checker = WeatherChecker(this);
    _checker.fetchAndUpdateCurrentWeather();
    //ignore: unused_local_variable
    final Timer weatherCheckerTime = Timer.periodic(
      const Duration(seconds: 60), 
      (_) => _checker.fetchAndUpdateCurrentWeather());
  }

  //update weather condition 
  //Parameters:
  // - newTempFahrenheit: new temperature
  // - newCondition: new weather condition
  void updateWeather(int newTempFahrenheit, WeatherCondition newCondition) {
    isValid = true;
    error = false;
    tempInFahrenheit = newTempFahrenheit;
    condition = newCondition;
    notifyListeners();
  }

  void updateLocation(double latitude, double longitude){
    _checker.updateLocation(latitude, longitude);
    _checker.fetchAndUpdateCurrentWeather();
  }

  //notify users whether the data are updated successfully or not
  void updateData(){
    error = true;
    notifyListeners();
  }
}
