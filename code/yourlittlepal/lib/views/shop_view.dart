import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yourlittlepal/providers/pet_provider.dart';

class ShopView extends StatefulWidget {
  const ShopView({super.key});

  @override
  State<ShopView> createState() => _ShopViewState();
}

class _ShopViewState extends State<ShopView> {
  String activeTab = 'food';
  String? selectedItem;
  int? selectedPrice;

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
    final currentItems = activeTab == 'food' ? foodItems : toyItems;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F1EA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 50,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF2B2B2B),
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'SHOP',
          style: TextStyle(
            fontFamily: 'Pixelify Sans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2B2B2B),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Image.asset('assets/icons/coins.png', width: 20, height: 20),
                const SizedBox(width: 6),
                Text(
                  '${state.coins}',
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
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  _buildTabButton('Food', 'food'),
                  const SizedBox(width: 8),
                  _buildTabButton('Toy', 'toy'),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: currentItems.length,
                  itemBuilder: (context, index) {
                    String itemName = currentItems.keys.elementAt(index);
                    var itemData = currentItems[itemName]!;
                    bool isSelected = selectedItem == itemName;

                    return GestureDetector(
                      onTap: () => setState(() {
                        selectedItem = itemName;
                        selectedPrice = itemData['price'];
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? Colors.cyan
                                : const Color(0xFF33250E),
                            width: isSelected ? 3 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Image.asset(
                                  itemData['asset'],
                                  filterQuality: FilterQuality.none,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Text(
                              itemName,
                              style: const TextStyle(
                                fontFamily: 'Pixelify Sans',
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${itemData['price']}',
                              style: const TextStyle(
                                fontFamily: 'Pixelify Sans',
                                fontSize: 12,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            if (selectedItem != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[100],
                    side: const BorderSide(color: Color(0xFF33250E), width: 2),
                    minimumSize: const Size(120, 40),
                  ),
                  onPressed: () {
                    if (state.coins >= selectedPrice!) {
                      provider.spendCoins(selectedPrice!);
                      activeTab == 'food'
                          ? provider.buyFood(selectedItem!, selectedPrice!)
                          : provider.buyToy(selectedItem!, selectedPrice!);

                      provider.showDialogue(
                        'Successfully purchased $selectedItem! 🎉',
                      );
                      setState(() {
                        selectedItem = null;
                        selectedPrice = null;
                      });
                    } else {
                      provider.showDialogue(
                        'No coins! ( ;´ - `;) Go play with your pet!',
                      );
                    }
                  },
                  child: const Text(
                    'Buy',
                    style: TextStyle(
                      fontFamily: 'Pixelify Sans',
                      fontSize: 16,
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

  Widget _buildTabButton(String label, String tabKey) {
    bool isActive = activeTab == tabKey;
    return GestureDetector(
      onTap: () => setState(() {
        activeTab = tabKey;
        selectedItem = null;
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? Colors.amber[100] : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFF33250E), width: 1.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Pixelify Sans',
            fontSize: 14,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
