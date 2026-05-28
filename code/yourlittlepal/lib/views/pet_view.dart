import 'package:flutter/material.dart';
import 'package:yourlittlepal/widgets/canvas_painter.dart';
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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Clean and refreshed!')));
        }
      },
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          //color: Colors.white,
          //border: Border.all(color: const Color(0xFF2B2B2B), width: 4),
        ),
        // --- Canvas Drawing Widget ---
        child: CustomPaint(
          painter: CanvasPainter(
            petType: state.petType,
            remainingBubbles: bubbleScrubPoints,
            bubbles: [],
          ),
        ),
      ),
    );
  }
}
