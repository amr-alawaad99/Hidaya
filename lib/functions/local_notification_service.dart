import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hadith_reminder/constants/constants.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService{

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// initialization
  static Future init() async{
    InitializationSettings settings = InitializationSettings(
      android: AndroidInitializationSettings("@drawable/ic_launcher_foreground"),
      iOS: DarwinInitializationSettings(),
    );
    await flutterLocalNotificationsPlugin.initialize(settings);
    showRepeatedNotification();
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
        "id 2",
        "basic",
        importance: Importance.max,
        priority: Priority.high,
        color: Constants.primaryColor
      ),
      iOS: DarwinNotificationDetails(),
    );
    await flutterLocalNotificationsPlugin.show(
      5,
      "hi - basic",
      "basic body",
      details,
    );
  }

  /// Send repeated notification every X period of time
  static Future<void> showRepeatedNotification() async {
    NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        "id 2",
        "repeated",
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    await flutterLocalNotificationsPlugin.periodicallyShow(
      6,
      "صلي على محمد ﷺ",
      null,
      RepeatInterval.hourly,
      details,
    );
  }

  /// Send scheduled notification at date/time X
  static Future<void> showScheduledNotification({
    required int id,
    required String title,
    required DateTime dateTime,
    required DateTime nextDateTime,
  }) async {
    NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        "id 3",
        "scheduled",
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound("azan"),
      ),
      iOS: DarwinNotificationDetails(),
    );
    print(tz.local);
    var scheduledTime = tz.TZDateTime(
      tz.local,
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
    );
    var currentTime = tz.TZDateTime.now(tz.local);
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
    List<String> body = [
      "حَيَّ عَلَى الصَّلَاةِ، حَيَّ عَلَى الفَلَاحِ.",
      "الصَّلَاةُ نُورٌ، وَالصَّدَقَةُ بُرْهَانٌ، وَالصَّبْرُ ضِيَاءٌ. (حَدِيثٌ نَبَوِيٌّ)",
      "مَنْ تَرَكَ الصَّلَاةَ مُتَعَمِّدًا فَقَدْ كَفَرَ. (حَدِيثٌ نَبَوِيٌّ)",
      "إِنَّ الصَّلَاةَ تَنْهَى عَنِ الفَحْشَاءِ وَالمُنْكَرِ. (الْقُرْآنُ الْكَرِيمُ)",
      "وَأَقِمِ الصَّلَاةَ طَرَفَيِ النَّهَارِ وَزُلَفًا مِنَ اللَّيْلِ. (الْقُرْآنُ الْكَرِيمُ)",
      "الصَّلَاةُ عِمَادُ الدِّينِ، مَنْ أَقَامَهَا فَقَدْ أَقَامَ الدِّينَ. (حَدِيثٌ نَبَوِيٌّ)",
      "وَاسْتَعِينُوا بِالصَّبْرِ وَالصَّلَاةِ. (الْقُرْآنُ الْكَرِيمُ)",
      "إِنَّ أَوَّلَ مَا يُحَاسَبُ بِهِ الْعَبْدُ يَوْمَ الْقِيَامَةِ الصَّلَاةُ. (حَدِيثٌ نَبَوِيٌّ)",
      "إِذَا نُودِيَ لِلصَّلَاةِ، فَلَا يَسْتَجِيبُ لِهَا إِلَّا مَنْ فِي قَلْبِهِ نُورٌ. (حَدِيثٌ نَبَوِيٌّ)",
      "الصَّلَاةُ خَيْرٌ مِنَ النَّوْمِ.",
      "حَافِظُوا عَلَى الصَّلَوَاتِ وَالصَّلَاةِ الوُسْطَى (القُرْآنُ الكَرِيمُ).",
      "إِنَّ الصَّلَاةَ كَانَتْ عَلَى المُؤْمِنِينَ كِتَابًا مَوْقُوتًا (القُرْآنُ الكَرِيمُ).",
      "أَقِمِ الصَّلَاةَ لِدُلُوكِ الشَّمْسِ إِلَى غَسَقِ اللَّيْلِ وَقُرْآنَ الفَجْرِ إِنَّ قُرْآنَ الفَجْرِ كَانَ مَشْهُودًا (القُرْآنُ الكَرِيمُ).",
      "أَقْرَبُ مَا يَكُونُ العَبْدُ مِنْ رَبِّهِ وَهُوَ سَاجِدٌ، فَأَكْثِرُوا الدُّعَاءَ (حَدِيثٌ نَبَوِيٌّ)."
    ];
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body[Random().nextInt(body.length)],
      scheduledTime,
      details,
      matchDateTimeComponents: DateTimeComponents.time, // Required for periodic scheduling
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,// Ensures notifications are shown when the device is idle
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
    print("$id cancelled");
  }


}