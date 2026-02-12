import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withOpacity(0.4),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Theme(
            // 🔹 removes default divider line
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              collapsedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              tilePadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              childrenPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: Icon(
                Icons.info_outline,
                color: colorScheme.primary,
              ),
              title: const Text(
                "About App",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: AnimatedRotation(
                turns: _expanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 300),
                child: const Icon(Icons.keyboard_arrow_down),
              ),
              onExpansionChanged: (value) {
                setState(() {
                  _expanded = value;
                });
              },
              children: const [
                Text(
                  "RemindMe is a modern reminder app designed to help "
                  "you stay productive and organized.\n\n"
                  "Create smart reminders, manage schedules easily, "
                  "and never miss important moments.",
                  style: TextStyle(height: 1.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
