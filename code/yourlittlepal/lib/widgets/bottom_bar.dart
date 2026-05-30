import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget{
  final String name;
  final String icon;
  final VoidCallback onTap;

  const BottomBar({
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
            width:24,
            height: 24,
            filterQuality: FilterQuality.none,
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            name,
            style: const TextStyle(
              fontFamily: 'PixelFont',
              fontSize: 10,
              fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }
  
}