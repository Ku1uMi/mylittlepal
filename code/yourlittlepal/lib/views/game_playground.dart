import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yourlittlepal/providers/pet_provider.dart';
import 'package:yourlittlepal/views/pet_view.dart';

class GamePlaygroundView extends StatefulWidget {
  const GamePlaygroundView({super.key});

  @override
  State<GamePlaygroundView> createState() => _GamePlaygroundViewState();
}

class _GamePlaygroundViewState extends State<GamePlaygroundView> {
  // Game Interface Triggers
  String _activeDialogue = "Hello friend! Let's play together! ✨";
  String _currentMoodExpression = "NORMAL"; // NORMAL, HAPPY, MAD, SAD
  bool _isWet = false;

  // Custom Daily Tracker Limits
  int _feedsToday = 0;
  int _washesToday = 0;
  int _playsToday = 0;

  // Outfit Wardrobe State Management
  String? _selectedTop;
  String? _selectedAccessory;

  // Food & Items Databases
  final List<Map<String, dynamic>> _foodItems = [
    {'name': 'WATER', 'icon': '💧'},
    {'name': 'CARROT', 'icon': '🥕'},
    {'name': 'SHRIMP', 'icon': '🍤'},
    {'name': 'STEAK', 'icon': '🥩'},
    {'name': 'SALMON', 'icon': '🐟'},
    {'name': 'GRASS', 'icon': '🌿'},
    {'name': 'CHICKEN', 'icon': '🍗'},
  ];

