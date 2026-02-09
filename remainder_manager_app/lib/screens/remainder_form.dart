import 'package:flutter/material.dart';
import '../data/models/reminder.dart';
import '../data/db/reminder_database.dart';
import '../utils/date-time/formate_pretty_date.dart';
import '../utils/date-time/formate_pretty_time.dart';

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

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveReminder() async {
    final date = selectedDate!;
    final time = selectedTime!;

    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    final reminder = Reminder(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      dateTime: dateTime,
      type: reminderTypes[selectedTypeIndex],
    );

    await ReminderDatabase.instance.insert(reminder);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final canSave = selectedDate != null &&
        selectedTime != null &&
        titleController.text.isNotEmpty;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
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
                _buildDateTimeRow(context),
                const SizedBox(height: 20),
                _buildRepeatTypeSelector(),
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

  Widget _buildDateTimeRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _DateTimePill(
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
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _DateTimePill(
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
        ),
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
            onSelected: (_) => setState(() => selectedTypeIndex = index),
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
