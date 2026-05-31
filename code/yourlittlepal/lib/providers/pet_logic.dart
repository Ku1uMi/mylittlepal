
import 'package:yourlittlepal/models/pet_state.dart';

class PetLogic {
  static void hourlyDec(PetState state) {
    const int healthDec = 3;
    const int closenessDec = 2;
    final now = DateTime.now();
    final diff = (now.difference(state.lastSaved).inMinutes / 60).clamp(0, 24);

    //check day before updating lastSaved
    if (now.day != state.lastSaved.day) {
      state.waterTime = 0;
      state.mealTime = 0;
      state.isWashed = false;
      state.playTime = 0;
    }

    state.health = (state.health - healthDec * diff).clamp(0, 100);
    state.closeness = (state.closeness - closenessDec * diff).clamp(0, 100);
    state.lastSaved = now;
  }

  static void feed(PetState state, String food) {
    final isFavorite =
        state.petType.info.favoriteFoods.contains(food);
    if (state.mealTime < 3) {
      if (isFavorite) {
        state.health = (state.health + 15).clamp(0, 100);
      } else {
        state.health = (state.health + 10).clamp(0, 100);
      }
      state.coins += 20;
      state.mealTime++;
      state.ownedFood[food] = state.ownedFood[food]! - 1;
    }
  }

  static void water(PetState state) {
    if (state.waterTime < 15) {
      state.health = (state.health + 2).clamp(0, 100);
      state.coins += 5;
      state.waterTime++;
    }
  }

  static void wash(PetState state) {
    if (!state.isWashed) {
      state.health = (state.health + 10).clamp(0, 100);
      state.coins += 10;
      state.isWashed = true;
    }
  }

  static void play(PetState state, String toy) {
    final isFavorite = state.petType.info.favoriteToys.contains(toy);
    if (state.playTime < 2) {
      if (isFavorite) {
        state.closeness = (state.closeness + 20).clamp(0, 100);
      } else {
        state.closeness = (state.closeness + 15).clamp(0, 100);
      }
      state.coins += 15;
      state.playTime++;
    }
  }

  static void changeOutfit(PetState state, {String? top, String? bottom}) {
    state.undo.add(state.currOutfit);
    state.redo.clear();

    state.currOutfit = state.currOutfit.update(top: top, bottom: bottom);
  }

  static void undo(PetState state) {
    if (state.undo.isNotEmpty) {
      state.redo.add(state.currOutfit);
      state.currOutfit = state.undo.last;
      state.undo.removeLast();
    }
  }

  static void redo(PetState state) {
    if (state.redo.isNotEmpty) {
      state.undo.add(state.currOutfit);
      state.currOutfit = state.redo.last;
      state.redo.removeLast();
    }
  }

  static bool buyFood(PetState state, String food) {
    const int foodPrice = 20;
    if (state.coins < foodPrice) {
      return false;
    } else {
      state.coins -= foodPrice;
      state.ownedFood[food] = (state.ownedFood[food] ?? 0) + 1;
      return true;
    }
  }

  static bool buyToy(PetState state, String toy) {
    const int toyPrice = 30;
    if (state.coins < toyPrice) {
      return false;
    } else {
      state.coins -= toyPrice;
      state.ownedToy.add(toy);
      return true;
    }
  }

  static void selectPet(PetState state, PetType type) {
    state.petType = type;
    state.newPet = false;
  }
}
