import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload == 'alarm') {
          // handled by full-screen intent
        }
      },
    );
  }

  static Future<void> scheduleAlarm(DateTime dateTime) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'alarm_channel', // channel id
          'Alarm', // channel name
          channelDescription: 'Alarm notifications',
          importance: Importance.max,
          priority: Priority.high,
          fullScreenIntent: true, // <-- MUST be true
          playSound: true,
          // sound: RawResourceAndroidNotificationSound(
          //   'alarm_sound',
          // ), // must exist in res/raw
          enableVibration: true,
          ticker: 'Alarm',
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
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> stopAlarm() async {
    await _notifications.cancelAll();
  }
}
