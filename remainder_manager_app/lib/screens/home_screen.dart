import 'package:flutter/material.dart';
import '../data/db/reminder_database.dart';
import '../data/models/reminder.dart';
import '../notifications/alarm_style/alarm_screen.dart';
import '../notifications/alarm_style/notification_alarm.dart';
import '../utils/filters/remainder_filters.dart';
import '../utils/filters/sort_by_date_time.dart';
import '../utils/greetings/greeting.dart';
import '../utils/empty-state/empty_state.dart';
import '../screens/remainder_form.dart';
import '../screens/summary_grid.dart';
import '../screens/remainder_card.dart';
import '../utils/headings/section_headings.dart';

/* ================= HOME SCREEN ================= */
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ReminderFilter selectedFilter = ReminderFilter.todayTomorrow;
  int _summaryRefresh = 0;
  bool _showGreeting = true;

  void _onGridTap(ReminderFilter filter) {
    setState(() => selectedFilter = filter);
  }

  Future<void> _demoAlarm() async {
    if (!mounted) return;

    final reminders = await ReminderDatabase.instance.getAll();
    final reminder = reminders.isNotEmpty ? reminders.first : null;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AlarmScreen(
          title: reminder?.title ?? "Demo Alarm",
          description: reminder?.description ?? "This is your demo alarm.",
          onDismiss: () {
            if (reminder != null) {
              _completeReminder(reminder);
            }
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() => _showGreeting = false);
      }
    });
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
    if (r.id != null) {
      await NotificationService.cancelReminderNotification(r.id!);
    }

    await ReminderDatabase.instance.delete(r.id!);
    setState(() {
      _summaryRefresh++;
    });
  }

  Future<void> _completeReminder(Reminder r) async {
    if (r.id != null) {
      await NotificationService.cancelReminderNotification(r.id!);
    }

    await ReminderDatabase.instance.delete(r.id!);
    setState(() {
      _summaryRefresh++;
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
          if (da != db) {
            return da.compareTo(db);
          }
          return a.nextOccurrence.compareTo(b.nextOccurrence);
        });
        return list;

      case ReminderFilter.today:
        final list = reminders.where((r) => isToday(r.nextOccurrence)).toList();
        sortByDateThenTime(list);
        return list;

      case ReminderFilter.thisWeek:
        final list = reminders
            .where((r) => isThisWeek(r.nextOccurrence))
            .toList();
        sortByDateThenTime(list);
        return list;

      case ReminderFilter.overdue:
        final list = reminders
            .where((r) => r.nextOccurrence.isBefore(DateTime.now()))
            .toList();
        sortByDateThenTime(list);
        return list;

      case ReminderFilter.all:
        final list = List<Reminder>.from(reminders);
        sortByDateThenTime(list);
        return list;
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
        _summaryRefresh++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: SizedBox(
          width: 160,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 700),
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: Text(
              _showGreeting ? getGreeting() : 'RemindMe',
              key: ValueKey(_showGreeting),
            ),
          ),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.alarm),
        //     onPressed: _demoAlarm,
        //     tooltip: 'Demo Alarm',
        //   ),
        // ],
      ),
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
