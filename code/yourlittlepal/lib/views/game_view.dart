import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yourlittlepal/models/pet_info.dart';
import 'package:yourlittlepal/providers/pet_provider.dart';
import 'package:yourlittlepal/views/pet_view.dart';
import 'package:yourlittlepal/widgets/dialogue.dart';
import 'package:yourlittlepal/widgets/food_sheet.dart';
import 'package:yourlittlepal/widgets/stat_bar.dart';
import 'package:yourlittlepal/widgets/bottom_bar.dart';
import 'package:yourlittlepal/widgets/action_sheet.dart';
import 'package:yourlittlepal/widgets/toy_sheet.dart';

class GameView extends StatelessWidget{
  const GameView({super.key});

  @override
  Widget build(BuildContext context){
    final provider = context.watch<PetProvider>();
    final state = provider.state;
    final info = state.petType.info;

    return Scaffold(
      body:SafeArea(
        child: Column(
          children:[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                children: [
                  StatBar(
                    name: 'Health',
                    val: state.health/100,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 8,),
                  StatBar(
                    name: 'Closeness', 
                    val: state.closeness/100, 
                    color: Colors.orangeAccent
                  )
                ],
              ),
            ),
            const SizedBox(height: 16,),
            Dialogue(
              dialogue: state.petType.getDialogue(state),
            ),
            const SizedBox(height: 16,),

            const Expanded(
              child: Center(
                child: PetView(),
              )
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset('assets/icons/coins.png'),
                  const SizedBox(width: 4,),
                  Text(
                    'state.coins',
                    style: const TextStyle(
                      fontFamily: 'PixelFont',
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ],
              ),
            ),

            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.black,
                    width: 2,
                  )
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BottomBar(
                    name: 'FEED', 
                    icon: 'assets/icons/feed.png', 
                    onTap: () => showFeedSheet(context, provider)
                  ),
                  BottomBar(
                    name: 'WATER', 
                    icon: 'assets/icons/water.png', 
                    onTap: () async {
                      provider.water();
                      final overlay = Overlay.of(context);
                      final entry = OverlayEntry(
                        builder: (_) => Positioned(
                          bottom: 120,
                          left: 0,
                          right: 0,
                          child: Center(
                              child: Dialogue(
                                dialogue: 'Thank you!(˶>⩊<˶) Have you drunk your water yet?'
                              ),
                            )
                          )
                        );
                      overlay.insert(entry);
                      await Future.delayed(const Duration(seconds: 3));
                      entry.remove();

                    }
                  ),
                  BottomBar(
                    name: 'WASH', 
                    icon: 'assets/icons/wash.png', 
                    onTap: () async {
                      provider.startWashing();

                      final overlay = Overlay.of(context);
                      final entry = OverlayEntry(
                        builder: (_) => Positioned(
                          bottom: 120,
                          left: 0,
                          right: 0,
                          child: Center(
                              child: Dialogue(
                                dialogue: 'Please scrub the bubbles off my body(ㅅ´ ˘ `)'
                              ),
                            )
                          )
                        );
                      overlay.insert(entry);
                      await Future.delayed(const Duration(seconds: 3));
                      entry.remove();

                    }
                  ),
                  BottomBar(
                    name: 'PLAY', 
                    icon: 'assets/icons/play.png', 
                    onTap: () async {
                      showPlaySheet(context, provider);
                      provider.water();
                      final overlay = Overlay.of(context);
                      final entry = OverlayEntry(
                        builder: (_) => Positioned(
                          bottom: 120,
                          left: 0,
                          right: 0,
                          child: Center(
                              child: Dialogue(
                                dialogue: 'This is so fun!'
                              ),
                            )
                          )
                        );
                      overlay.insert(entry);
                      await Future.delayed(const Duration(seconds: 3));
                      entry.remove();
                    }
                  ),
                  BottomBar(
                    name: 'OUTFIT', 
                    icon: 'assets/icons/clothes.png', 
                    onTap: () => Placeholder() //------
                  ),
                  BottomBar(
                    name: 'SHOP', 
                    icon: 'assets/icons/shop.png', 
                    onTap: () => Placeholder() //------
                  )
                  
                ],
              )
            )
          ]
        )
      )
    );
  }

  void showFeedSheet(BuildContext context, PetProvider provider){
    final state = provider.state;
    final name = state.petType.info.name;
    showModalBottomSheet(
      context: context, 
      builder: (_) => ActionSheet(
        text: 'Let\'s feed $name!', 
        icon: 'assets/icons/close.png', 
        child: state.ownedFood.isEmpty ? const Center(
          child: Text('No food!( ;´ - `;) Please visit the shop.')) : Wrap(
            spacing: 8,
            runSpacing: 8,
            children: state.ownedFood.entries.where((e) => e.value > 0)
              .map((e) => FoodSheet(
                food: e.key, 
                num: e.value, 
                onTap: () {
                  provider.feed(e.key);
                  Navigator.pop(context);
                }
              )
            ).toList(),
          )
      )
    );
  }
  
  void showPlaySheet(BuildContext context, PetProvider provider){
    final state = provider.state;
    final name = state.petType.info.name;
    showModalBottomSheet(
      context: context, 
      builder: (_) => ActionSheet(
        text: 'Let\'s Play with $name!', 
        icon: 'assets/icons/close.png', 
        child: state.ownedFood.isEmpty ? const Center(
          child: Text('No toy!( ;´ - `;) Please visit the shop.')) : Wrap(
            spacing: 8,
            runSpacing: 8,
            children: state.ownedFood.entries.where((e) => e.value > 0)
              .map((e) => ToySheet(
                toy: e.key, 
                onTap: () {
                  provider.feed(e.key);
                  Navigator.pop(context);
                }
              )
            ).toList(),
          )
      )
    );
  }
  
}



