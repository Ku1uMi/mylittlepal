import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:yourlittlepal/l10n/app_localizations.dart';
import 'package:yourlittlepal/providers/pet_provider.dart';
import 'package:yourlittlepal/models/pet_state.dart';

class OutfitView extends StatefulWidget {
  const OutfitView({super.key});

  @override
  State<OutfitView> createState() => _OutfitPageState();
}

class _OutfitPageState extends State<OutfitView> {
  bool viewingTops = true;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PetProvider>(context);
    final petState = provider.state;
    final l10n = AppLocalizations.of(context)!;
    // FIXED: Reads directly from your real petState.ownedToy list
    final availableTops = petState.ownedTops;
    final availableBottoms = petState.ownedBottoms;
    final activeInventory = viewingTops ? availableTops : availableBottoms;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F1EA),
      appBar: AppBar(
        title: Text(
          'OUTFIT',
          style: GoogleFonts.pixelifySans(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
          )              
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
                    style: GoogleFonts.pixelifySans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2B2B2B)
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
              child: Center(
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
                
                    if (petState.currOutfit.top != '')
                     // Positioned.fill(
                        /*child:*/Image.asset(
                          'assets/outfits/tops/${petState.currOutfit.top}.png',
                          width: 160,
                          height: 160,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.none,
                        ),
                     // ),
                    if (petState.currOutfit.bottom != '')
                     // Positioned.fill(
                        /*child:*/ Image.asset(
                          'assets/outfits/bottoms/${petState.currOutfit.bottom}.png',
                          width: 160,
                          height: 160,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.none,
                        ),
                     // ),
                  ],
                ),
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
                      l10n.top,
                      viewingTops,
                      () => setState(() => viewingTops = true),
                    ),
                    const SizedBox(width: 6),
                    _buildSubCategoryTab(
                      l10n.bottom,
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
                      viewingTops ? l10n.noTopsOwned : l10n.noBottomsOwned,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.pixelifySans(
                        color: Colors.grey,
                        height: 1.3,
                      ),  
                    ),
                  )
                : GridView.builder(
                    key: ValueKey(viewingTops),
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
                    itemCount: activeInventory.length + 1,
                    itemBuilder: (context, index) {
                      

                      if(index == 0){
                        petState.currOutfit.bottom == '';
                        return GestureDetector(
                          onTap:() {
                            if(viewingTops){
                              provider.changeOutfit(top: '');
                            }else{
                              provider.changeOutfit(bottom: '');
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFECE4),
                              border: Border.all(
                                  color: const Color(0xFF2B2B2B),
                                  width: 2,
                              ), 
                            ),
                            child: Center(
                              child: Text(
                                l10n.none,
                               style: GoogleFonts.pixelifySans(
                                fontSize: 14,
                                color: const Color(0xFF2B2B2B)
                              ),
                            ),
                          )
                          )
                        );
                      }
                      final itemId = activeInventory[index - 1];

                      String exactAssetPath = '';
                      if (viewingTops) {
                        exactAssetPath = 'assets/outfits/tops/$itemId.png';
                      } else {
                        exactAssetPath = 'assets/outfits/bottoms/$itemId.png';
                      }

                      return GestureDetector(
                        onTap: () {

                          if(viewingTops){
                            provider.changeOutfit(top: itemId);
                          } else {
                            provider.changeOutfit(bottom: itemId);
                          }
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
                                itemId,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.pixelifySans(
                                  color: Color(0xFF2B2B2B),
                                  height: 1.1,
                                  fontSize: 10,
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
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  l10n.saveClose,
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
          style: GoogleFonts.pixelifySans(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : const Color(0xFF2B2B2B),
          ),
        ),
      ),
    );
  }
}
