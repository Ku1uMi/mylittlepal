import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yourlittlepal/providers/pet_provider.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F1EA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'MY LITTLE PAL 🐾',
              style: TextStyle(
                fontFamily: 'PixelFont',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: Color(0xFF2B2B2B),
              ),
            ),
            const SizedBox(height: 60),

            // --- OPTION A: If a pet save profile is already found ---
            if (petProvider.isLoaded) ...[
              ElevatedButton(
                style: _pixelButtonStyle(),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/playground');
                },
                child: const Text(
                  'CONTINUE GAME',
                  style: TextStyle(fontFamily: 'PixelFont', fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // --- OPTION B: Always offer the option to start a fresh game / select a new pet ---
            ElevatedButton(
              style: _pixelButtonStyle(invertColors: !petProvider.isLoaded),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/select');
              },
              child: const Text(
                'START',
                style: TextStyle(fontFamily: 'PixelFont', fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Consistent retro theme button styling helper
  ButtonStyle _pixelButtonStyle({bool invertColors = false}) {
    return ElevatedButton.styleFrom(
      backgroundColor: invertColors ? const Color(0xFF2B2B2B) : Colors.white,
      foregroundColor: invertColors ? Colors.white : const Color(0xFF2B2B2B),
      elevation: 0,
      side: const BorderSide(color: Color(0xFF2B2B2B), width: 3),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    );
  }
}
