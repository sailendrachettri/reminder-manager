import 'package:intl/intl.dart';


/*
To use: selectedDate!.prettyDate

 */
extension PrettyDate on DateTime {
  /// 12 Feb 2026
  String get prettyDate {
    return DateFormat('dd MMM yyyy').format(this);
  }

  /// Today / Tomorrow / 12 Feb 2026
  String get smartDate {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));

    bool sameDay(DateTime a, DateTime b) =>
        a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;

    if (sameDay(this, today)) return 'Today';
    if (sameDay(this, tomorrow)) return 'Tomorrow';

    return prettyDate;
  }
}
