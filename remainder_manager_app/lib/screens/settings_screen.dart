import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _vibrationEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadVibrationSetting();
  }

  Future<void> _loadVibrationSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
    });
  }

  Future<void> _saveVibrationSetting(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vibration_enabled', value);
     debugPrint("💾 Saved vibration_enabled: $value");
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final year = DateTime.now().year;

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  // 🔔 VIBRATION TOGGLE
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SwitchListTile(
                      title: const Text(
                        "Notification Vibration",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: const Text("Enable or disable vibration"),
                      value: _vibrationEnabled,
                      activeColor: colorScheme.primary,
                      onChanged: (value) {
                        setState(() {
                          _vibrationEnabled = value;
                        });
                        _saveVibrationSetting(value);
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 🔹 ABOUT SECTION
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ExpansionTile(
                      leading: Icon(
                        Icons.info_outline,
                        color: colorScheme.primary,
                      ),
                      title: const Text(
                        "About App",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            "RemindMe is a modern reminder app designed to help "
                            "you stay productive and organized.\n\n"
                            "Create smart reminders, manage schedules easily, "
                            "and never miss important moments.",
                            style: TextStyle(height: 1.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 🔹 FOOTER
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              "© $year RemindMe. All rights reserved.",
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
