import 'package:flutter/material.dart';
import '../utils/filters/remainder_filters.dart';
import '../data/db/reminder_database.dart';

class SummaryGrid extends StatefulWidget {
  final Function(ReminderFilter) onSelect;

  const SummaryGrid({super.key, required this.onSelect});

  @override
  State<SummaryGrid> createState() => _SummaryGridState();
}

class _SummaryGridState extends State<SummaryGrid> {
  int today = 0;
  int week = 0;
  int all = 0;
  int overdue = 0;

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    final db = ReminderDatabase.instance;

    final results = await Future.wait([
      db.countToday(),
      db.countThisWeek(),
      db.countAll(),
      db.countOverdue(),
    ]);

    setState(() {
      today = results[0];
      week = results[1];
      all = results[2];
      overdue = results[3];
    });
  }

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
          count: today,
          onTap: () => widget.onSelect(ReminderFilter.today),
        ),
        SummaryCard(
          icon: Icons.calendar_view_week,
          title: 'This Week',
          count: week,
          onTap: () => widget.onSelect(ReminderFilter.thisWeek),
        ),
        SummaryCard(
          icon: Icons.list_alt,
          title: 'All',
          count: all,
          onTap: () => widget.onSelect(ReminderFilter.all),
        ),
        SummaryCard(
          icon: Icons.history_outlined,
          title: 'Overdue',
          count: overdue,
          isAlert: true,
          onTap: () => widget.onSelect(ReminderFilter.overdue),
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
    final color = isAlert
        ? Colors.red
        : Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.15),
              color.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ICON + COUNT ROW
            Row(
              children: [
                Icon(icon, color: color, size: 26),
                const Spacer(),
                Text(
                  count.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // LABEL
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

