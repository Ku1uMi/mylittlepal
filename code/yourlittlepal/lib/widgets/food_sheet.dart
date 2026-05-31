import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodSheet extends StatelessWidget{
  final String food;
  final int num;
  final VoidCallback? onTap;

  const FoodSheet({
    super.key,
    required this.food,
    required this.num,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white
        ),
        child: Column(
          children: [
            Text(
              food,
              style: GoogleFonts.pixelifySans(
                      fontSize: 12,
              ),
            ),
            Text(
                ' x$num',
                style: GoogleFonts.pixelifySans(
                        fontSize: 12,
                ),
            )
          ],
        )
      ),
    );
  }
    
}