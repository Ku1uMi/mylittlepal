import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for rootBundle
import 'package:provider/provider.dart';
import 'package:yourlittlepal/providers/pet_provider.dart';
import 'package:yourlittlepal/widgets/canvas_painter.dart';

class PetView extends StatefulWidget {
  const PetView({super.key});

  @override
  State<PetView> createState() => _PetViewState();
}

class _PetViewState extends State<PetView> {
  List<Offset> bubbleScrubPoints = [];
  ui.Image? bubbleImage; // Holds our pixel art bubble

  @override
  void initState() {
    super.initState();
    _loadBubbleAsset();
  }

  // Helper method to load and decode the custom PNG asset into memory
  Future<void> _loadBubbleAsset() async {
    try {
      final ByteData data = await rootBundle.load('assets/effects/bubble.png');
      final ui.Codec codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
      );
      final ui.FrameInfo fi = await codec.getNextFrame();
      setState(() {
        bubbleImage = fi.image;
      });
    } catch (e) {
      debugPrint("Error loading bubble asset: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);
    final state = petProvider.state;

    // Reset/populate initial bubbles if pet needs washing and the list is empty
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
        child: CustomPaint(
          painter: CanvasPainter(
            petType: state.petType,
            remainingBubbles: bubbleScrubPoints,
            bubbles: bubbleScrubPoints,
            bubble:
                bubbleImage, // <-- Pass the loaded image asset directly down to the painter
          ),
        ),
      ),
    );
  }
}
