import 'package:yourlittlepal/models/outfit.dart';

enum PetType { sky, ocean, forest }

class PetState {
  final PetType petType;
  double health;
  double closeness;
  int coins;
  late DateTime lastSaved;
  int waterTime;
  int mealTime;
  bool isWashed;
  late DateTime sleepTime;
  int playTime;
  Outfit currOutfit;
  List<Outfit> undo;
  List<Outfit> redo;

  PetState({
    required this.petType,
    this.health = 100,
    this.closeness = 50,
    this.coins = 0,
    required this.lastSaved,
    this.waterTime = 0,
    this.mealTime = 0,
    this.isWashed = false,
    required this.sleepTime,
    this.playTime = 0,
    this.currOutfit = const Outfit(),
    this.undo = const [],
    this.redo = const [],
  });

  Map<String, dynamic> toJson() => {
    'petType': petType.name,
    'health': health,
    'closeness': closeness,
    'coins': coins,
    'lastSaved': lastSaved.toIso8601String(),
    'waterTime': waterTime,
    'mealTime': mealTime,
    'isWashed': isWashed,
    'sleepTime': sleepTime.toIso8601String(),
    'playTime': playTime,
  };

  factory PetState.fromJson(Map<String, dynamic> json) {
    return PetState(
      petType: PetType.values.byName(json['petType']),
      health: json['health'] as double,
      closeness: json['closeness'] as double,
      coins: json['coins'] as int,
      lastSaved: DateTime.parse(json['lastSaved']),
      waterTime: json['waterTime'] as int,
      mealTime: json['mealTime'] as int,
      isWashed: json['isWashed'] as bool,
      sleepTime: DateTime.parse(json['sleepTime']),
      playTime: json['playTime'] as int,
      currOutfit: Outfit.fromJson(json['currOutfit']),
      undo: (json['undo'] as List).map((e) => Outfit.fromJson(e)).toList(),
      redo: (json['redo'] as List).map((e) => Outfit.fromJson(e)).toList(),
    );
  }

  factory PetState.newPet(PetType type) => PetState(
    petType: type,
    lastSaved: DateTime.now(),
    sleepTime: DateTime(2026, 5, 24, 21, 30),
  );
}
