import 'package:timezone/browser.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService{

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// initialization
  static Future init() async{
    InitializationSettings settings = InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(),
    );
    await flutterLocalNotificationsPlugin.initialize(settings);
  }

  static final Future<bool?>? areNotificationsEnabled =
  FlutterLocalNotificationsPlugin().resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()?.areNotificationsEnabled();

  static final Future<bool?>? requestNotificationPermission =
  FlutterLocalNotificationsPlugin().resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

  /// Send basic notification
  static Future<void> showBasicNotification() async {
    print("basic Notification");
    NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        "id 1",
        "basic",
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      "hi - basic",
      "basic body",
      details,
    );
  }

  /// Send repeated notification every X period of time
  static Future<void> showRepeatedNotification() async {
    print("repeated Notification");
    NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        "id 2",
        "repeated",
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    await flutterLocalNotificationsPlugin.periodicallyShowWithDuration(
      1,
      "${DateTime.now()}",
      "صلي على محمد ﷺ",
      Duration(minutes: 5),
      details,
    );
  }

  /// Send scheduled notification at date/time X
  static Future<void> showScheduledNotification({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
    required DateTime nextDateTime,
  }) async {
    print("scheduled Notification");
    NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        "id 3",
        "scheduled",
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    TZDateTime scheduledTime = tz.TZDateTime(
      tz.local,
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
    );
    TZDateTime currentTime = tz.TZDateTime.now(tz.local);
    if(scheduledTime.isBefore(currentTime)){
      scheduledTime = tz.TZDateTime(
        tz.local,
        nextDateTime.year,
        nextDateTime.month,
        nextDateTime.day,
        nextDateTime.hour,
        nextDateTime.minute,
      );
    }
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      details,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
    print("$title  $scheduledTime");
  }

  static Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }


}