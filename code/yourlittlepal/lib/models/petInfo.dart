import 'petstate.dart';

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
      favoriteFoods: ['carrot', 'hay balls'],
      favoriteToys: ['hay balls'],
      normalFoods: ['water', 'grass'],
      normalToys: ['socks'],
    ),
    PetType.ocean: PetStaticInfo(
      name: 'Bubble',
      description:
          'An uncommon, gentle creature: half goat, half whale hybrid.',
      favoriteFoods: ['shrimp', 'pebbles'],
      favoriteToys: ['pebbles'],
      normalFoods: ['water', 'salmon'],
      normalToys: ['socks', 'bones'],
    ),
    PetType.forest: PetStaticInfo(
      name: 'Fuzzy',
      description: 'A mini lion king proud of its thick, pixelated mane.',
      favoriteFoods: ['steak', 'feather wand'],
      favoriteToys: ['feather wand'],
      normalFoods: ['water', 'chicken'],
      normalToys: ['socks', 'bones'],
    ),
  };

  /// Fetch info for a specific type safely
  static PetStaticInfo getInfo(PetType type) => allPets[type]!;
}

extension PetTypeData on PetType {
  PetStaticInfo get info => PetRegistry.getInfo(this);

  String getDialogue({
    required double health,
    required double closeness,
    required bool isThirsty,
    required bool isHungry,
  }) {
    if (health <= 0) {
      return 'I feel sick... and need some medicine.';
    }
    if (closeness <= 0) {
      return '... Hmph. Leave me alone right now.';
    }
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
