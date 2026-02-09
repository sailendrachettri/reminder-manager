import '../../data/models/reminder.dart';

/// Sort reminders by:
/// 1️. Date (earlier first)
/// 2️. Time (earlier first)
void sortByDateThenTime(List<Reminder> list) {
  list.sort((a, b) {
    final da = _dateOnly(a.nextOccurrence);
    final db = _dateOnly(b.nextOccurrence);

    if (da != db) {
      return da.compareTo(db);
    }

    return a.nextOccurrence.compareTo(b.nextOccurrence);
  });
}

DateTime _dateOnly(DateTime dt) =>
    DateTime(dt.year, dt.month, dt.day);
