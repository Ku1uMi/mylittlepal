import 'package:flutter/material.dart';

class ActionSheet extends StatelessWidget{
  final String text;
  final Widget child;
  final String icon;
  //final String name;

  const ActionSheet({
    required this.text,
    required this.child,
    required this.icon,
    //required this.name
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        //border: Border()
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontFamily: 'Pixelify Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context), 
                icon: Image.asset(icon)
              )
            ],
          ),
          const SizedBox(height: 16,),
          child,
          const SizedBox(height: 16,)
        ],
      ),
    );
  }

}