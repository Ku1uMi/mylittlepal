import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:yourlittlepal/providers/pet_provider.dart';
import 'models/pet_info.dart';
import 'package:yourlittlepal/views/pet_view.dart';
import 'package:yourlittlepal/views/start_view.dart';
import 'package:yourlittlepal/views/select_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PetProvider(),
      child: MaterialApp(
        title: 'Your Little Pal',
        debugShowCheckedModeBanner: false,

        // --- Internationalization Configuration ---
        locale: const Locale('en', ''),
        supportedLocales: const [
          Locale('en', ''),
          Locale('es', ''),
          Locale('zh', 'TW'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        // --- Retro Sketch/Pixel Vibe Theme ---
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          scaffoldBackgroundColor: const Color(0xFFF4F1EA),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
              fontFamily: 'PixelFont',
              fontSize: 16,
              color: Color(0xFF2B2B2B),
            ),
            headlineMedium: TextStyle(
              fontFamily: 'PixelFont',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B2B2B),
            ),
          ),
        ),

        // --- Application Route Flow Hierarchy ---
        initialRoute: '/',
        routes: {
          '/': (context) => const StartPage(),
          '/select': (context) => const SelectView(),
          '/playground': (context) => const PetPlaygroundScreen(),
        },
      ),
    );
  }
}

// --- Main UI Playground Screen ---
class PetPlaygroundScreen extends StatelessWidget {
  const PetPlaygroundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);

    // Safeguard guard rail (in case it is directly accessed without loading)
    if (!petProvider.isLoaded) {
      return const Scaffold(
        body: Center(
          child: Text(
            'LOADING PAL...',
            style: TextStyle(fontFamily: 'PixelFont', fontSize: 18),
          ),
        ),
      );
    }

    final state = petProvider.state;
    final info = state.petType.info;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${info.name.toUpperCase()}🐾',
          style: const TextStyle(fontFamily: 'PixelFont'),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                '${state.coins}',
                style: const TextStyle(
                  fontFamily: 'PixelFont',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 1. Status Meters Container
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 0,
                color: Colors.white.withValues(alpha: 0.6),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Color(0xFF2B2B2B), width: 3),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildPixelStatBar(
                        'HEALTH',
                        state.health / 100,
                        Colors.redAccent,
                      ),
                      const SizedBox(height: 12),
                      _buildPixelStatBar(
                        'CLOSENESS',
                        state.closeness / 100,
                        Colors.orangeAccent,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 2. Interactive Tamagotchi Center Stage
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const PetView(),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFF2B2B2B),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          state.petType.getDialogue(state),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'PixelFont',
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. Command Grid Dashboard
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: [
                  _buildPixelButton(
                    'FEED',
                    () => petProvider.feed(info.favoriteFoods.first),
                  ),
                  _buildPixelButton('WATER', () => petProvider.water()),
                  _buildPixelButton('WASH', () => petProvider.wash()),
                  _buildPixelButton(
                    'PLAY',
                    () => petProvider.play(info.favoriteToys.first),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
/*
  // Helper builder generating custom status progress strips
  Widget _buildPixelStatBar(String label, double percentage, Color fill) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'PixelFont',
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 16,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            border: Border.all(color: const Color(0xFF2B2B2B), width: 2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage.clamp(0.0, 1.0),
            child: Container(color: fill),
          ),
        ),
      ],
    );
  }

  // Builder creating hard-bordered retro interaction keys
  Widget _buildPixelButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2B2B2B),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Color(0xFF2B2B2B), width: 3),
          borderRadius: BorderRadius.zero,
        ),
        padding: EdgeInsets.zero,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'PixelFont',
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  */
}
