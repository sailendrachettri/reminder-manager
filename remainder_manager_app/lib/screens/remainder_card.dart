import 'package:flutter/material.dart';

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