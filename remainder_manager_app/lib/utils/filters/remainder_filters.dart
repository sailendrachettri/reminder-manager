bool isToday(DateTime dt) {
  final today = dateOnly(DateTime.now());
  return dateOnly(dt) == today;
}

bool isTomorrow(DateTime dt) {
  final tomorrow = dateOnly(DateTime.now().add(const Duration(days: 1)));
  return dateOnly(dt) == tomorrow;
}

bool isThisWeek(DateTime dt) {
  final now = dateOnly(DateTime.now());
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  final endOfWeek = startOfWeek.add(const Duration(days: 6));

  final d = dateOnly(dt);
  return !d.isBefore(startOfWeek) && !d.isAfter(endOfWeek);
}

bool isOverdue(DateTime dt) {
  final today = dateOnly(DateTime.now());
  return dateOnly(dt).isBefore(today);
}


enum ReminderFilter {
  todayTomorrow,
  today,
  thisWeek,
  all,
  overdue,
}

DateTime dateOnly(DateTime dt) =>
    DateTime(dt.year, dt.month, dt.day);

