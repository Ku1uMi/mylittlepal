import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yourlittlepal/providers/pet_provider.dart';
import 'package:yourlittlepal/providers/position_provider.dart';
import 'package:yourlittlepal/providers/weather_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:yourlittlepal/views/start_view.dart';
import 'package:yourlittlepal/views/select_view.dart';
import 'package:yourlittlepal/views/game_view.dart';
import 'package:yourlittlepal/views/settings_views.dart'; // Note the 's' at the end
import 'package:yourlittlepal/views/outfit_view.dart';
import 'package:yourlittlepal/views/shop_view.dart';

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
    return MaterialApp(
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
        scaffoldBackgroundColor: const Color.fromARGB(255, 248, 248, 248),
        textTheme: GoogleFonts.pixelifySansTextTheme(),
      ),

      // --- Application Route Flow Hierarchy ---
      // These are now inside MaterialApp where they belong
      initialRoute: '/',
      routes: {
        '/': (context) => const StartPage(),
        '/select': (context) => const SelectView(),
        '/playground': (context) => const GameView(),
        '/settings': (context) => const SettingsView(),
        '/outfit': (context) => const OutfitView(),
        '/shop': (context) => const ShopView(),
      },
    );
  }
}
