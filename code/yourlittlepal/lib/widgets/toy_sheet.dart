import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ToySheet extends StatelessWidget {
  final String toy;
  final VoidCallback onTap;

  const ToySheet({super.key, required this.toy, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white),
        child: Text(
          toy,
          style: GoogleFonts.pixelifySans(
                        fontSize: 12,
                ),
        ),
      ),
    );
  }
}
