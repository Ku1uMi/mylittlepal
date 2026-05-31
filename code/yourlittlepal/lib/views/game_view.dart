import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yourlittlepal/providers/pet_provider.dart';
import 'package:yourlittlepal/views/pet_view.dart';
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
    //final info = state.petType.info;
    if (!provider.isLoaded) {
      return const Scaffold(
        body: Center(
          child: Text(
            'LOADING PAL...',
            style: TextStyle(fontFamily: 'Pixelify Sans', fontSize: 18),
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
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/settings'),
                    child: Image.asset(
                      'assets/icons/setting.png',
                      width: 28,
                      height: 28,
                      semanticLabel: 'Press to go to setting page',
                    ),
                  ),
                ],
              ),
            ),
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
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: Dialogue(
                dialogue:
                    provider.tempDialogue ?? state.petType.getDialogue(state),
              ),
            ),
            const SizedBox(height: 16),

            const Expanded(child: Center(child: PetView())),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset('assets/icons/coins.png', width: 28, height: 28),
                  const SizedBox(width: 6),
                  Text(
                    '${state.coins}',
                    style: const TextStyle(
                      fontFamily: 'Pixelify Sans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              decoration: BoxDecoration(
                color: Colors.amber[100],
                border: const Border(
                  top: BorderSide(
                    color: Color.fromARGB(255, 51, 37, 14),
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
                        },
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }
}
