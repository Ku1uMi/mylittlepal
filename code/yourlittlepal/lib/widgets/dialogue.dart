import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            Image.asset(
              'assets/icons/dialogue.png',
              width: 256,
              height: 150,
              fit: BoxFit.fill,
              filterQuality: FilterQuality.none,
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                dialogue,
                textAlign: TextAlign.center,
                style: GoogleFonts.pixelifySans(
                        fontSize: 14,
                        color: Colors.black
                ),
              ),
            )

            
          ],
        ),
      )      
    );
  }
  
}