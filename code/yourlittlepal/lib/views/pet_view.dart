import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yourlittlepal/providers/pet_provider.dart';

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
          petProvider.showDialogue('I am so clean now!\n٩(^ᗜ^ )و ');
          
        }
      },
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints){
          final size = constraints.maxWidth < constraints.maxHeight ? 
          constraints.maxWidth : constraints.maxHeight;
          
          return Stack(
              alignment: Alignment.center,
              children: [
              Image.asset(
                'assets/pets/${state.petType.name}.png',
                width: size,
                height: size,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.none,
              ),
              if(bottom != '')
                Image.asset(
                  'assets/outfits/bottoms/$bottom.png',
                  width: size ,
                  height: size ,
                  filterQuality: FilterQuality.none,
                ),
            
                if(top != '')
                Image.asset(
                  'assets/outfits/tops/$top.png',
                  width: size,
                  height: size ,
                  filterQuality: FilterQuality.none,
                ),
              
              for(var bubblePos in bubbleScrubPoints)
                Positioned(
                  left: bubblePos.dx - 15,
                  top: bubblePos.dy -15,
                  child: Image.asset(
                    'assets/effects/bubble.png',
                    width: 50,
                    height: 50,
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
      20,
      (_) => Offset(min + random.nextDouble() * (max-min), 
      min + random.nextDouble() * (max-min)) 
      );
  }


}

