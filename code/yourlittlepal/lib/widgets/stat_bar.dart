import 'package:flutter/material.dart';

class StatBar extends StatelessWidget{
    final String name;
    final double val;
    final Color color;

    const StatBar({
      super.key,
      required this.name,
      required this.val,
      required this.color
    });
    
      @override
      Widget build(BuildContext context) {
        final percent = (val * 100).toInt();
        return Row(
          children: [
            SizedBox(
              width: 90,
              child: Text(
                name,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Pixelify Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.bold
                )
              )
            ),
            Expanded(
              child: Container(
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(color: Colors.black, width: 2)
                ),
                child: FractionallySizedBox(
                  alignment:Alignment.centerLeft,
                  widthFactor: val.clamp(0, 1),
                  child: Container(color: color,),
                )
              )
            ),
            const SizedBox(width: 8,),
            SizedBox(
              width: 36,
              child: Text(
                '$percent',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Pixelify Sans'
                )

              ),
            )
          ],
        );
      }
  }