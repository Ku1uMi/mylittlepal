import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
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

  Future<bool> buyFood(String food, int i) async {
    final buyed = PetLogic.buyFood(_state, food);
    await _save();
    notifyListeners();
    return buyed;
  }

  Future<bool> buyToy(String toy, int i) async {
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

  final ValueNotifier<bool> washing = ValueNotifier(false);

  Future<void> startWashing() async {
    washing.value = true;
    notifyListeners();
  }

  String? _tempDialogue;
  String? get tempDialogue => _tempDialogue;

  // --- CONNECTED OUTFIT GETTERS ---
  // Pull directly from your backend state variables instead of returning null
  String? get currentTopAsset => _state.currOutfit.top;
  String? get currentBottomAsset => _state.currOutfit.bottom;

  Future<void> showDialogue(String text, {int seconds = 5}) async {
    _tempDialogue = text;
    notifyListeners();
    await Future.delayed(Duration(seconds: seconds));
    _tempDialogue = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Handles undoing an outfit adjustment sequence step
  Future<void> undoOutfitChange() async {
    await undo();
  }

  /// Handles redoing an outfit adjustment sequence step
  Future<void> redoOutfitChange() async {
    await redo();
  }

  /// Toggles clothing item paths dynamically inside your core business rules
  Future<void> equipClothingItem(String itemId, bool viewingTops) async {
    if (viewingTops) {
      // Toggle top: if clicked item is already equipped, strip it (null), else change it
      final nextTop = _state.currOutfit.top == itemId ? null : itemId;
      await changeOutfit(top: nextTop, bottom: _state.currOutfit.bottom);
    } else {
      // Toggle bottom: if clicked item is already equipped, strip it (null), else change it
      final nextBottom = _state.currOutfit.bottom == itemId ? null : itemId;
      await changeOutfit(top: _state.currOutfit.top, bottom: nextBottom);
    }
  }

  /// Automatically persists configurations when confirming wardrobe modifications
  Future<void> saveCurrentOutfitState() async {
    await _save(); // Saves everything neatly down to local device disk storage
    notifyListeners();
  }

  Future<void> spendCoins(int amount) async {
    _state.coins -=
        amount; // Subtracts the cost from the current state's coin count
    await _save(); // Persists the change to device storage
    notifyListeners(); // Refreshes the UI
  }
}
