bool isToday(DateTime dt) {
  final now = DateTime.now();
  return dt.year == now.year &&
      dt.month == now.month &&
      dt.day == now.day;
}

bool isTomorrow(DateTime dt) {
  final tomorrow = DateTime.now().add(const Duration(days: 1));
  return dt.year == tomorrow.year &&
      dt.month == tomorrow.month &&
      dt.day == tomorrow.day;
}

bool isThisWeek(DateTime dt) {
  final now = DateTime.now();
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  final endOfWeek = startOfWeek.add(const Duration(days: 7));

  return dt.isAfter(startOfWeek) && dt.isBefore(endOfWeek);
}

bool isOverdue(DateTime dt) {
  return dt.isBefore(DateTime.now());
}

enum ReminderFilter {
  todayTomorrow,
  today,
  thisWeek,
  all,
  overdue,
}
