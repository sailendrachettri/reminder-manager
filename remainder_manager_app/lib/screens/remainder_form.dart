import 'package:flutter/material.dart';
import '../utils/date-time/formate_pretty_date.dart';
import '../utils/date-time/formate_pretty_time.dart';

class AddReminderSheet extends StatefulWidget {
  const AddReminderSheet({super.key});

  @override
  State<AddReminderSheet> createState() => _AddReminderSheetState();
}



class _AddReminderSheetState extends State<AddReminderSheet> {
  final List<String> reminderTypes = [
    'Once',
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly',
  ];

  int selectedTypeIndex = 0;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Container(
      height: height * 0.8, // 🔥 80% height
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          _buildHandle(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: [
                  _buildTextSection(),
                  const SizedBox(height: 20),
                  _buildDateTimeRow(context),
                  const SizedBox(height: 20),
                  _buildRepeatTypeSelector(),
                  const SizedBox(height: 30),

                  _buildSaveButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /* ================= HANDLE ================= */

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

  /* ================= TEXT ================= */

  Widget _buildTextSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          TextField(
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              hintText: 'Reminder title',
              border: InputBorder.none,
              isDense: true,
              hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          Divider(height: 16),
          TextField(
            maxLines: null,
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Add notes',
              border: InputBorder.none,
              isDense: true,
              hintStyle: TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /* ================= DATE + TIME ================= */

  Widget _buildDateTimeRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _DateTimePill(
            icon: Icons.calendar_today,
            label: selectedDate == null ? 'Date' : selectedDate!.prettyDate,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setState(() => selectedDate = picked);
              }
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _DateTimePill(
            icon: Icons.access_time,
            label: selectedTime == null
                ? 'Time'
                : selectedTime!.prettyTime,
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: selectedTime ?? TimeOfDay.now(),
              );
              if (picked != null) {
                setState(() => selectedTime = picked);
              }
            },
          ),
        ),
      ],
    );
  }

  /* ================= REPEAT ================= */

  Widget _buildRepeatTypeSelector() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: reminderTypes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = selectedTypeIndex == index;

          return ChoiceChip(
            showCheckmark: true,
            checkmarkColor: Colors.white,
            label: Text(
              reminderTypes[index],
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            selected: isSelected,

            selectedColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Colors.grey.shade200,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onSelected: (_) {
              setState(() => selectedTypeIndex = index);
            },
          );
        },
      ),
    );
  }

  /* ================= SAVE ================= */

  Widget _buildSaveButton() {
    final canSave = selectedDate != null && selectedTime != null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: SizedBox(
        width: double.infinity,
        height: 46,
        child: ElevatedButton(
          onPressed: canSave ? () => Navigator.pop(context) : null,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text('Save Reminder'),
        ),
      ),
    );
  }
}

/* ================= DATE/TIME PILL ================= */

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
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey.shade700),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
