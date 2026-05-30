import 'package:yourlittlepal/models/pet_state.dart';

class PetStaticInfo {
  final String name;
  final String description;
  final List<String> favoriteFoods;
  final List<String> favoriteToys;
  final List<String> normalFoods;
  final List<String> normalToys;

  const PetStaticInfo({
    required this.name,
    required this.description,
    required this.favoriteFoods,
    required this.favoriteToys,
    required this.normalFoods,
    required this.normalToys,
  });
}

/// Helper class containing the configuration data for all 3 pet variants
class PetRegistry {
  static const Map<PetType, PetStaticInfo> allPets = {
    PetType.sky: PetStaticInfo(
      name: 'Cloudy',
      description:
          'A delicate rabbit with functional wings and a hovering halo.',
      favoriteFoods: ['carrot'],
      favoriteToys: ['hay balls'],
      normalFoods: ['water', 'grass'],
      normalToys: ['socks'],
    ),
    PetType.ocean: PetStaticInfo(
      name: 'Bubble',
      description:
          'An uncommon, gentle creature: half goat, half whale hybrid.',
      favoriteFoods: ['shrimp'],
      favoriteToys: ['pebbles'],
      normalFoods: ['water', 'salmon'],
      normalToys: ['socks', 'bones'],
    ),
  };

  /// Fetch info for a specific type safely
  static PetStaticInfo getInfo(PetType type) => allPets[type]!;
}

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
