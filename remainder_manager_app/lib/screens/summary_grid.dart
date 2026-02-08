import 'package:flutter/material.dart';
import 'package:remainder_manager_app/theme/app_colors.dart';

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
          icon: Icons.history_outlined,
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
                  color: isAlert
                      ? Colors.red
                      : const Color.fromARGB(189, 61, 145, 247),
                ),
                const Spacer(),
                Text(
                  count.toString(),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            Text(
              title,
              style: TextStyle(color: const Color.fromARGB(255, 69, 71, 73)),
            ),
          ],
        ),
      ),
    );
  }
}
