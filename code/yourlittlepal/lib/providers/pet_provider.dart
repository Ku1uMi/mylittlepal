import 'dart:async';
import 'dart:convert';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:yourlittlepal/models/pet_state.dart';
import 'package:yourlittlepal/models/outfit.dart'; // Added to reference the Outfit model wrapper
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
  double _fontSize = 14.0;
  double _brightness = 1.0;

  Locale get currentLocale => _currentLocale;
  bool get isDarkMode => _isDarkMode;
  double get fontSize => _fontSize;
  double get brightness => _brightness;
  bool get canUndo => _state.undo.isNotEmpty;
  bool get canRedo => _state.redo.isNotEmpty;

  Future<void> setLocale(Locale locale) async{
    _currentLocale = locale;
    await _save();
    notifyListeners();
  }

  Future<void> toggleDarkMode() async{
    _isDarkMode = !_isDarkMode;
    await _save();
    notifyListeners();
  }
  Future<void> setBrightness(double value) async{
    _brightness = value;
    await ScreenBrightness().setApplicationScreenBrightness(_brightness);
    await _save();
    notifyListeners();
  }

  Future<void> setFontSize(double size) async{
    _fontSize = size;
    await _save();
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
    _fontSize = prefs.getDouble('font_size') ?? 14;
    _brightness = prefs.getDouble('brightness') ?? 1;
    
    try{
      await ScreenBrightness().setApplicationScreenBrightness(_brightness);
    }catch (e){
      debugPrint(e.toString());
      throw 'Failed to set application brightness';
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
<<<<<<< HEAD
    // 1. Determine fallback values if a category is omitted or unprovided
    final String finalTop = top ?? _state.currOutfit.top;
    final String finalBottom = bottom ?? _state.currOutfit.bottom;

    // 2. Build a brand new local Outfit instance payload
    // Note: If your constructor uses positional fields instead of named keys,
    // modify this line to: final newOutfit = Outfit(finalTop, finalBottom);
    final newOutfit = Outfit(top: finalTop, bottom: finalBottom);

    // 3. Re-assign state via the single argument update wrapper inside pet_state.dart
    _state = _state.update(currOutfit: newOutfit);

    // Notify the UI to rebuild immediately
    notifyListeners();

    // Persist configurations locally
    await _saveToStorage();
=======
    PetLogic.changeOutfit(_state, top: top, bottom: bottom);
    await _save();
    notifyListeners();
>>>>>>> 2d9719fdaad8eddf803af2d4b3e54259da40a364
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
    ScreenBrightness().resetApplicationScreenBrightness();
    _timer?.cancel();
    super.dispose();
  }
/*
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
      final nextTop = _state.currOutfit.top == itemId ? '' : itemId;
      await changeOutfit(top: nextTop, bottom: _state.currOutfit.bottom);
    } else {
      final nextBottom = _state.currOutfit.bottom == itemId ? '' : itemId;
      await changeOutfit(top: _state.currOutfit.top, bottom: nextBottom);
    }
  }

  /// Automatically persists configurations when confirming wardrobe modifications
  Future<void> saveCurrentOutfitState() async {
    await _save();
    notifyListeners();
  }

  Future<void> spendCoins(int amount) async {
    _state.coins -= amount;
    await _save();
    notifyListeners();
  }

  Future<void> _saveToStorage() async {
    // Forwards the data layer modifications into your shared preferences logic block
    await _save();
  }
<<<<<<< HEAD
=======
  }*/
>>>>>>> 2d9719fdaad8eddf803af2d4b3e54259da40a364
}
