import 'package:flutter/material.dart';
import './screens/remainder_form.dart';
import './screens/summary_grid.dart';
import './screens/remainder_card.dart';
import './utils/headings/section_headings.dart';
import './theme/app_theme.dart';
import './utils/empty-state/empty_state.dart';
import './utils/filters/remainder_filters.dart';
import './data/db/reminder_database.dart';
import './data/models/reminder.dart';

void main() {
  runApp(const ReminderApp());
}

/* ================= APP ================= */

class ReminderApp extends StatelessWidget {
  const ReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RemindMe',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}

/* ================= HOME SCREEN ================= */

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ReminderFilter selectedFilter = ReminderFilter.todayTomorrow;
  int _summaryRefresh = 0;

  void _onGridTap(ReminderFilter filter) {
    setState(() => selectedFilter = filter);
  }

  String get sectionTitle {
    switch (selectedFilter) {
      case ReminderFilter.todayTomorrow:
        return 'Upcoming';
      case ReminderFilter.today:
        return 'Today';
      case ReminderFilter.thisWeek:
        return 'This Week';
      case ReminderFilter.overdue:
        return 'Overdue';
      case ReminderFilter.all:
        return 'All Reminders';
    }
  }

  Future<void> _deleteReminder(Reminder r) async {
    await ReminderDatabase.instance.delete(r.id!);
    setState(() {
      _summaryRefresh++; // 🔥 forces SummaryGrid rebuild
    });
  }

  Future<void> _completeReminder(Reminder r) async {
    // for now, completed = delete
    await ReminderDatabase.instance.delete(r.id!);
    setState(() {
      _summaryRefresh++; // 🔥 forces SummaryGrid rebuild
    });
  }

  List<Reminder> _applyFilter(List<Reminder> reminders) {
    switch (selectedFilter) {
      case ReminderFilter.todayTomorrow:
        final list = reminders.where((r) {
          final d = r.nextOccurrence;
          return isToday(d) || isTomorrow(d);
        }).toList();

        list.sort((a, b) {
          final da = dateOnly(a.nextOccurrence);
          final db = dateOnly(b.nextOccurrence);

          // 1️⃣ date first (today before tomorrow)
          if (da != db) {
            return da.compareTo(db);
          }

          // 2️⃣ same date → time
          return a.nextOccurrence.compareTo(b.nextOccurrence);
        });

        return list;

      case ReminderFilter.today:
        return reminders.where((r) => isToday(r.nextOccurrence)).toList();

      case ReminderFilter.thisWeek:
        return reminders.where((r) => isThisWeek(r.nextOccurrence)).toList();

      case ReminderFilter.overdue:
        return reminders
            .where((r) => r.nextOccurrence.isBefore(DateTime.now()))
            .toList();

      case ReminderFilter.all:
        return reminders;
    }
  }

  Future<void> _openAddReminder() async {
    final added = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddReminderSheet(),
    );

    if (added == true) {
      setState(() {
        _summaryRefresh++; // 🔥 refresh counts + list
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RemindMe')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SummaryGrid(key: ValueKey(_summaryRefresh), onSelect: _onGridTap),

          const SizedBox(height: 12),

          SectionHeading(title: sectionTitle),

          FutureBuilder<List<Reminder>>(
            future: ReminderDatabase.instance.getAll(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              }

              // if (!snapshot.hasData) {
              //   debugPrint('⏳ Waiting for data...');
              //   return const SizedBox();
              // }

              // debugPrint('📦 Total reminders: ${snapshot.data!.length}');

              final filtered = _applyFilter(snapshot.data!);

              if (filtered.isEmpty) {
                return const EmptyState(
                  svgPath: 'assets/svgs/global_search.svg',
                  title: 'No reminders yet',
                  subtitle: 'Add one to stay on track',
                );
              }

              return Column(
                children: filtered.map((r) {
                  return ReminderCard(
                    title: r.title,
                    description: r.description,
                    dateTime: r.nextOccurrence,
                    type: r.type,
                    onDelete: () => _deleteReminder(r),
                    onComplete: () => _completeReminder(r),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddReminder,
        child: const Icon(Icons.add),
      ),
    );
  }
}
