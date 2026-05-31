import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yourlittlepal/providers/pet_provider.dart';
import 'package:yourlittlepal/widgets/dialogue.dart';

class PetView extends StatefulWidget {
  const PetView({super.key});

  @override
  State<PetView> createState() => _PetViewState();
}

class _PetViewState extends State<PetView> {
  List<Offset> bubbleScrubPoints = [];

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);
    final state = petProvider.state;
    final top = state.currOutfit.top;
    final bottom = state.currOutfit.bottom;

/*
    // Fallback safe-check to grab the chosen pet name string
    final Object selectedPet =
        (petProvider.isLoaded && petProvider.state.petName != null)
        ? petProvider.state.petName!.toUpperCase()
        : "RABBIT";

    // Map the name to the correct asset path
    String assetPath = 'assets/pets/rabbit.png';
    if (selectedPet == 'GOAT') {
      assetPath = 'assets/pets/goat.png';
    }
*/
    // Generate a list of soap bubbles if the pet is dirty/being washed
    /*if (state.isWashed == false && bubbleScrubPoints.isEmpty) {
      bubbleScrubPoints = [
        const Offset(40, 40),
        const Offset(100, 50),
        const Offset(50, 90),
        const Offset(20, 70),
        const Offset(80, 80),
        const Offset(45, 110),
        const Offset(70, 30),
        const Offset(110, 100),
      ];
    }*/

    return GestureDetector(
      onPanUpdate: (DragUpdateDetails details) {
        if (state.isWashed) return;

        RenderBox renderBox = context.findRenderObject() as RenderBox;
        Offset localPosition = renderBox.globalToLocal(details.globalPosition);

        setState(() {
          // Pops a bubble if your finger drags within 25 pixels of it
          bubbleScrubPoints.removeWhere(
            (bubblePos) => (bubblePos - localPosition).distance < 25.0,
          );
        });

        if (bubbleScrubPoints.isEmpty && !state.isWashed && petProvider.washing.value) {
          petProvider.wash();
          petProvider.washing.value = false;
          petProvider.showDialogue('I am so clean now!\n٩(^ᗜ^ )و ´-');
          
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints){
          final size = constraints.maxWidth < constraints.maxHeight ? 
          constraints.maxWidth : constraints.maxHeight;

          return Stack(
            alignment: Alignment.center,
            children: [
            Image.asset(
              'assets/pets/${state.petType.name}.png',
              width: size,
              height: size,
              filterQuality: FilterQuality.none,
            ),
            if(bottom != '')
              Image.asset(
                'assets/outfits/bottoms/$bottom.png',
                width: size,
                height: size,
                filterQuality: FilterQuality.none,
              ),

              if(top != '')
              Image.asset(
                'assets/outfits/tops/$top.png',
                width: size,
                height: size,
                filterQuality: FilterQuality.none,
              ),
            
            for(var bubblePos in bubbleScrubPoints)
              Positioned(
                left: bubblePos.dx - 15,
                top: bubblePos.dy -15,
                child: Image.asset(
                  'assets/effects/bubble.png',
                  width: 30,
                  height: 30,
                  filterQuality: FilterQuality.none,
                ),
              ),
              ValueListenableBuilder<bool>(
              valueListenable: petProvider.washing, 
              builder: (context, washing, _){
                if(washing && bubbleScrubPoints.isEmpty){
                  WidgetsBinding.instance.addPostFrameCallback((_){
                    if(mounted) setState(() => reset(size));
                  });
                }
                return const SizedBox.shrink();
              }
            )
            ], 
          );
        }
      )
    );
  }

  void reset(double size){
    final random = Random();
    final min = size * 0.2;
    final max = size * 0.8;
    bubbleScrubPoints = List.generate(
      8,
      (_) => Offset(min + random.nextDouble() * (max-min), 
      max + random.nextDouble() * (max-min)) 
      );
  }


}
/*
extension on Object {
  Future<void> toUpperCase() async {}
}*/
