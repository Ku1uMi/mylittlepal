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
  static final Map<PetType, PetStaticInfo> allPets = {
    PetType.sky: const PetStaticInfo(
      name: 'Cloudy',
      description:
          'A delicate rabbit with functional wings and a hovering halo.',
      favoriteFoods: ['carrot'],
      favoriteToys: ['hay balls'],
      normalFoods: ['steak','grass','salmon'],
      normalToys: ['socks', 'feather'], assetPath: '',
    ),
    PetType.ocean: const PetStaticInfo(
      name: 'Bubble',
      description:
          'An uncommon, gentle creature: half goat, half whale hybrid.',
      favoriteFoods: ['shrimp'],
      favoriteToys: ['pebbles'],
      normalFoods: ['salmon','steak','grass'],
      normalToys: ['socks', 'feather'], assetPath: '',
    ),
  };

  /// Fetch info for a specific type safely
  static PetStaticInfo getInfo(PetType type) => allPets[type]!;

}
