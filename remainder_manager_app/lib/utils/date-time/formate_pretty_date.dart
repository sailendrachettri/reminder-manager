import 'package:intl/intl.dart';

/*
Usage:
date.prettyDate
date.smartDate
*/

extension PrettyDate on DateTime {
  /// Mon, 19 Feb  OR  19 Feb 2027
  String get prettyDate {
    final now = DateTime.now();
    final isSameYear = year == now.year;

    return DateFormat(
      isSameYear ? 'EEE, dd MMM' : 'dd MMM yyyy',
    ).format(this);
  }

  /// Today / Tomorrow / Mon, 19 Feb / 19 Feb 2027
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
