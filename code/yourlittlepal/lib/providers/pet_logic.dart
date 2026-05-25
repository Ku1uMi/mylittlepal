import 'package:yourlittlepal/models/petInfo.dart';
import 'package:yourlittlepal/models/petState.dart';

class PetLogic {
  static void hourlyDec(PetState state){
    const int healthDec = 3;
    const int closenessDec = 2;
    final now = DateTime.now();
    final diff = (now.difference(state.lastSaved).inMinutes / 60).clamp(0, 24);

    //check day before updating lastSaved
    if(now.day != state.lastSaved.day){
      state.waterTime = 0;
      state.mealTime = 0;
      state.isWashed = false;
    }
    state.health = (state.health - healthDec * diff).clamp(0, 100);
    state.closeness = (state.closeness - closenessDec * diff).clamp(0, 100);
    state.lastSaved = now;
    
  }

  static void feed(PetState state, String food){
    final isFavorite = state.petType.info.favoriteFoods.contains(food);
    if (state.mealTime < 3 ) {
      if(isFavorite){
        state.health = (state.health + 15).clamp(0, 100);
      }else{
        state.health = (state.health + 10).clamp(0, 100);
      }
      state.coins += 20;
      state.mealTime++;
    }        
  }

  static void water(PetState state){
    if (state.waterTime < 15) {
      state.health = (state.health + 2).clamp(0, 100);
      state.coins += 5;
      state.waterTime++;
    }
  }

  static void wash(PetState state){
    if (!state.isWashed) {
      state.health = (state.health + 10).clamp(0, 100);
      state.coins += 10;
      state.isWashed = true;
    }
  }

  static void play(PetState state, String toy){
    final isFavorite = state.petType.info.favoriteToys.contains(toy);
    if(!state.isPlayed){
      if(isFavorite){
        state.closeness = (state.closeness + 20).clamp(0, 100);
      } else{
        state.closeness = (state.closeness + 15).clamp(0, 100);
      }
      state.coins += 15;
    }
  }
}