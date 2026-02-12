import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:remainder_manager_app/screens/home_screen.dart';

import './theme/app_theme.dart';
// import './screens/splash_screen.dart';
import './notifications/alarm_style/notification_alarm.dart';
import './notifications/alarm_style/alarm_screen.dart';
import './data/db/reminder_database.dart';

// Global navigation key (used for alarm screen from background)
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request permissions
  if (Platform.isAndroid) {
    await Permission.notification.request();
    await Permission.scheduleExactAlarm.request();
  }

  // Initialize notifications
  await NotificationService.init();

  // Handle alarm trigger
  NotificationService.onAlarmTrigger =
      (int reminderId, String title, String description) async {
        final reminder = await ReminderDatabase.instance.getById(reminderId);
        if (reminder == null) return;

        navigatorKey.currentState?.push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => AlarmScreen(
              title: title,
              description: description,
              reminderType: reminder.type,
              onDismiss: () async {
                if (reminder.type == 'Once') {
                  await NotificationService.cancelReminderNotification(
                    reminderId,
                  );
                  await ReminderDatabase.instance.delete(reminderId);
                }
              
              },
            ),
          ),
        );
      };

  runApp(const ReminderApp());
}

/* ================= APP ROOT ================= */

class ReminderApp extends StatelessWidget {
  const ReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'RemindMe',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
