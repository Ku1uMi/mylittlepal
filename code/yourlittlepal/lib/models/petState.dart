
enum PetType {sky, ocean, forest}

class PetState{
  final PetType petType;
  double health;
  double closeness;
  int coins;
  late DateTime lastSaved;
  int waterTime;
  int mealTime;
  bool isWashed;
  late DateTime sleepTime;
  bool isPlayed;

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
    this.isPlayed = false
  });

  Map<String, dynamic> toJson() =>{
    'petType': petType.name,
    'health': health,
    'closeness': closeness,
    'coins': coins,
    'lastSaved': lastSaved.toIso8601String(),
    'waterTime': waterTime,
    'mealTime': mealTime,
    'isWashed': isWashed,
    'sleepTime': sleepTime.toIso8601String(),
    'isPlayed' : isPlayed
  };
    
  
  factory PetState.fromJson(Map<String, dynamic> json){
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
      isPlayed: json['isPlayed'] as bool
    );
  }

  factory PetState.newPet(PetType type) => PetState(
    petType: type, 
    lastSaved: DateTime.now(), 
    sleepTime: DateTime(2026,5,24,21,30)
  );

}