import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  // --- Settings States ---
  String _selectedLanguage = 'English';
  double _fontSize = 14.0;
  double _brightness = 0.8;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F1EA), // App retro canvas color
      appBar: AppBar(
        title: const Text(
          'SETTINGS & NOTIFICATIONS',
          style: TextStyle(fontWeight: FontWeight.bold),
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
            const Text(
              'APP SETTINGS',
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
                      title: const Text(
                        'Language / Idioma',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: DropdownButton<String>(
                        value: _selectedLanguage,
                        items: ['English', 'Español', '繁體中文'].map((String val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(val),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedLanguage = val);
                          }
                        },
                      ),
                    ),
                    const Divider(),

                    // Font Size Selection
                    ListTile(
                      title: const Text(
                        'Font Size',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Slider(
                        value: _fontSize,
                        min: 12.0,
                        max: 24.0,
                        divisions: 4,
                        activeColor: const Color(0xFF2B2B2B),
                        label: '${_fontSize.toInt()}px',
                        onChanged: (val) => setState(() => _fontSize = val),
                      ),
                    ),
                    const Divider(),

                    // Brightness Selection
                    ListTile(
                      title: const Text(
                        'Screen Brightness',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Slider(
                        value: _brightness,
                        activeColor: const Color(0xFF2B2B2B),
                        onChanged: (val) => setState(() => _brightness = val),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ==================== SECTION 2: ROUTINE SCHEDULES ====================
            const Text(
              'PET ROUTINE TIMERS',
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
                    title: const Text(
                      'Set Meal Time',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(_mealTime.format(context)),
                    onTap: () => _selectTime(context, 'meal', _mealTime),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text(
                      'Set Sleeping Time',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(_sleepTime.format(context)),
                    onTap: () => _selectTime(context, 'sleep', _sleepTime),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text(
                      'Set Wake Up Time',
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
            const Text(
              'NOTIFICATIONS SIMULATOR',
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
                    title: const Text(
                      'Care Reminders',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      'Simulate alerts to feed, wash, or play',
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B2B2B),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              '🔔 Reminder: Remember to feed, wash, and play with your pal!',
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'TEST',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const Divider(),

                  // Status box updates
                  ListTile(
                    title: const Text(
                      'Pet Message Statuses',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      'Simulate hungry/thirsty/bored text box updates',
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B2B2B),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              '💬 Message Box: "I\'m lonely and my tummy is rumbling!"',
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'TEST',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const Divider(),

                  // Bedtime Alerts
                  ListTile(
                    title: const Text(
                      'Sleep Schedule Alerts',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      'Simulate bedtime notification target triggers',
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B2B2B),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '🌙 Bedtime Alert: It is ${_sleepTime.format(context)}. Time for your pal to go to sleep!',
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'TEST',
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
