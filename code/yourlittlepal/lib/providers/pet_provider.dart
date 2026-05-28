import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
//import 'package:yourlittlepal/models/petInfo.dart';
import 'package:yourlittlepal/models/pet_state.dart';
import 'package:yourlittlepal/providers/pet_logic.dart';

class PetProvider extends ChangeNotifier {
  late PetState _state;
  bool _isLoaded = false;
  Timer? _timer;
  PetState get state => _state;
  bool get isLoaded => _isLoaded;

  Locale _currentLocale = const Locale('en', ' ');
  bool _isDarkMode = false;

  Locale get currentLocale => _currentLocale;
  bool get isDarkMode => _isDarkMode;

  void setLocale(Locale locale) {
    _currentLocale = locale;
    notifyListeners();
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('pet_state');

    if (saved != null) {
      _state = PetState.fromJson(jsonDecode(saved));
    } else {
      _state = PetState.newPet(PetType.sky);
    }

    PetLogic.hourlyDec(_state);
    await _save();
    _isLoaded = true;
    notifyListeners();

    _timer = Timer.periodic(const Duration(minutes: 10), (_) async {
      PetLogic.hourlyDec(_state);
      await _save();
      notifyListeners();
    });
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pet_state', jsonEncode(_state.toJson()));
  }

  Future<void> feed(String food) async {
    PetLogic.feed(_state, food);
    await _save();
    notifyListeners();
  }

  Future<void> water() async {
    PetLogic.water(_state);
    await _save();
    notifyListeners();
  }

  Future<void> wash() async {
    PetLogic.wash(_state);
    await _save();
    notifyListeners();
  }

  Future<void> play(String toy) async {
    PetLogic.play(_state, toy);
    await _save();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
