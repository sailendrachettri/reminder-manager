import 'package:flutter/material.dart';
import '../utils/date-time/formate_pretty_date.dart';
import '../utils/date-time/formate_pretty_time.dart';
import '../theme/app_spacing.dart';
import '../theme/app_colors.dart';

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
    final String subtitleText = smartDate == 'Today'
        ? 'Today at $prettyTime'
        : smartDate == 'Tomorrow'
        ? 'Tomorrow at $prettyTime'
        : '$prettyDate • $prettyTime';

    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),

        leading: const Icon(Icons.notifications_outlined, color: AppColors.primary,),
        shape: const RoundedRectangleBorder(),
        collapsedShape: const RoundedRectangleBorder(),

        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppColors.primary,
          ),
        ),

        /// Collapsed view
        subtitle: Row(
          children: [
            Text(
              subtitleText,
              style: TextStyle(
                fontSize: 11,
                fontStyle: FontStyle.italic,
                color: const Color.fromARGB(255, 61, 84, 103),
              ),
            ),
            AppSpacing.w12,
            _TypeChip(type: type),
          ],
        ),

        /// Expanded view
        children: [
          if (description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(description, style: TextStyle(
                color: const Color.fromARGB(255, 100, 108, 117)
              )),
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
          fontWeight: FontWeight.w500,
          fontSize: 8,
        ),
      ),
    );
  }
}
