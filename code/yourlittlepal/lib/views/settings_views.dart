import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yourlittlepal/l10n/app_localizations.dart';
import 'package:yourlittlepal/providers/pet_provider.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  // --- Settings States ---
  //String _selectedLanguage = 'English';
  //double _fontSize = 14.0;
  //double _brightness = 0.8;

  TimeOfDay _sleepTime = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _mealTime = const TimeOfDay(hour: 12, minute: 0);
  TimeOfDay _wakeTime = const TimeOfDay(hour: 8, minute: 0);

  // --- Helper to pick times ---
  Future<void> _selectTime(
    BuildContext context,
    String type,
    TimeOfDay initialTime,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null) {
      setState(() {
        if (type == 'sleep') _sleepTime = picked;
        if (type == 'meal') _mealTime = picked;
        if (type == 'wake') _wakeTime = picked;
      });
    }
  }

  static const _languages = {
    'English': Locale('en', ''), 
    'Español': Locale('es', ''), 
    '繁體中文': Locale('zh','TW')

  }; 

  String _localeToDisplayName(Locale locale){
    for(final e in _languages.entries){
      if(e.value.languageCode == locale.languageCode){
        return e.key;
      }
    }
    return 'English';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PetProvider>();
    final selectedLang = _localeToDisplayName(provider.currentLocale);
    final fontSize = provider.fontSize;
    final brightness = provider.brightness;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F1EA), // App retro canvas color
      appBar: AppBar(
        title: Text(
          l10n.settings,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF2B2B2B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // ==================== SECTION 1: SETTINGS PAGE ====================
             Text(
              l10n.appSettings,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2B2B2B),
              ),
            ),
            const SizedBox(height: 8),

            Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xFF2B2B2B), width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    // Language Selection
                    ListTile(
                      title: Text(
                        l10n.language,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: DropdownButton<String>(
                        value: selectedLang,
                        items: _languages.keys.map((String val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(val),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            provider.setLocale(_languages[val]!);
                          }
                        },
                      ),
                    ),
                    const Divider(),

                    // Font Size Selection
                    ListTile(
                      title:  Text(
                        l10n.fontSize,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Slider(
                        value: fontSize,
                        min: 12.0,
                        max: 24.0,
                        divisions: 4,
                        activeColor: const Color(0xFF2B2B2B),
                        label: '${fontSize.toInt()}px',
                        onChanged: (val) => provider.setFontSize(val),
                      ),
                    ),
                    const Divider(),

                    // Brightness Selection
                    ListTile(
                      title: Text(
                        l10n.brightness,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Slider(
                        value: brightness,
                        activeColor: const Color(0xFF2B2B2B),
                        onChanged: (val) => provider.setBrightness(val),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ==================== SECTION 2: ROUTINE SCHEDULES ====================
            Text(
              l10n.petRoutineTimers,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2B2B2B),
              ),
            ),
            const SizedBox(height: 8),

            Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xFF2B2B2B), width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      l10n.setMealTime,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(_mealTime.format(context)),
                    onTap: () => _selectTime(context, 'meal', _mealTime),
                  ),
                  const Divider(),
                  ListTile(
                    title: Text(
                      l10n.setSleepTime,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(_sleepTime.format(context)),
                    onTap: () => _selectTime(context, 'sleep', _sleepTime),
                  ),
                  const Divider(),
                  ListTile(
                    title: Text(
                      l10n.setWakeTime,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(_wakeTime.format(context)),
                    onTap: () => _selectTime(context, 'wake', _wakeTime),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ==================== SECTION 3: NOTIFICATIONS ====================
            Text(
              l10n.notificationsSimulator,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2B2B2B),
              ),
            ),
            const SizedBox(height: 8),

            Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xFF2B2B2B), width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  // Care Alerts
                  ListTile(
                    title: Text(
                      l10n.careReminders,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle:  Text(
                      l10n.careRemindersDesc
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B2B2B),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                            content: Text(
                              l10n.snackCareReminder,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        l10n.test,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const Divider(),

                  // Status box updates
                  ListTile(
                    title: Text(
                      l10n.petMessageStatuses,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      l10n.petMessageSimDesc
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B2B2B),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                            content: Text(
                              l10n.snackPetMessage,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        l10n.test,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const Divider(),

                  // Bedtime Alerts
                  ListTile(
                    title: Text(
                      l10n.sleepAlertTitle,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      l10n.sleepAlertSimDesc
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B2B2B),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              l10n.snackBedtime(_sleepTime.format(context)),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        l10n.test,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }
}
