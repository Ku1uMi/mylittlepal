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
  bool get newPet => _state.newPet;
  Locale _currentLocale = const Locale('en', '');
  bool _isDarkMode = false;

  Locale get currentLocale => _currentLocale;
  bool get isDarkMode => _isDarkMode;

  bool get canUndo => _state.undo.isNotEmpty;
  bool get canRedo => _state.redo.isNotEmpty;

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
    final languageCode = prefs.getString('locale') ?? 'en';
    final countryCode = prefs.getString('locale_country') ?? '';

    if (saved != null) {
      _state = PetState.fromJson(jsonDecode(saved));
    } else {
      _state = PetState.newPet(PetType.sky);
    }
    _currentLocale = Locale(languageCode, countryCode);
    _isDarkMode = prefs.getBool('dark_mode') ?? false;

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
    await prefs.setString('locale', _currentLocale.languageCode);
    await prefs.setString('locale_country', _currentLocale.countryCode ?? '');
    await prefs.setBool('dark_mode', _isDarkMode);
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

  Future<void> changeOutfit({String? top, String? bottom}) async {
    PetLogic.changeOutfit(_state, top: top, bottom: bottom);
    await _save();
    notifyListeners();
  }

  Future<void> undo() async {
    PetLogic.undo(_state);
    await _save();
    notifyListeners();
  }

  Future<void> redo() async {
    PetLogic.redo(_state);
    await _save();
    notifyListeners();
  }

  Future<bool> buyFood(String food) async {
    final buyed = PetLogic.buyFood(_state, food);
    await _save();
    notifyListeners();
    return buyed;
  }

  Future<bool> buyToy(String toy) async {
    final buyed = PetLogic.buyToy(_state, toy);
    await _save();
    notifyListeners();
    return buyed;
  }

  Future<void> selectPet(PetType type) async {
    PetLogic.selectPet(_state, type);
    await _save();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
