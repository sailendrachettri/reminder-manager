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
  final VoidCallback onDelete;
  final VoidCallback onComplete;

  const ReminderCard({
    super.key,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.type,
    required this.onDelete,
    required this.onComplete,
  });

  Future<void> _confirmAction({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (result == true) {
      onConfirm();
    }
  }

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

        leading: Icon(
          smartDate == 'Today'
              ? Icons.notifications_on_outlined
              : Icons.notifications_outlined,
          color: AppColors.primary,
        ),

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

        children: [
          if (description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                description,
                style: const TextStyle(
                  color: Color.fromARGB(255, 100, 108, 117),
                ),
              ),
            ),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  label: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    _confirmAction(
                      context: context,
                      title: 'Delete Reminder?',
                      message:
                          'This reminder will be permanently deleted. Are you sure?',
                      onConfirm: onDelete,
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              
              // ✅ FIXED: Only show "Completed" button for 'Once' type reminders
              if (type == 'Once')
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Completed'),
                    onPressed: () {
                      _confirmAction(
                        context: context,
                        title: 'Mark as Completed?',
                        message:
                            'This reminder will be removed after marking as completed.',
                        onConfirm: onComplete,
                      );
                    },
                  ),
                )
              else
                // ✅ NEW: Show info button for recurring reminders
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.info_outline),
                    label: Text(
                      type == 'Daily' ? 'Repeats Daily' :
                      type == 'Weekly' ? 'Repeats Weekly' :
                      type == 'Monthly' ? 'Repeats Monthly' :
                      type == 'Yearly' ? 'Repeats Yearly' : 'Repeats',
                      style: const TextStyle(fontSize: 13),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'This is a $type reminder. It will repeat automatically. Delete it to stop all future occurrences.',
                          ),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    },
                  ),
                ),
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
          fontSize: 8,
          fontStyle: FontStyle.italic,
          color: const Color.fromARGB(255, 61, 84, 103),
        ),
      ),
    );
  }
}