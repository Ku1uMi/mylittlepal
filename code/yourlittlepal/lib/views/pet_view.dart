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

    // Generate a list of soap bubbles if the pet is dirty/being washed
    final state = petProvider.state;
    if (state.isWashed == false && bubbleScrubPoints.isEmpty) {
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
    }

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

        if (bubbleScrubPoints.isEmpty && !state.isWashed) {
          petProvider.wash();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Clean and refreshed! 🧼')),
          );
        }
      },
      child: Container(
        width: 150,
        height: 150,
        color: Colors.transparent, // Keeps the room seamless
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1. THE PET IMAGE LAYER (Shows your selected pet!)
            Image.asset(
              assetPath,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.none, // Keeps pixels crisp
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.pets,
                  size: 60,
                  color: Color(0xFF2B2B2B),
                );
              },
            ),

            // 2. THE INTERACTIVE BUBBLE LAYER
            if (!state.isWashed)
              ...bubbleScrubPoints.map((point) {
                return Positioned(
                  left: point.dx,
                  top: point.dy,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

extension on Object {
  Future<void> toUpperCase() async {}
}
