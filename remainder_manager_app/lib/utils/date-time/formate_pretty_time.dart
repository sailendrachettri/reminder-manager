import 'package:intl/intl.dart';
import 'package:flutter/material.dart';



/*
To use: selectedDate!.prettyTime

 */

extension PrettyTime on DateTime {
  /// 10:30 AM
  String get prettyTime {
    return DateFormat('hh:mm a').format(this);
  }
}

extension PrettyTimeOfDay on TimeOfDay {
  /// 10:30 AM
  String get prettyTime {
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    return DateFormat('hh:mm a').format(dateTime);
  }
}
