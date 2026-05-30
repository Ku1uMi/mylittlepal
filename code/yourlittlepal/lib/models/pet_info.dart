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
      assetPath: 'assets/pets/rabbit.png',
      favoriteFoods: ['carrot', 'hay balls'],
      favoriteToys: ['hay balls'],
      normalFoods: ['water', 'grass'],
      normalToys: ['socks'],
    ),
    PetType.goat: PetStaticInfo(
      name: 'Bubble',
      description:
          'An uncommon, gentle creature: half goat, half whale hybrid.',
      assetPath: 'assets/pets/goat.png',
      favoriteFoods: ['shrimp', 'pebbles'],
      favoriteToys: ['pebbles'],
      normalFoods: ['water', 'salmon'],
      normalToys: ['socks', 'bones'],
    ),
  };

  /// Fetch info for a specific type safely
  static PetStaticInfo getInfo(PetType type) => allPets[type]!;
}
