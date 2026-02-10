import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import '../../data/models/reminder.dart';
import 'dart:io';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // Store reminder data for notification tap handling
  static final Map<int, Map<String, String>> _reminderData = {};

  // Callback to navigate to alarm screen
  static Function(int reminderId, String title, String description)?
  onAlarmTrigger;

  static Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _handleNotificationTap,
      onDidReceiveBackgroundNotificationResponse: _handleNotificationTap,
    );

    // Request exact alarm permission on Android 12+
    if (Platform.isAndroid) {
      await _requestExactAlarmPermission();
    }
  }

  @pragma('vm:entry-point')
  static void _handleNotificationTap(NotificationResponse response) {
    print('🔔 Notification tapped/triggered: ${response.payload}');

    if (response.payload != null) {
      try {
        final parts = response.payload!.split('|||');

        if (parts.length >= 3) {
          final reminderId = int.parse(parts[0]);
          final title = parts[1];
          final description = parts[2];

          print('📱 Triggering alarm screen for ID: $reminderId');

          if (onAlarmTrigger != null) {
            onAlarmTrigger!(reminderId, title, description);
          }
        }
      } catch (e) {
        print('❌ Error handling notification: $e');
      }
    }
  }

  /// Request SCHEDULE_EXACT_ALARM permission (Android 12+)
  static Future<bool> _requestExactAlarmPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.scheduleExactAlarm.status;

      if (status.isDenied) {
        final result = await Permission.scheduleExactAlarm.request();
        return result.isGranted;
      }

      return status.isGranted;
    }
    return true;
  }

  /// Check if exact alarm permission is granted
  static Future<bool> hasExactAlarmPermission() async {
    if (Platform.isAndroid) {
      return await Permission.scheduleExactAlarm.isGranted;
    }
    return true;
  }

  /// Schedule a notification for a reminder
  static Future<void> scheduleReminderNotification(Reminder reminder) async {
    if (reminder.id == null) {
      throw Exception('Reminder must have an ID to schedule notification');
    }

    // Check exact alarm permission
    final hasPermission = await hasExactAlarmPermission();
    if (!hasPermission) {
      throw Exception(
        'Exact alarm permission not granted. Please enable it in Settings.',
      );
    }

    final DateTime scheduledDateTime = reminder.nextOccurrence;

    // Don't schedule if the time has already passed
    if (scheduledDateTime.isBefore(DateTime.now())) {
      print(
        '⚠️ Skipping notification - time has already passed: $scheduledDateTime',
      );
      return;
    }

    // Store reminder data for later retrieval
    _reminderData[reminder.id!] = {
      'title': reminder.title,
      'description': reminder.description,
    };

    // Create payload with title and description
    final payload =
        '${reminder.id}|||${reminder.title}|||${reminder.description}';

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'reminder_channel',
          'Reminders',
          channelDescription: 'Reminder notifications',
          importance: Importance.max,
          priority: Priority.high,
          fullScreenIntent: true,
          playSound: true,
          enableVibration: true,
          ticker: 'Reminder',
          category: AndroidNotificationCategory.alarm,
          // High visibility for lock screen
          visibility: NotificationVisibility.public,
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
      scheduledDateTime,
      tz.local,
    );

    print('📅 Scheduling notification for: $scheduledDate');
    print('   Title: ${reminder.title}');
    print('   Type: ${reminder.type}');

    // Handle different reminder types
    if (reminder.type == 'Once') {
      await _notifications.zonedSchedule(
        reminder.id!,
        '⏰ ${reminder.title}',
        reminder.description.isEmpty ? 'Reminder' : reminder.description,
        scheduledDate,
        details,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } else if (reminder.type == 'Daily') {
      await _notifications.zonedSchedule(
        reminder.id!,
        '⏰ ${reminder.title}',
        reminder.description.isEmpty ? 'Daily Reminder' : reminder.description,
        scheduledDate,
        details,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } else if (reminder.type == 'Weekly') {
      await _notifications.zonedSchedule(
        reminder.id!,
        '⏰ ${reminder.title}',
        reminder.description.isEmpty ? 'Weekly Reminder' : reminder.description,
        scheduledDate,
        details,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    } else {
      await _notifications.zonedSchedule(
        reminder.id!,
        '⏰ ${reminder.title}',
        reminder.description.isEmpty
            ? '${reminder.type} Reminder'
            : reminder.description,
        scheduledDate,
        details,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }

    print('✅ Notification scheduled successfully');
  }

  /// Cancel a specific reminder notification
  static Future<void> cancelReminderNotification(int reminderId) async {
    await _notifications.cancel(reminderId);
    _reminderData.remove(reminderId);
    print('🔕 Cancelled notification for reminder ID: $reminderId');
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    _reminderData.clear();
    print('🔕 Cancelled all notifications');
  }

  /// Get list of pending notifications (for debugging)
  static Future<List<PendingNotificationRequest>>
  getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  // Legacy method for demo alarm
  static Future<void> scheduleAlarm(DateTime dateTime) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'alarm_channel',
          'Alarm',
          channelDescription: 'Alarm notifications',
          importance: Importance.max,
          priority: Priority.high,
          fullScreenIntent: true,
          playSound: true,
          enableVibration: true,
          ticker: 'Alarm',
          category: AndroidNotificationCategory.alarm,
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.zonedSchedule(
      0,
      '⏰ Alarm',
      'Swipe or tap dismiss',
      tz.TZDateTime.from(dateTime, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> stopAlarm() async {
    await _notifications.cancelAll();
  }
}
