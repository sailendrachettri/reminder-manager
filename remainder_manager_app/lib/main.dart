import 'package:flutter/material.dart';
import './screens/remainder_form.dart';

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

          SizedBox(height: 24),

          SectionTitle(title: 'This Month'),

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

/* ================= REMINDER CARD ================= */

class ReminderCard extends StatelessWidget {
  final String title;
  final String time;
  final String subtitle;

  const ReminderCard({
    super.key,
    required this.title,
    required this.time,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.notifications_active),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(
          time,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

/* ================= SECTION TITLE ================= */

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

/* ================= ADD REMINDER SCREEN ================= */

class SummaryGrid extends StatelessWidget {
  const SummaryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: const [
        SummaryCard(icon: Icons.today, title: 'Today', count: 2),
        SummaryCard(
          icon: Icons.calendar_view_week,
          title: 'This Week',
          count: 5,
        ),
        SummaryCard(icon: Icons.list_alt, title: 'All', count: 12),
        SummaryCard(
          icon: Icons.warning_amber_rounded,
          title: 'Overdue',
          count: 1,
          isAlert: true,
        ),
      ],
    );
  }
}

class SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final int count;
  final bool isAlert;

  const SummaryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.count,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 28,
                  color: isAlert ? Colors.red : colorScheme.primary,
                ),
                const Spacer(),
                Text(
              count.toString(),
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
              ],
            ),

            const SizedBox(height: 4),
            
                Text(title, style: Theme.of(context).textTheme.labelLarge),
            
          ],
        ),
      ),
    );
  }
}
