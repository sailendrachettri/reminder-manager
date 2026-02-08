import 'package:flutter/material.dart';
import '../utils/date-time/formate_pretty_date.dart';
import '../utils/date-time/formate_pretty_time.dart';

class ReminderCard extends StatelessWidget {
  final String title;
  final String description;
  final DateTime dateTime;
  final String type;

  const ReminderCard({
    super.key,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final smartDate = dateTime.smartDate;
    final prettyDate = dateTime.prettyDate;
    final prettyTime = dateTime.prettyTime;

    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        tilePadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        childrenPadding:
            const EdgeInsets.fromLTRB(16, 0, 16, 12),

        leading: const Icon(Icons.notifications_outlined),

        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),

        /// Collapsed view
        subtitle: Text(
          smartDate == 'Today' ? prettyTime : smartDate,
          style: theme.textTheme.labelMedium,
        ),

        /// Expanded view
        children: [
          if (description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                description,
                style: theme.textTheme.bodyMedium,
              ),
            ),

          Row(
            children: [
              Text(
                '$prettyDate • $prettyTime',
                style: theme.textTheme.labelMedium,
              ),
              const Spacer(),
              _TypeChip(type: type),
            ],
          ),
        ],
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String type;

  const _TypeChip({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        type,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
