import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:yourlittlepal/providers/pet_provider.dart';
import 'package:yourlittlepal/providers/position_provider.dart';
import 'package:yourlittlepal/providers/weather_provider.dart';
import 'package:yourlittlepal/views/outfit_view.dart';
import 'package:yourlittlepal/views/settings_views.dart';
import 'package:yourlittlepal/views/shop_view.dart';
import 'package:yourlittlepal/views/start_view.dart';
import 'package:yourlittlepal/views/select_view.dart';
import 'package:yourlittlepal/views/game_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final petProvider = PetProvider();
  final weatherProvider = WeatherProvider();
  final positionProvider = PositionProvider();

  // Initialize providers
  await petProvider.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: petProvider),
        ChangeNotifierProvider.value(value: weatherProvider),
        ChangeNotifierProvider.value(value: positionProvider),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return MaterialApp(
      title: 'Your Little Pal',
      debugShowCheckedModeBanner: false,
=======
    final provider = context.watch<PetProvider>();
    return ChangeNotifierProvider(
      create: (_) => PetProvider()..init(),
      child: MaterialApp(
        title: 'Your Little Pal',
        debugShowCheckedModeBanner: false,
>>>>>>> d1ab4bb341d71674d45809598fc43b5509a5698b

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

<<<<<<< HEAD
      // --- Retro Sketch/Pixel Vibe Theme ---
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color.fromARGB(255, 248, 248, 248),
        textTheme: GoogleFonts.pixelifySansTextTheme(),
=======
        // --- Retro Sketch/Pixel Vibe Theme ---
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          scaffoldBackgroundColor: const Color.fromARGB(255, 248, 248, 248),
          textTheme: TextTheme(
            bodyLarge: TextStyle(
              fontFamily: 'Pixelify Sans',
              fontSize: provider.fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black
            ),
            headlineMedium: TextStyle(
              fontFamily: 'Pixelify Sans',
              fontSize: provider.fontSize + 10,
              fontWeight: FontWeight.bold,
              color: Colors.black
            ) 
          ),
        ),

        // --- Application Route Flow Hierarchy ---
        initialRoute: '/',
        routes: {
          '/': (context) => const StartPage(),
          '/select': (context) => const SelectView(),
          '/playground': (context) => const GameView(),
          '/settings': (context) => const SettingsView(),
          '/outfit': (context) => const OutfitView()
        },
>>>>>>> d1ab4bb341d71674d45809598fc43b5509a5698b
      ),

      // --- Application Route Flow Hierarchy ---
      // These are now inside MaterialApp where they belong
      initialRoute: '/',
      routes: {
        '/': (context) => const StartPage(),
        '/select': (context) => const SelectView(),
        '/playground': (context) => const GameView(),
        '/settings': (context) => const SettingsView(),
        '/outfit': (context) => const OutfitPage(),
        '/shop': (context) => const ShopView(),
      },
    );
  }
}
<<<<<<< HEAD
=======


>>>>>>> d1ab4bb341d71674d45809598fc43b5509a5698b
