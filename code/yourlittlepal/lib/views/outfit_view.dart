import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yourlittlepal/providers/pet_provider.dart';
import 'package:yourlittlepal/models/pet_state.dart';

class OutfitPage extends StatefulWidget {
  const OutfitPage({super.key});

  @override
  State<OutfitPage> createState() => _OutfitPageState(); // FIXED: Matches the state class below
}

class _OutfitPageState extends State<OutfitPage> {
  bool viewingTops = true;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PetProvider>(context);
    final petState = provider.state;

    // FIXED: Reads directly from your real petState.ownedToy list
    final availableTops = petState.ownedToy
        .where((id) => id.startsWith('t'))
        .toList();
    final availableBottoms = petState.ownedToy
        .where((id) => id.startsWith('b'))
        .toList();
    final activeInventory = viewingTops ? availableTops : availableBottoms;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F1EA), // Notebook cream base color
      appBar: AppBar(
        title: const Text(
          'OUTFIT',
          style: TextStyle(fontFamily: 'PixelFont', fontSize: 22),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/icons/coins.png',
                    width: 22,
                    height: 22,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.none,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Coins: ${petState.coins}',
                    style: const TextStyle(
                      fontFamily: 'PixelFont',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2B2B2B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. MAIN CHARACTER PREVIEW COMPARTMENT
          Expanded(
            flex: 5,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFEFECE4),
                border: Border.all(color: const Color(0xFF2B2B2B), width: 3),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Base dynamic character layer (Sky or Ocean)
                  Image.asset(
                    'assets/pets/${petState.petType == PetType.sky ? 'sky' : 'ocean'}.png',
                    width: 160,
                    height: 160,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.none,
                  ),

                  if (provider.state.currOutfit.top != null)
                    Positioned.fill(
                      child: Image.asset(
                        provider.state.currOutfit.top,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.none,
                      ),
                    ),
                  if (provider.state.currOutfit.bottom != null)
                    Positioned.fill(
                      child: Image.asset(
                        provider.state.currOutfit.bottom,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.none,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // 2. INTERMEDIATE CONTROLS TOOLBAR
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 4.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.undo,
                        color: Color(0xFF2B2B2B),
                        size: 28,
                      ),
                      onPressed: petState.undo.isEmpty
                          ? null
                          : () => provider.undo(),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.redo,
                        color: Color(0xFF2B2B2B),
                        size: 28,
                      ),
                      onPressed: petState.redo.isEmpty
                          ? null
                          : () => provider.redo(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildSubCategoryTab(
                      'Top',
                      viewingTops,
                      () => setState(() => viewingTops = true),
                    ),
                    const SizedBox(width: 6),
                    _buildSubCategoryTab(
                      'Bottom',
                      !viewingTops,
                      () => setState(() => viewingTops = false),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(
            color: Color(0xFF2B2B2B),
            thickness: 2,
            indent: 24,
            endIndent: 24,
          ),

          // 3. WARDROBE GRID SECTOR
          Expanded(
            flex: 4,
            child: activeInventory.isEmpty
                ? Center(
                    child: Text(
                      'No ${viewingTops ? 'tops' : 'bottoms'} owned yet.\nVisit the shop! 🛍️',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'PixelFont',
                        color: Colors.grey,
                        height: 1.3,
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.0,
                        ),
                    itemCount: activeInventory.length,
                    itemBuilder: (context, index) {
                      final itemId = activeInventory[index];

                      String exactAssetPath = '';
                      if (viewingTops) {
                        exactAssetPath = itemId == 't1'
                            ? 'assets/outfits/tops/navy_top.png'
                            : 'assets/outfits/tops/yellow_top.png';
                      } else {
                        exactAssetPath = itemId == 'b1'
                            ? 'assets/outfits/bottoms/beige_bottom.png'
                            : 'assets/outfits/bottoms/checked_skirt.png';
                      }

                      return GestureDetector(
                        onTap: () {
                          provider.equipClothingItem(itemId, viewingTops);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFECE4),
                            border: Border.all(
                              color: const Color(0xFF2B2B2B),
                              width: 2,
                            ),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.asset(
                                  exactAssetPath,
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.none,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'pic of\n${viewingTops ? 'top' : 'bottom'}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'PixelFont',
                                  fontSize: 10,
                                  color: Color(0xFF2B2B2B),
                                  height: 1.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // 4. PERSIST AND ESCAPE ACTION BAR
          Padding(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              bottom: 24,
              top: 8,
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF76A584),
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFF2B2B2B), width: 2.5),
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                onPressed: () {
                  provider.saveCurrentOutfitState();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Wardrobe choices synchronized! ✨'),
                    ),
                  );
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'SAVE & CLOSE',
                  style: TextStyle(
                    fontFamily: 'PixelFont',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubCategoryTab(
    String text,
    bool isSelected,
    VoidCallback action,
  ) {
    return InkWell(
      onTap: action,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2B2B2B) : const Color(0xFFEFECE4),
          border: Border.all(color: const Color(0xFF2B2B2B), width: 2),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'PixelFont',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : const Color(0xFF2B2B2B),
          ),
        ),
      ),
    );
  }
}
