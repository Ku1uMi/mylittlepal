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

    // Generate a list of temporary visual bubbles if the pet is dirty/being washed
    if (state.isWashed == false && bubbleScrubPoints.isEmpty) {
      bubbleScrubPoints = [
        const Offset(60, 50),
        const Offset(100, 70),
        const Offset(50, 100),
        const Offset(20, 80),
        const Offset(50, 60),
        const Offset(45, 110),
        const Offset(70, 42),
        const Offset(115, 110),
      ];
    }

    return GestureDetector(
      onPanUpdate: (DragUpdateDetails details) {
        if (state.isWashed) return;

        RenderBox renderBox = context.findRenderObject() as RenderBox;
        Offset localPosition = renderBox.globalToLocal(details.globalPosition);

        setState(() {
          bubbleScrubPoints.removeWhere(
            (bubblePos) => (bubblePos - localPosition).distance < 25.0,
          );
        });

        if (bubbleScrubPoints.isEmpty && !state.isWashed) {
          petProvider.wash();
          petProvider.washing.value = false;

          final overlay = Overlay.of(context);
          final entry = OverlayEntry(
            builder: (_) => Positioned(
              bottom: 120,
              left: 0,
              right: 0,
              child: Center(
                child: Dialogue(
                  dialogue: 'I am so clean now!٩(^ᗜ^ )و ´-'
                )
              )
            ));

          overlay.insert(entry);
          Future.delayed(const Duration(seconds: 3)).then((_) => entry.remove()); 
        }
      },
      child: SizedBox(
        width: 200,
        height: 200,
        child: Stack(
          children: [
            Image.asset(
              'assets/pets/${state.petType.name}.png',
              width: 300,
              height: 300,
              filterQuality: FilterQuality.none,
            ),
            if(bottom != '')
              Image.asset(
                'assets/outfits/bottoms/$bottom.png',
                width: 300,
                height: 300,
                filterQuality: FilterQuality.none,
              ),

              if(top != '')
              Image.asset(
                'assets/outfits/tops/$top.png',
                width: 300,
                height: 300,
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
                    setState(() => reset());
                  });
                }
                return const SizedBox.shrink();
              }
            )
          ],
        ),
      )
    );
  }

  void reset(){
    bubbleScrubPoints = [
        const Offset(60, 50),
        const Offset(100, 70),
        const Offset(50, 100),
        const Offset(20, 80),
        const Offset(50, 60),
        const Offset(45, 110),
        const Offset(70, 42),
        const Offset(115, 110),
      ];
  }


}
