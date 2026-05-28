import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yourlittlepal/providers/pet_provider.dart';
import 'package:yourlittlepal/models/petState.dart';

class PetView extends StatefulWidget {
  const PetView({super.key});

  @override
  State<PetView> createState() => _PetViewState();
}

class _PetViewState extends State<PetView> {
  // Keeps track of where the user is scrubbing on the pet
  List<Offset> bubbleScrubPoints = [];

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);
    final state = petProvider.state;

    // Generate a list of temporary visual bubbles if the pet is dirty/being washed
    if (state.isWashed == false && bubbleScrubPoints.isEmpty) {
      // Populates a few initial bubble coordinates across the canvas area
      bubbleScrubPoints = [
        const Offset(60, 50),
        const Offset(100, 70),
        const Offset(50, 100),
        const Offset(110, 110),
      ];
    }

    return GestureDetector(
      // --- Advanced Gesture Detection ---
      // Captures active multi-directional dragging coordinates across the widget framework
      onPanUpdate: (DragUpdateDetails details) {
        if (state.isWashed) return; // No bubbles to clear if already clean!

        // Get local coordinate inside this box container
        RenderBox renderBox = context.findRenderObject() as RenderBox;
        Offset localPosition = renderBox.globalToLocal(details.globalPosition);

        setState(() {
          // If the user's drag passes near a bubble, pop/remove it!
          bubbleScrubPoints.removeWhere(
            (bubblePos) => (bubblePos - localPosition).distance < 25.0,
          );
        });

        // If all bubbles are scrubbed away, trigger the official wash state logic
        if (bubbleScrubPoints.isEmpty && !state.isWashed) {
          petProvider.wash();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✨ Clean and refreshed! ✨')),
          );
        }
      },
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF2B2B2B), width: 4),
        ),
        // --- Canvas Drawing Widget ---
        child: CustomPaint(
          painter: PetCanvasPainter(
            petType: state.petType,
            remainingBubbles: bubbleScrubPoints,
          ),
        ),
      ),
    );
  }
}
