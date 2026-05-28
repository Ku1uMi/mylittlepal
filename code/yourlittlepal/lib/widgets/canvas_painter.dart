import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:yourlittlepal/models/pet_state.dart';

class CanvasPainter extends CustomPainter {
  final List<Offset> bubbles;
  final ui.Image? bubble;

  const CanvasPainter({
    required this.bubbles,
    this.bubble,
    required PetType petType,
    required List<ui.Offset> remainingBubbles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (bubble != null) {
      for (final position in bubbles) {
        final rect = Rect.fromCenter(center: position, width: 30, height: 30);

        paintImage(
          canvas: canvas,
          rect: rect,
          image: bubble!,
          filterQuality: FilterQuality.none,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CanvasPainter oldDelegate) {
    return oldDelegate.bubbles != bubbles;
  }
}
