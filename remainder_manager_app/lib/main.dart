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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RemindMe'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SectionTitle(title: 'Today'),
          ReminderCard(
            title: 'Walk the dog',
            time: '4:00 PM',
            subtitle: 'Daily',
          ),

          SizedBox(height: 16),

          SectionTitle(title: 'Upcoming'),
          ReminderCard(
            title: 'Feed the cat',
            time: '8:00 AM',
            subtitle: 'Daily',
          ),
          ReminderCard(
            title: 'Friend Birthday',
            time: '12 Jan 2027',
            subtitle: 'Yearly',
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddReminderScreen(),
            ),
          );
        },
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
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}

/* ================= ADD REMINDER SCREEN ================= */
