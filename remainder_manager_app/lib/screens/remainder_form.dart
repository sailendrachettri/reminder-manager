import 'package:flutter/material.dart';
import '../data/models/reminder.dart';
import '../data/db/reminder_database.dart';
import '../utils/date-time/formate_pretty_date.dart';
import '../utils/date-time/formate_pretty_time.dart';
import '../notifications/alarm_style/notification_alarm.dart';

class AddReminderSheet extends StatefulWidget {
  const AddReminderSheet({super.key});

  @override
  State<AddReminderSheet> createState() => _AddReminderSheetState();
}

class _AddReminderSheetState extends State<AddReminderSheet> {
  final reminderTypes = ['Once', 'Daily', 'Weekly', 'Monthly', 'Yearly'];

  int selectedTypeIndex = 0;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int? selectedWeekday; // 1-7
  int? selectedDayOfMonth;
  int? selectedMonth;

  bool get isOnce => selectedTypeIndex == 0;
  bool get isDaily => selectedTypeIndex == 1;
  bool get isWeekly => selectedTypeIndex == 2;
  bool get isMonthly => selectedTypeIndex == 3;
  bool get isYearly => selectedTypeIndex == 4;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveReminder() async {
  final time = selectedTime!;
  final timeStr =
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  final reminder = Reminder(
    title: titleController.text.trim(),
    description: descriptionController.text.trim(),
    type: reminderTypes[selectedTypeIndex],
    time: timeStr,
    date: isOnce ? selectedDate!.toIso8601String().split('T').first : null,
    weekday: isWeekly ? selectedWeekday : null,
    dayOfMonth: (isMonthly || isYearly) ? selectedDayOfMonth : null,  // ✅ FIXED
    month: isYearly ? selectedMonth : null,
  );

  // Save to database
  final id = await ReminderDatabase.instance.insert(reminder);

  // Create reminder with ID for scheduling
  final reminderWithId = Reminder(
    id: id,
    title: reminder.title,
    description: reminder.description,
    type: reminder.type,
    time: reminder.time,
    date: reminder.date,
    weekday: reminder.weekday,
    dayOfMonth: reminder.dayOfMonth,
    month: reminder.month,
  );

  // Schedule notification with UNIQUE ID
  try {
    await NotificationService.scheduleReminderNotification(reminderWithId);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reminder set for ${reminderWithId.nextOccurrence}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reminder saved but notification failed: $e'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  if (mounted) {
    Navigator.pop(context, true);
  }
}

  bool get canSave {
    if (titleController.text.trim().isEmpty) return false;
    if (selectedTime == null) return false;

    if (isOnce) {
      return selectedDate != null;
    }

    if (isWeekly) {
      return selectedWeekday != null;
    }

    if (isMonthly) {
      return selectedDayOfMonth != null;
    }

    if (isYearly) {
      return selectedMonth != null && selectedDayOfMonth != null;
    }

    // Daily
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          _buildHandle(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildTextSection(),
                const SizedBox(height: 20),
                _buildRepeatTypeSelector(),
                const SizedBox(height: 20),
                _buildDynamicInputs(context),
                const SizedBox(height: 30),
                SizedBox(
                  height: 46,
                  child: ElevatedButton(
                    onPressed: canSave ? _saveReminder : null,
                    child: const Text('Save Reminder'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildTextSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              hintText: 'Reminder title',
              border: InputBorder.none,
            ),
          ),
          const Divider(),
          TextField(
            controller: descriptionController,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: 'Add notes',
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicInputs(BuildContext context) {
    return Column(
      children: [
        // TIME (always required)
        _DateTimePill(
          icon: Icons.access_time,
          label: selectedTime?.prettyTime ?? 'Time',
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (picked != null) setState(() => selectedTime = picked);
          },
        ),

        if (isOnce) ...[
          const SizedBox(height: 10),
          _DateTimePill(
            icon: Icons.calendar_today,
            label: selectedDate?.prettyDate ?? 'Date',
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) setState(() => selectedDate = picked);
            },
          ),
        ],

        if (isWeekly) ...[
          const SizedBox(height: 10),
          _InputCard(
            child: DropdownButtonFormField<int>(
              value: selectedWeekday,
              isDense: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Select weekday',
              ),
              icon: const Icon(Icons.keyboard_arrow_down),
              items: List.generate(7, (i) {
                return DropdownMenuItem(
                  value: i + 1,
                  child: Text(
                    ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][i],
                  ),
                );
              }),
              onChanged: (v) => setState(() => selectedWeekday = v),
            ),
          ),
        ],

        if (isMonthly) ...[
          const SizedBox(height: 10),
          _InputCard(
            child: DropdownButtonFormField<int>(
              value: selectedDayOfMonth,
              isDense: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Day of month',
              ),
              items: List.generate(31, (i) {
                return DropdownMenuItem(value: i + 1, child: Text('${i + 1}'));
              }),
              onChanged: (v) => setState(() => selectedDayOfMonth = v),
            ),
          ),
        ],

        if (isYearly) ...[
          const SizedBox(height: 10),

          // MONTH
          _InputCard(
            child: DropdownButtonFormField<int>(
              value: selectedMonth,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Month',
              ),
              items: List.generate(12, (i) {
                return DropdownMenuItem(
                  value: i + 1,
                  child: Text(
                    [
                      'Jan',
                      'Feb',
                      'Mar',
                      'Apr',
                      'May',
                      'Jun',
                      'Jul',
                      'Aug',
                      'Sep',
                      'Oct',
                      'Nov',
                      'Dec',
                    ][i],
                  ),
                );
              }),
              onChanged: (v) => setState(() => selectedMonth = v),
            ),
          ),

          const SizedBox(height: 10),

          // DAY OF MONTH
          _InputCard(
            child: DropdownButtonFormField<int>(
              value: selectedDayOfMonth,
              isDense: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Day of month',
              ),
              items: List.generate(31, (i) {
                return DropdownMenuItem(value: i + 1, child: Text('${i + 1}'));
              }),
              onChanged: (v) => setState(() => selectedDayOfMonth = v),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRepeatTypeSelector() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: reminderTypes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return ChoiceChip(
            label: Text(reminderTypes[index]),
            selected: selectedTypeIndex == index,
            onSelected: (_) {
              FocusScope.of(context).unfocus();
              setState(() {
                selectedTypeIndex = index;

                // IMPORTANT reset
                selectedDate = null;
                selectedWeekday = null;
                selectedDayOfMonth = null;
                selectedMonth = null;
              });
            },
          );
        },
      ),
    );
  }
}

class _DateTimePill extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DateTimePill({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class _InputCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  const _InputCard({
    required this.child,
    this.margin = const EdgeInsets.symmetric(vertical: 6),
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
