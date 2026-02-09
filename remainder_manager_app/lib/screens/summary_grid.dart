import 'package:flutter/material.dart';
import '../utils/filters/remainder_filters.dart';

class SummaryGrid extends StatelessWidget {
  final Function(ReminderFilter) onSelect;

  const SummaryGrid({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        SummaryCard(
          icon: Icons.today,
          title: 'Today',
          count: 0,
          onTap: () => onSelect(ReminderFilter.today),
        ),
        SummaryCard(
          icon: Icons.calendar_view_week,
          title: 'This Week',
          count: 0,
          onTap: () => onSelect(ReminderFilter.thisWeek),
        ),
        SummaryCard(
          icon: Icons.list_alt,
          title: 'All',
          count: 0,
          onTap: () => onSelect(ReminderFilter.all),
        ),
        SummaryCard(
          icon: Icons.history_outlined,
          title: 'Overdue',
          count: 0,
          isAlert: true,
          onTap: () => onSelect(ReminderFilter.overdue),
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
  final VoidCallback onTap;

  const SummaryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.count,
    required this.onTap,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon,
                      size: 28,
                      color: isAlert ? Colors.red : Colors.blue),
                  const Spacer(),
                  Text(
                    count.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}
