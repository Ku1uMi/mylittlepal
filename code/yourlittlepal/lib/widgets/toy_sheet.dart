import 'package:flutter/material.dart';

class ToySheet extends StatelessWidget{
  final String toy;
  final VoidCallback onTap;

  const ToySheet({
    required this.toy,
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
        child: Text(
          toy,
          style: const TextStyle(
            fontFamily: 'Pixelify Sans',
            fontSize: 12
          ),
        ),
      ),
    );
  }

  


}
