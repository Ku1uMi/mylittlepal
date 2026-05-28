import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 48),

            // --- THE PLAY / START GAME BUTTON ---
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF2B2B2B),
                elevation: 0,
                side: const BorderSide(color: Color(0xFF2B2B2B), width: 3),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // Sharp retro corners
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/playground');
              },
              child: const Text(
                'PLAY',
                style: TextStyle(
                  fontFamily: 'PixelFont',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
