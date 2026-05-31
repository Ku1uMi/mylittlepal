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

  String _getCleanPath(String category, String filename) {
    String base = filename.replaceAll('.png', '');
    return 'assets/outfits/$category/$base.png';
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PetProvider>(context);
    final petState = provider.state;

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
              child: Text(
                'Coins: ${petState.coins}',
                style: const TextStyle(
                  fontFamily: 'Pixelify Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2B2B2B),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFEFECE4),
                border: Border.all(color: const Color(0xFF2B2B2B), width: 3),
              ),
              child: GestureDetector(
                onPanStart: (details) => debugPrint("Gesture Started"),
                onPanUpdate: (details) =>
                    debugPrint("Pan Update: ${details.delta.dx}"),
                onPanEnd: (details) => debugPrint("Gesture Ended"),
                child: CustomPaint(
                  foregroundPainter: PremiumBadgePainter(),
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
                      if (provider.state.currOutfit.top.isNotEmpty)
                        Positioned.fill(
                          child: Image.asset(
                            _getCleanPath(
                              'tops',
                              provider.state.currOutfit.top,
                            ),
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.none,
                          ),
                        ),
                      if (provider.state.currOutfit.bottom.isNotEmpty)
                        Positioned.fill(
                          child: Image.asset(
                            _getCleanPath(
                              'bottoms',
                              provider.state.currOutfit.bottom,
                            ),
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.none,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
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
                  exactAssetPath = itemId == 't1'
                      ? 'assets/outfits/tops/navy_top.png'
                      : 'assets/outfits/tops/yellow_top.png';
                  shortFileName = itemId == 't1'
                      ? 'navy_top.png'
                      : 'yellow_top.png';
                  displayName = itemId == 't1' ? 'Navy Top' : 'Yellow Top';
                } else {
                  exactAssetPath = itemId == 'b1'
                      ? 'assets/outfits/bottoms/beige_bottom.png'
                      : 'assets/outfits/bottoms/checked_skirt.png';
                  shortFileName = itemId == 'b1'
                      ? 'beige_bottom.png'
                      : 'checked_skirt.png';
                  displayName = itemId == 'b1' ? 'Beige Pants' : 'Skirt';
                }
                return GestureDetector(
                  onTap: () =>
                      provider.equipClothingItem(shortFileName, viewingTops),
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

class PremiumBadgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 0.1), 10, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
