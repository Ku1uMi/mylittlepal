import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomBar extends StatelessWidget{
  final String name;
  final String icon;
  final VoidCallback onTap;

  const BottomBar({
    super.key,
    required this.name,
    required this.icon,
    required this.onTap
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            icon,
            width:48,
            height: 48,
            filterQuality: FilterQuality.none,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            name,
            style: GoogleFonts.pixelifySans(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,             
            ),
          )
        ],
      ),
    );
  }
  
}