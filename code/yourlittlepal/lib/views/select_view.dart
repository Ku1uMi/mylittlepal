import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:yourlittlepal/models/pet_state.dart';
import 'package:yourlittlepal/providers/pet_provider.dart';
//import 'package:google_fonts/google_fonts.dart';

class SelectView extends StatefulWidget {
  const SelectView({super.key});

  @override
  State<SelectView> createState() => _SelectViewState();
}

class _SelectViewState extends State<SelectView> {
  int? _selectedIndex;

  final List<Map<String, String>> totalPets = [
    {'name': 'CLOUDY', 'image': 'assets/pets/sky.png'},
    {'name': 'BUBBLE', 'image': 'assets/pets/ocean.png'},
  ];

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context, listen: false);
    final isAnyPetSelected = _selectedIndex != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F1EA),
      
      appBar: AppBar(
        title: Text(
          'CHOOSE YOUR PAL',
          style: GoogleFonts.pixelifySans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2B2B2B)
          ),
          
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),

            // Grid layout showing character choices cleanly
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  itemCount: totalPets.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, index) {
                    final pet = totalPets[index];
                    final isSelected = _selectedIndex == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF2B2B2B)
                                : Colors.transparent,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 120,
                                width: 120,
                                child: Image.asset(
                                  pet['image']!,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.pets,
                                      size: 120,
                                      color: Color(0xFF2B2B2B),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              pet['name']!,
                              style: GoogleFonts.pixelifySans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2B2B2B)
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // --- HIGHLIGHTABLE CONFIRM PAL BUTTON ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAnyPetSelected
                        ? const Color(0xFF2B2B2B)
                        : const Color(0xFFD6D1C4),
                    foregroundColor: isAnyPetSelected
                        ? Colors.white
                        : const Color(0xFF8A857B),
                    elevation: 0,
                    side: const BorderSide(color: Color(0xFF2B2B2B), width: 3),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: !isAnyPetSelected
                      ? null
                      : () {
                          final selectedPetName =
                              totalPets[_selectedIndex!]['name']!;

                          // 1. Initialize and lock in the chosen pet data
                          try {
                            petProvider.selectPet(selectedPetName as PetType);
                          } catch (_) {}

                          // 2. Smoothly transition directly over to your main game loop arena!
                          Navigator.of(
                            context,
                          ).pushReplacementNamed('/playground');
                        },
                  child: Text(
                    'CONFIRM PAL',
                    style: GoogleFonts.pixelifySans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                  
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
