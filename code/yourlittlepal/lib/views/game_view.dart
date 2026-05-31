import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:yourlittlepal/providers/pet_provider.dart';
import 'package:yourlittlepal/providers/position_provider.dart';
import 'package:yourlittlepal/providers/weather_provider.dart';
import 'package:yourlittlepal/views/pet_view.dart';
import 'package:yourlittlepal/weather_conditions.dart';
import 'package:yourlittlepal/widgets/dialogue.dart';
import 'package:yourlittlepal/widgets/food_sheet.dart';
import 'package:yourlittlepal/widgets/stat_bar.dart';
import 'package:yourlittlepal/widgets/bottom_bar.dart';
import 'package:yourlittlepal/widgets/action_sheet.dart';
import 'package:yourlittlepal/widgets/toy_sheet.dart';

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PetProvider>();
    final positionProvider = context.watch<PositionProvider>();
    final weatherProvider = context.watch<WeatherProvider>();
    
    if(positionProvider.positionKnown){
      weatherProvider.updateLocation(positionProvider.latitude!, positionProvider.longitude!);
    }
    
    if (!provider.isLoaded) {
      return Scaffold(
        body: Center(
          child: Text(
            'LOADING PAL...',
            style: GoogleFonts.pixelifySans(
                        fontSize: 18,
            ),
          ),
        ),
      );
    }
    final state = provider.state;

    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pushNamed(context, '/settings'), 
                    icon: Image.asset(
                      'assets/icons/setting.png',
                      width: 28,
                      height: 28,
                      semanticLabel: 'Settings',
                    ),
                    
                  ),
                  //weather -------
                  Consumer<WeatherProvider>(
                    builder: (context, weather, _){
                      if(!weather.isValid){
                        return const SizedBox.shrink();
                      }
                      return Row(
                        children: [
                          Image.asset(
                            weatherIcon(weather.condition),
                            width: 28,
                            height: 28,
                            filterQuality: FilterQuality.none,
                          ),
                          const SizedBox(width: 3,),
                          Text(
                            '${weather.tempInFahrenheit}°F',
                            style: GoogleFonts.pixelifySans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold
                            ),
                            
                          ),
                        ],
                      );
                      
                    }
                  )
                ],
              ),
            ),
            //stat bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                children: [
                  StatBar(
                    name: 'Health',
                    val: state.health / 100,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 8),
                  StatBar(
                    name: 'Closeness',
                    val: state.closeness / 100,
                    color: Colors.orangeAccent,
                  ),
                ],
              ),
            ),
            //dialogue
            const SizedBox(height: 16,), 
            SizedBox(
              height: 100,
              child: Dialogue(
                dialogue:
                    provider.tempDialogue ?? state.petType.getDialogue(state),
              ),
            ),
            const SizedBox(height: 16),

            const Expanded(
              child: Center(
                child: PetView(),
              )
            ),
            //coins
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset('assets/icons/coins.png', width: 28, height: 28),
                  const SizedBox(width: 6),
                  Text(
                    '${state.coins}',
                    style: GoogleFonts.pixelifySans(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                    
                  ),
                ],
              ),
            ),
            //bottom bar
            Container(
              decoration: BoxDecoration(
                color: Colors.amber[100],
                border: const Border(
                  top: BorderSide(
<<<<<<< HEAD
                    color: Color.fromARGB(255, 51, 37, 14),
=======
                    color: const Color.fromRGBO(255, 236, 179, 1),
>>>>>>> 0cadff5d52db09276332bca162c195a0590c53a5
                    width: 2,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BottomBar(
                    name: 'FEED',
                    icon: 'assets/icons/feed.png',
                    onTap: () => showFeedSheet(context, provider),
                  ),
                  BottomBar(
                    name: 'WATER',
                    icon: 'assets/icons/water.png',
                    onTap: () async {
                      provider.water();
                      provider.showDialogue(
                        'Thank you!(˶>⩊<˶) Have you drunk your water yet?',
                      );
                    },
                  ),
                  BottomBar(
                    name: 'WASH',
                    icon: 'assets/icons/wash.png',
                    onTap: () async {
                      provider.startWashing();
                      provider.showDialogue(
                        'Please scrub the bubbles off my body\n(ㅅ´ ˘ `)',
                      );
                    },
                  ),
                  BottomBar(
                    name: 'PLAY',
                    icon: 'assets/icons/play.png',
                    onTap: () async {
                      showPlaySheet(context, provider);
                    },
                  ),
                  BottomBar(
                    name: 'OUTFIT',
                    icon: 'assets/icons/clothes.png',
                    // Navigates directly over to your wardrobe view overlay
                    onTap: () => Navigator.pushNamed(context, '/outfit'),
                  ),
                  BottomBar(
                    name: 'SHOP',
                    icon: 'assets/icons/shop.png',
                    // Navigates directly over to your store catalog overlay
                    onTap: () => Navigator.pushNamed(context, '/shop'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showFeedSheet(BuildContext context, PetProvider provider) {
    final state = provider.state;
    final name = state.petType.info.name;
    showModalBottomSheet(
      context: context,
      builder: (_) => ActionSheet(
        text: 'Let\'s feed $name!',
        icon: 'assets/icons/close.png',
        child: state.ownedFood.isEmpty
            ? const Center(
                child: Text('No food!( ;´ - `;) Please visit the shop.'),
              )
            : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: state.ownedFood.entries
                    .map(
                      (e) => FoodSheet(
                        food: e.key,
                        num: e.value,
                        onTap: e.value > 0
                            ? () async {
                                provider.feed(e.key);
                                provider.showDialogue('Yummy!');
                                Navigator.pop(context);
                              }
                            : null,
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }

  void showPlaySheet(BuildContext context, PetProvider provider) {
    final state = provider.state;
    final name = state.petType.info.name;
    showModalBottomSheet(
      context: context,
      builder: (_) => ActionSheet(
        text: 'Let\'s Play with $name!',
        icon: 'assets/icons/close.png',
        child: state.ownedToy.isEmpty
            ? const Center(
                child: Text('No toy!( ;´ - `;) Please visit the shop.'),
              )
            : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: state.ownedToy
                    .map(
                      (e) => ToySheet(
                        toy: e,
                        onTap: () async {
                          provider.play(e);
                          provider.showDialogue('This is so fun!');
                          Navigator.pop(context);
<<<<<<< HEAD
                        },
                      ),
                    )
                    .toList(),
              ),
      ),
=======

                }
              )
            ).toList(),
          )
      )
>>>>>>> 0cadff5d52db09276332bca162c195a0590c53a5
    );
  }
  
}

String weatherIcon(WeatherCondition condition){
  return switch(condition) {
    WeatherCondition.sunny => 'assets/icons/sunny.png',
    WeatherCondition.rainy => 'assets/icons/rainy.png',
    WeatherCondition.gloomy => 'assets/icons/gloomy.png',
    _ => 'assets/icons/unknown.png'
  };
}



