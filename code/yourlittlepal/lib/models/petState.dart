import 'dart:convert';
enum PetType {sky, ocean, forest}

class PetState{
  final String petType;
  double health;
  double closeness;
  int coins;
  late DateTime lastSaved;
  int waterTime;
  int mealTime;
  bool isWashed;
  late DateTime sleepTime;

  PetState({
    required this.petType,
    this.health = 100,
    this.closeness = 50,
    this.coins = 0,
    required this.lastSaved,
    this.waterTime = 0,
    this.mealTime = 0,
    this.isWashed = false,
    required this.sleepTime
  });

  Map<String, dynamic> toJson() =>{
    //'petType': ,
    'health': health,
    'closeness': closeness,
    'coins': coins,
    'lastSaved': lastSaved,
    'waterTime': waterTime,
    'mealTime': mealTime,
    'isWashed': isWashed,
    'sleepTime': sleepTime,
  };
    
  
  factory PetState.fromJson(Map<String, dynamic> json){
    return PetState(
      //petType: ,
      health: json['health'] as double,
      closeness: json['closeness'] as double,
      coins: json['coins'] as int,
      lastSaved: DateTime.parse(json ['lastSaved']),
      waterTime: json['waterTime'] as int,
      mealTime: json['mealTime'] as int,
      isWashed: json['isWashed'] as bool,
      sleepTime: DateTime.parse(json ['sleepTime'])
    );
  }



}