class Reminder {
  final int? id;
  final String title;
  final String description;
  final String type;

  final String time; // HH:mm
  final String? date; // yyyy-MM-dd
  final int? weekday; // 1-7
  final int? dayOfMonth; // 1-31
  final int? month; // 1-12

  Reminder({
    this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.time,
    this.date,
    this.weekday,
    this.dayOfMonth,
    this.month,
  });

  /// Calculate the next occurrence of this reminder
  DateTime get nextOccurrence {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final now = DateTime.now();

    switch (type) {
      case 'Once':
        // For one-time reminders, use the exact date
        if (date != null) {
          final dateOnly = DateTime.parse(date!);
          return DateTime(
            dateOnly.year,
            dateOnly.month,
            dateOnly.day,
            hour,
            minute,
          );
        }
        return now;

      case 'Daily':
        // Next daily occurrence
        var next = DateTime(now.year, now.month, now.day, hour, minute);

        // If the time has already passed today, schedule for tomorrow
        if (next.isBefore(now) || next.isAtSameMomentAs(now)) {
          next = next.add(const Duration(days: 1));
        }

        return next;

      case 'Weekly':
        // Next weekly occurrence on the specified weekday
        if (weekday == null) return now;

        var next = DateTime(now.year, now.month, now.day, hour, minute);

        // Calculate days until target weekday
        int daysUntilTarget = (weekday! - now.weekday) % 7;

        // If it's today but time has passed, schedule for next week
        if (daysUntilTarget == 0) {
          if (next.isBefore(now) || next.isAtSameMomentAs(now)) {
            daysUntilTarget = 7;
          }
        }

        return next.add(Duration(days: daysUntilTarget));

      case 'Monthly':
        // Next monthly occurrence on the specified day
        if (dayOfMonth == null) return now;

        var next = DateTime(now.year, now.month, dayOfMonth!, hour, minute);

        // If this month's date has passed, move to next month
        if (next.isBefore(now) || next.isAtSameMomentAs(now)) {
          // Move to next month
          if (now.month == 12) {
            next = DateTime(now.year + 1, 1, dayOfMonth!, hour, minute);
          } else {
            next = DateTime(now.year, now.month + 1, dayOfMonth!, hour, minute);
          }
        }

        return next;

      case 'Yearly':
        // Next yearly occurrence on the specified month and day
        if (month == null || dayOfMonth == null) return now;

        var next = DateTime(now.year, month!, dayOfMonth!, hour, minute);

        // If this year's date has passed, move to next year
        if (next.isBefore(now) || next.isAtSameMomentAs(now)) {
          next = DateTime(now.year + 1, month!, dayOfMonth!, hour, minute);
        }

        return next;

      default:
        return now;
    }
  }

  /// Legacy getter for backward compatibility
  DateTime get effectiveDateTime => nextOccurrence;

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'type': type,
    'time': time,
    'date': date,
    'weekday': weekday,
    'dayOfMonth': dayOfMonth,
    'month': month,
  };

  factory Reminder.fromMap(Map<String, dynamic> map) => Reminder(
    id: map['id'],
    title: map['title'],
    description: map['description'],
    type: map['type'],
    time: map['time'],
    date: map['date'],
    weekday: map['weekday'],
    dayOfMonth: map['dayOfMonth'],
    month: map['month'],
  );
}
