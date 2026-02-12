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
    final year = DateTime.now().year;

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    childrenPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    leading: Icon(
                      Icons.info_outline,
                      color: colorScheme.primary,
                    ),
                    title: const Text(
                      "About App",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
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
