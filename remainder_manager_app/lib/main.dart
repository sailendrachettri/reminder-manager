import 'package:flutter/material.dart';
import './screens/remainder_form.dart';
import './screens/summary_grid.dart';
import './screens/remainder_card.dart';
import 'utils/headings/section_headings.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ReminderApp());
}

class ReminderApp extends StatelessWidget {
  const ReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reminder App',

      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,

      home: const HomeScreen(),
    );
  }
}

/* ================= HOME SCREEN ================= */

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openAddReminder(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddReminderSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RemindMe')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children:  [
          SummaryGrid(),

          SectionHeading(title: 'This Month'),

          ReminderCard(
            title: 'Doctor Appointment',
            description: 'Health checkup',
            dateTime: DateTime(2026, 2, 8, 10, 30),
            type: 'Weekly',
          ),
          ReminderCard(
            title: 'Doctor Appointment',
            description: 'Health checkup and the treatement of dog and shopping at s mart mall',
            dateTime: DateTime(2026, 2, 18, 10, 30),
            type: 'Once',
          ),
          ReminderCard(
            title: 'Doctor Appointment',
            description: 'Health checkup',
            dateTime: DateTime(2026, 2, 12, 10, 30),
            type: 'Monthly',
          ),
          ReminderCard(
            title: 'Doctor Appointment',
            description: 'Health checkup',
            dateTime: DateTime(2026, 2, 12, 10, 30),
            type: 'Yearly',
          ),
          
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddReminder(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}






