import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yourlittlepal/providers/pet_provider.dart';
import 'package:yourlittlepal/models/pet_state.dart';

class OutfitPage extends StatefulWidget {
  const OutfitPage({super.key});

  @override
  State<OutfitPage> createState() => _OutfitPageState();
}

class _OutfitPageState extends State<OutfitPage> {
  bool viewingTops = true;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PetProvider>(context);
    final petState = provider.state;

    // Hardcoded item configurations so inventory options are always available
    const alwaysAvailableTops = ['t1', 't2'];
    const alwaysAvailableBottoms = ['b1', 'b2'];

    final activeInventory = viewingTops
        ? alwaysAvailableTops
        : alwaysAvailableBottoms;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F1EA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2B2B2B)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'OUTFIT',
          style: TextStyle(
            fontFamily: 'Pixelify Sans',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
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
                      fontFamily: 'Pixelify Sans',
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
                  Image.asset(
                    'assets/pets/${petState.petType == PetType.sky ? 'sky' : 'ocean'}.png',
                    width: 160,
                    height: 160,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.none,
                  ),

                  if (provider.currentTopAsset != null &&
                      provider.currentTopAsset!.isNotEmpty)
                    Positioned.fill(
                      child: Image.asset(
                        provider.currentTopAsset!.startsWith('assets/')
                            ? provider.currentTopAsset!
                            : 'assets/outfits/tops/${provider.currentTopAsset}',
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.none,
                      ),
                    ),
                  if (provider.currentBottomAsset != null &&
                      provider.currentBottomAsset!.isNotEmpty)
                    Positioned.fill(
                      child: Image.asset(
                        provider.currentBottomAsset!.startsWith('assets/')
                            ? provider.currentBottomAsset!
                            : 'assets/outfits/bottoms/${provider.currentBottomAsset}',
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
                          : () => provider.undoOutfitChange(),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.redo,
                        color: Color(0xFF2B2B2B),
                        size: 28,
                      ),
                      onPressed: petState.redo.isEmpty
                          ? null
                          : () => provider.redoOutfitChange(),
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
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
              ),
              itemCount: activeInventory.length,
              itemBuilder: (context, index) {
                final itemId = activeInventory[index];

                String exactAssetPath = '';
                String shortFileName = '';
                String displayName = '';

                if (viewingTops) {
                  if (itemId == 't1') {
                    exactAssetPath = 'assets/outfits/tops/navy_top.png';
                    shortFileName = 'navy_top.png';
                    displayName = 'Navy Top';
                  } else {
                    exactAssetPath = 'assets/outfits/tops/yellow_top.png';
                    shortFileName = 'yellow_top.png';
                    displayName = 'Yellow Top';
                  }
                } else {
                  if (itemId == 'b1') {
                    exactAssetPath = 'assets/outfits/bottoms/beige_bottom.png';
                    shortFileName = 'beige_bottom.png';
                    displayName = 'Beige Pants';
                  } else {
                    exactAssetPath = 'assets/outfits/bottoms/checked_skirt.png';
                    shortFileName = 'checked_skirt.png';
                    displayName = 'Skirt';
                  }
                }

                return GestureDetector(
                  onTap: () {
                    // FIXED: Passes only the short file name that the background view logic naturally expects!
                    provider.equipClothingItem(shortFileName, viewingTops);
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
                        const SizedBox(height: 4),
                        Text(
                          displayName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Pixelify Sans',
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
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
                    const SnackBar(content: Text('Nice outfit! ✨')),
                  );
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'SAVE & CLOSE',
                  style: TextStyle(
                    fontFamily: 'Pixelify Sans',
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
            fontFamily: 'Pixelify Sans',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : const Color(0xFF2B2B2B),
          ),
        ),
      ),
    );
  }
}
