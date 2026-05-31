import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:yourlittlepal/providers/pet_provider.dart';

class ShopView extends StatefulWidget {
  const ShopView({super.key});

  @override
  State<ShopView> createState() => _ShopViewState();
}

class _ShopViewState extends State<ShopView> {
  // Tabs: 'food' or 'toy'
  String activeTab = 'food';

  // Track the currently selected item name
  String? selectedItem;
  int? selectedPrice;

  // Define shop item data with prices and asset paths
  final Map<String, Map<String, dynamic>> foodItems = {
    'Carrot': {'price': 5, 'asset': 'assets/icons/carrot.png'},
    'Salmon': {'price': 15, 'asset': 'assets/icons/salmon.png'},
    'Shrimp': {'price': 12, 'asset': 'assets/icons/shrimp.png'},
    'Steak': {'price': 25, 'asset': 'assets/icons/steak.png'},
  };

  final Map<String, Map<String, dynamic>> toyItems = {
    'Hay Ball': {'price': 10, 'asset': 'assets/icons/hay_ball.png'},
    'Feather': {'price': 8, 'asset': 'assets/icons/feather.png'},
    'Pebble': {'price': 3, 'asset': 'assets/icons/pebble.png'},
    'Socks': {'price': 6, 'asset': 'assets/icons/socks.png'},
  };

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PetProvider>();
    final state = provider.state;

    // Switch items depending on active tab selection
    final currentItems = activeTab == 'food' ? foodItems : toyItems;

    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2B2B2B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'SHOP',
          style: GoogleFonts.pixelifySans(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,  
                        color: const Color(0xFF2B2B2B),          
          ),
          
        ),
        actions: [
          // Coin display top right matching wireframe layout
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Image.asset('assets/icons/coins.png', width: 24, height: 24),
                const SizedBox(width: 4),
                Text(
                  '${state.coins}',
                  style: GoogleFonts.pixelifySans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,  
                        color:Color(0xFF2B2B2B),          
                    ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // --- Tab Selection Bar (Food / Toy) ---
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  _buildTabButton('Food', 'food'),
                  const SizedBox(width: 12),
                  _buildTabButton('Toy', 'toy'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // --- Items Grid Layout ---
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: currentItems.length,
                  itemBuilder: (context, index) {
                    String itemName = currentItems.keys.elementAt(index);
                    var itemData = currentItems[itemName]!;
                    bool isSelected = selectedItem == itemName;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedItem = itemName;
                          selectedPrice = itemData['price'];
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            // Highlights cyan when selected matching point
                            color: isSelected
                                ? Colors.cyan
                                : const Color(0xFF33250E),
                            width: isSelected ? 3 : 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  itemData['asset'],
                                  filterQuality: FilterQuality
                                      .none, // Retains pixel aesthetic
                                ),
                              ),
                            ),
                            Text(
                              itemName,
                              style: GoogleFonts.pixelifySans(
                                  fontSize: 12,
                                  
                              ),
                              
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${itemData['price']}',
                              style: GoogleFonts.pixelifySans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,  
                                 
                              ),

                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // --- Action Buy Button (Point ②) ---
            if (selectedItem != null)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[100],
                    side: const BorderSide(color: Color(0xFF33250E), width: 2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (selectedPrice != null &&
                        state.coins >= selectedPrice!) {
                      // Process Purchase inside your PetProvider
                      if (activeTab == 'food') {
                        provider.buyFood(selectedItem!, selectedPrice!);
                      } else {
                        provider.buyToy(selectedItem!, selectedPrice!);
                      }

                      provider.showDialogue(
                        'Successfully bought $selectedItem! 🎉',
                      );
                      setState(() {
                        selectedItem = null; // Reset selection after buying
                        selectedPrice = null;
                      });
                    } else {
                      // Insufficient funds trigger dialogue matching wireframe logic notes
                      provider.showDialogue(
                        'No coins! ( ;´ - `;) Go play with your pet!',
                      );
                    }
                  },
                  child: Text(
                    'Buy',
                    style: GoogleFonts.pixelifySans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,  
                        color: Color(0xFF33250E),          
                    ),
                    
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Custom helper widget to render stylized pixel design tabs
  Widget _buildTabButton(String label, String tabKey) {
    bool isActive = activeTab == tabKey;
    return GestureDetector(
      onTap: () {
        setState(() {
          activeTab = tabKey;
          selectedItem = null; // Clear selection when switching categories
          selectedPrice = null;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? Colors.amber[100] : Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFF33250E), width: 2),
        ),
        child: Text(
          label,
          style: GoogleFonts.pixelifySans(
                        fontSize: 14,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal          
          ),
          
        ),
      ),
    );
  }
}
