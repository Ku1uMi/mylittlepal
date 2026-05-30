import 'package:flutter/material.dart';

class Dialogue extends StatelessWidget{
  final String dialogue;
  
  const Dialogue({
    super.key,
    required this.dialogue
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: 200,
        height: 134,
        child: Stack(
          alignment: AlignmentGeometry.center,
          children: [
            Container(
              width: 200,
              height: 134,
              color: const Color.fromARGB(255, 255, 250, 238),
            ),
            Image.asset(
              'assets/icons/dialogue_frame.png',
              width: 256,
              height: 134,
              filterQuality: FilterQuality.none,
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                dialogue,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'PixelFont',
                  fontSize: 14
                ),
              ),
            )

            
          ],
        ),
      )      
    );
  }
  
}