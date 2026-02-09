class Reminder {
  final int? id;
  final String title;
  final String description;
  final String type;

  final String time;        // HH:mm
  final String? date;       // yyyy-MM-dd
  final int? weekday;       // 1-7
  final int? dayOfMonth;    // 1-31
  final int? month;         // 1-12

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

  /// 🔥 THIS IS THE KEY PART
  DateTime get effectiveDateTime {
    // If exact date exists (most common)
    if (date != null) {
      return DateTime.parse('$date $time');
    }

    final now = DateTime.now();
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    // Weekly reminder
    if (weekday != null) {
      final diff = (weekday! - now.weekday + 7) % 7;
      final target = now.add(Duration(days: diff));
      return DateTime(
        target.year,
        target.month,
        target.day,
        hour,
        minute,
      );
    }

    // Monthly reminder
    if (dayOfMonth != null) {
      return DateTime(
        now.year,
        now.month,
        dayOfMonth!,
        hour,
        minute,
      );
    }

    // Yearly reminder
    if (month != null && dayOfMonth != null) {
      return DateTime(
        now.year,
        month!,
        dayOfMonth!,
        hour,
        minute,
      );
    }

    // Fallback
    return now;
  }

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

      DateTime get nextOccurrence {
  if (date != null) {
    return DateTime.parse('$date $time');
  }

  final now = DateTime.now();
  final parts = time.split(':');
  final hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);

  if (weekday != null) {
    final diff = (weekday! - now.weekday + 7) % 7;
    final target = now.add(Duration(days: diff));
    return DateTime(
      target.year,
      target.month,
      target.day,
      hour,
      minute,
    );
  }

  if (dayOfMonth != null) {
    return DateTime(
      now.year,
      now.month,
      dayOfMonth!,
      hour,
      minute,
    );
  }

  if (month != null && dayOfMonth != null) {
    return DateTime(
      now.year,
      month!,
      dayOfMonth!,
      hour,
      minute,
    );
  }

  return now;
}

}


