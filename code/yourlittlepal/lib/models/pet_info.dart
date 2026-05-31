import 'package:yourlittlepal/models/pet_state.dart';

class PetStaticInfo {
  final String name;
  final String description;
  final String assetPath; // Added to map directly to your asset catalog
  final List<String> favoriteFoods;
  final List<String> favoriteToys;
  final List<String> normalFoods;
  final List<String> normalToys;

  const PetStaticInfo({
    required this.name,
    required this.description,
    required this.assetPath,
    required this.favoriteFoods,
    required this.favoriteToys,
    required this.normalFoods,
    required this.normalToys,
  });
}

/// Helper class containing the configuration data for your pet variants
class PetRegistry {
  static const Map<PetType, PetStaticInfo> allPets = {
    PetType.rabbit: PetStaticInfo(
      name: 'Cloudy',
      description:
          'A delicate rabbit with functional wings and a hovering halo.',
<<<<<<< HEAD
      assetPath: 'assets/pets/rabbit.png',
      favoriteFoods: ['carrot', 'hay balls'],
=======
      favoriteFoods: ['carrot'],
>>>>>>> 656640a97f88deb3c8fff5097b9cc7b21fee031b
      favoriteToys: ['hay balls'],
      normalFoods: ['steak','grass','salmon'],
      normalToys: ['socks', 'feather'],
    ),
    PetType.goat: PetStaticInfo(
      name: 'Bubble',
      description:
          'An uncommon, gentle creature: half goat, half whale hybrid.',
<<<<<<< HEAD
      assetPath: 'assets/pets/goat.png',
      favoriteFoods: ['shrimp', 'pebbles'],
=======
      favoriteFoods: ['shrimp'],
>>>>>>> 656640a97f88deb3c8fff5097b9cc7b21fee031b
      favoriteToys: ['pebbles'],
      normalFoods: ['salmon','steak','grass'],
      normalToys: ['socks', 'feather'],
    ),
  };

  /// Fetch info for a specific type safely
  static PetStaticInfo getInfo(PetType type) => allPets[type]!;
}
<<<<<<< HEAD
=======

extension PetTypeData on PetType {
  PetStaticInfo get info => PetRegistry.getInfo(this);

  /// Generates dynamic UI messages directly by analyzing the current PetState
  String getDialogue(PetState state) {
    if (state.health <= 0) {
      return 'I feel sick... and need some medicine.';
    }
    if (state.closeness <= 0) {
      return '... Hmph. Leave me alone right now.';
    }

    // Derived states: Hungry if pet has eaten 0 meals today;
    // Thirsty if pet has had less than 2 cups of water today.
    bool isHungry = state.mealTime == 0;
    bool isThirsty = state.waterTime < 2;

    if (isHungry) {
      return 'My tummy is rumbling! Time for a meal?';
    }
    if (isThirsty) {
      return 'Can I get some refreshing water?';
    }

    switch (this) {
      case PetType.sky:
        return 'The floating breeze feels amazing today!';
      case PetType.ocean:
        return 'Splish splash! The temperature down here is perfect.';
      case PetType.forest:
        return 'ROAR! Just practicing my hunting stalk!';
    }
  }
}
>>>>>>> 656640a97f88deb3c8fff5097b9cc7b21fee031b
