import 'package:flutter/material.dart';

class AddReminderScreen extends StatefulWidget {
  const AddReminderScreen({super.key});

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final List<String> reminderTypes = [
    'One Time',
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly',
  ];

  int selectedTypeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Reminder')),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // _buildSectionTitle('Reminder Details'),
                    _buildDetailsCard(),

                    const SizedBox(height: 24),

                    // _buildSectionTitle('Repeat Type'),
                    _buildRepeatTypeSelector(),

                    const SizedBox(height: 24),

                    _buildSectionTitle('Schedule'),
                    _buildScheduleCard(),
                  ],
                ),
              ),
            ),

            _buildSaveButton(context),
          ],
        ),
      ),
    );
  }

  /* ================= SECTIONS ================= */

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }

  Widget _buildDetailsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            
            // TITLE LABEL
            TextField(
              style: TextStyle(fontSize: 25),
              decoration: InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintStyle: TextStyle(color: Color.fromARGB(255, 138, 135, 135), fontSize: 14, fontStyle: FontStyle.italic),
                
              ),
            ),

            SizedBox(height: 10),

            // DESCRIPTION LABEL
            TextField(
              maxLines: 2,
              style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 148, 145, 145), fontStyle: FontStyle.italic),
              decoration: InputDecoration(
                hintText: 'Notes',
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintStyle: TextStyle(color: Color.fromARGB(255, 138, 135, 135), fontSize: 14, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: const [
            Expanded(
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date',
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Time',
                  suffixIcon: Icon(Icons.access_time),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRepeatTypeSelector() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: reminderTypes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final bool isSelected = selectedTypeIndex == index;

          return ChoiceChip(
            label: Text(reminderTypes[index]),
            selected: isSelected,
            onSelected: (_) {
              setState(() {
                selectedTypeIndex = index;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Save Reminder'),
        ),
      ),
    );
  }
}