  final List<Map<String, dynamic>> _toyItems = [
    {'name': 'FEATHER WAND', 'icon': '🪶', 'type': 'TAP'},
    {'name': 'PEBBLE', 'icon': '🪨', 'type': 'TAP'},
    {'name': 'HAY BALLS', 'icon': '🧶', 'type': 'TAP'},
    {'name': 'SOCKS', 'icon': '🧦', 'type': 'TAP'},
    {'name': 'BONES', 'icon': '🦴', 'type': 'TAP'},
  ];

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);
    final selectedPet = petProvider.isLoaded
        ? petProvider.state.petType.toString().split('.').last.toUpperCase()
        : "PAL";

    return Scaffold(
      backgroundColor: const Color(0xFFF4F1EA),
      appBar: AppBar(
        title: Text(
          '$selectedPet\'S PLAYGROUND 🐾',
          style: const TextStyle(
            fontFamily: 'PixelFont',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF2B2B2B)),
            onPressed: () {
              setState(() {
                _feedsToday = 0;
                _washesToday = 0;
                _playsToday = 0;
                _activeDialogue = "Daily interaction logs reset!";
              });
            },
            tooltip: "Reset Daily Caps",
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. TOP DASHBOARD METERS & LIMIT COUNTERS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDailyCapIndicator("FEED: $_feedsToday/3"),
                  _buildDailyCapIndicator("WASH: $_washesToday/1"),
                  _buildDailyCapIndicator("PLAY: $_playsToday/2"),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 2. MAIN CENTER PLATFORM (The Interactive Drag Target Room)
            Expanded(
              flex: 4,
              child: Center(
                child: DragTarget<Map<String, dynamic>>(
                  onAcceptWithDetails: (details) {
                    final item = details.data;
                    if (item.containsKey('type')) {
                      _handlePlayToy(item, selectedPet);
                    } else {
                      _handleFeedItem(item, selectedPet);
                    }
                  },
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      margin: const EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: candidateData.isNotEmpty
                            ? Colors.white.withValues(alpha: 0.9)
                            : Colors.white.withValues(alpha: 0.5),
                        border: Border.all(
                          color: const Color(0xFF2B2B2B),
                          width: 3,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Base Visual Room Container for PetView
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Displays Current Custom Mood Overlays
                              Text(
                                'Mood: $_currentMoodExpression',
                                style: const TextStyle(
                                  fontFamily: 'PixelFont',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),

                              // The Actual Pet Canvas Render Wrapper
                              const SizedBox(
                                height: 150,
                                width: 150,
                                child: PetView(),
                              ),

                              if (_isWet)
                                const Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    "💦 WET! TAP RAPIDLY TO DRY! 💦",
                                    style: TextStyle(
                                      fontFamily: 'PixelFont',
                                      color: Colors.blue,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          // CLOTHING OVERLAY STACKS (Paper-Doll System)
                          if (_selectedTop != null)
                            Positioned(
                              top: 60,
                              child: Text(
                                _selectedTop!,
                                style: const TextStyle(fontSize: 34),
                              ),
                            ),
                          if (_selectedAccessory != null)
                            Positioned(
                              top: 30,
                              child: Text(
                                _selectedAccessory!,
                                style: const TextStyle(fontSize: 28),
                              ),
                            ),

                          // Invisible trigger to handle scrubbing/drying via touch gestures
                          Positioned.fill(
                            child: GestureDetector(
                              onPanEnd: (_) => _handleWashingLogic(),
                              onTap: () {
                                if (_isWet) {
                                  setState(() {
                                    _isWet = false;
                                    _activeDialogue =
                                        "All dried off and fluffy! 🧼";
                                    _currentMoodExpression = "HAPPY";
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            // 3. RETRO CHARACTER DIALOGUE BOX
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2B2B2B),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _activeDialogue,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'PixelFont',
                    fontSize: 13,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
              ),
            ),

            // 4. ACTION SHELF MANAGER (Tabs for Inventory Feed / Wardrobe)
            Expanded(
              flex: 3,
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    const TabBar(
                      labelColor: Color(0xFF2B2B2B),
                      indicatorColor: Color(0xFF2B2B2B),
                      labelStyle: TextStyle(
                        fontFamily: 'PixelFont',
                        fontWeight: FontWeight.bold,
                      ),
                      tabs: [
                        Tab(text: "DIET 🥕"),
                        Tab(text: "TOYS ⚽"),
                        Tab(text: "CLOTHES 👑"),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildDraggableInventoryGrid(_foodItems),
                          _buildDraggableInventoryGrid(_toyItems),
                          _buildWardrobeDressingRoom(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- ENGINE LOGIC: DRAG INTERACTION REACTION HANDLING ---
  void _handleFeedItem(Map<String, dynamic> item, String petName) {
    if (_feedsToday >= 3) {
      setState(
        () =>
            _activeDialogue = "Your Pal is completely full! Max 3 times a day.",
      );
      return;
    }

    final food = item['name'] as String;
    bool likesFood = false;

    // Custom Tier Lists based on your specification requirements
    if (petName == "RABBIT") {
      if (food == "CARROT" || food == "GRASS" || food == "WATER") {
        likesFood = true;
      }
    } else if (petName == "GOAT") {
      if (food == "GRASS" || food == "CARROT" || food == "WATER") {
        likesFood = true;
      }
    } else {
      if (food == "STEAK" || food == "CHICKEN" || food == "SALMON") {
        likesFood = true;
      }
    }

    setState(() {
      _feedsToday++;
      if (likesFood) {
        _currentMoodExpression = "HAPPY";
        _activeDialogue = "Munch Munch! Loved the $food! (+Health) ❤️";
      } else {
        _currentMoodExpression = "MAD";
        _activeDialogue =
            "Hmph! $petName does not like $food... (Sad/Mad Status)";
      }
    });
  }

  void _handlePlayToy(Map<String, dynamic> toy, String petName) {
    if (_playsToday >= 2) {
      setState(
        () => _activeDialogue =
            "Your Pal is too tired to play! Max 2 times a day.",
      );
      return;
    }

    setState(() {
      _playsToday++;
      _currentMoodExpression = "HAPPY";
      _activeDialogue =
          "You played with the ${toy['name']}! Interaction technique: ${toy['type']}! ✨";
    });
  }

  void _handleWashingLogic() {
    if (_washesToday >= 1) {
      setState(
        () => _activeDialogue = "Already squeaky clean! Max once per day.",
      );
      return;
    }
    setState(() {
      _washesToday++;
      _isWet = true;
      _activeDialogue =
          "Scrubbed with bubbles! Now TAP rapidly (simulating shaking device) to shake dry!";
    });
  }

  // --- WIDGET GRAPHICS BUILDERS ---
  Widget _buildDailyCapIndicator(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF2B2B2B), width: 2),
        color: Colors.white,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'PixelFont',
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDraggableInventoryGrid(List<Map<String, dynamic>> items) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return Draggable<Map<String, dynamic>>(
          data: item,
          feedback: Material(
            color: Colors.transparent,
            child: Text(item['icon'], style: const TextStyle(fontSize: 44)),
          ),
          childWhenDragging: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFF2B2B2B), width: 2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item['icon'], style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 2),
                Text(
                  item['name'],
                  style: const TextStyle(
                    fontFamily: 'PixelFont',
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWardrobeDressingRoom() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Text(
          "TOP APPAREL (Depends on mood)",
          style: TextStyle(
            fontFamily: 'PixelFont',
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            _buildClothingItemButton(
              "👕 Red Shirt",
              () => setState(() => _selectedTop = "👕"),
            ),
            _buildClothingItemButton(
              "🧥 Winter Coat",
              () => setState(() => _selectedTop = "🧥"),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          "ACCESSORIES",
          style: TextStyle(
            fontFamily: 'PixelFont',
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            _buildClothingItemButton(
              "👑 Crown",
              () => setState(() => _selectedAccessory = "👑"),
            ),
            _buildClothingItemButton(
              "🕶️ Glasses",
              () => setState(() => _selectedAccessory = "🕶️"),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            shape: const RoundedRectangleBorder(),
          ),
          onPressed: () => setState(() {
            _selectedTop = null;
            _selectedAccessory = null;
          }),
          child: const Text(
            "UNDO / RESET CLOTHES",
            style: TextStyle(fontFamily: 'PixelFont', fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildClothingItemButton(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF2B2B2B), width: 2),
          shape: const RoundedRectangleBorder(),
        ),
        onPressed: onTap,
        child: Text(
          title,
          style: const TextStyle(
            fontFamily: 'PixelFont',
            fontSize: 11,
            color: Color(0xFF2B2B2B),
          ),
        ),
      ),
    );
  }
}
