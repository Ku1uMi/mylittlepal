import 'package:yourlittlepal/models/outfit.dart';

enum PetType {
  sky,
  ocean;

  dynamic get info => null;

  String getDialogue(PetState state) {
    return " ";
  }
}

class PetState {
  PetType petType;
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
  Map<String, int> ownedFood;
  List<String> ownedToy;
  List<String> ownedTops;
  List<String> ownedBottoms;
  bool newPet;

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
    this.ownedFood = const {},
    this.ownedToy = const [],
    this.ownedTops = const [],
    this.ownedBottoms = const [],
    this.newPet = true,
  }) {
    undo = List.of(undo);
    redo = List.of(redo);
    ownedFood = Map.of(ownedFood);
    ownedToy = List.of(ownedToy);
    ownedTops = List.of(ownedTops);
    ownedBottoms = List.of(ownedBottoms);
  }

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
    'currOutfit': currOutfit.toJson(),
    'undo': undo.map((e) => e.toJson()).toList(),
    'redo': redo.map((e) => e.toJson()).toList(),
    'ownedFood': ownedFood,
    'ownedToy': ownedToy,
    'ownedTops': ownedTops,
    'ownedBottoms': ownedBottoms,
    'newPet': newPet,
  };

  factory PetState.fromJson(Map<String, dynamic> json) {
    return PetState(
      petType: PetType.values.byName(json['petType']),
      health: (json['health'] as num).toDouble(),
      closeness: (json['closeness'] as num).toDouble(),
      coins: json['coins'] as int,
      lastSaved: DateTime.parse(json['lastSaved']),
      waterTime: json['waterTime'] as int,
      mealTime: json['mealTime'] as int,
      isWashed: json['isWashed'] as bool,
      sleepTime: DateTime.parse(json['sleepTime']),
      playTime: json['playTime'] as int,
      currOutfit: (json['currOutfit']) != null
          ? Outfit.fromJson(json['currOutfit'])
          : const Outfit(),
      undo: json['undo'] != null
          ? (json['undo'] as List).map((e) => Outfit.fromJson(e)).toList()
          : [],
      redo: json['redo'] != null
          ? (json['redo'] as List).map((e) => Outfit.fromJson(e)).toList()
          : [],
      ownedFood: Map<String, int>.from(json['ownedFood']),
      ownedToy: List<String>.from(json['ownedToy']),
      ownedTops: (json['ownedTops']) != null
          ? List<String>.from(json['ownedTops'])
          : [],
      ownedBottoms: (json['ownedBottoms']) != null
          ? List<String>.from(json['ownedBottoms'])
          : [],
      newPet: json['newPet'] as bool,
    );
  }

  factory PetState.newPet(PetType type) {
    final defaultFood = {
      PetType.sky: {'carrot': 2, 'hay': 2},
      PetType.ocean: {'shrimp': 2, 'salmon': 2},
    };

    final defaultToy = {
      PetType.sky: ['socks'],
      PetType.ocean: ['socks'],
    };

    return PetState(
      petType: type,
      lastSaved: DateTime.now(),
      sleepTime: DateTime(2026, 5, 24, 21, 30),
      ownedFood: defaultFood[type]!,
      ownedToy: defaultToy[type]!,
      ownedTops: ['yellow_top', 'navy_top'],
      ownedBottoms: ['beige_bottom', 'checked_skirt'],
      newPet: true,
    );
  }
}
