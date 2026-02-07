import 'package:flutter/material.dart';
import './screens/remainder_form.dart';
import './screens/summary_grid.dart';
import './screens/remainder_card.dart';
import './utils/section_headings.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
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
        children: const [
          SummaryGrid(),

          SectionHeading(title: 'This Month'),

          ReminderCard(
            title: 'Pay Electricity Bill',
            time: '5 Feb',
            subtitle: 'One-time',
          ),
          ReminderCard(
            title: 'Doctor Appointment',
            time: '12 Feb',
            subtitle: 'One-time',
          ),
          ReminderCard(
            title: 'Friend Birthday',
            time: '25 Feb',
            subtitle: 'Yearly',
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






