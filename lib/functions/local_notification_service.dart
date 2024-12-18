import 'dart:math';
import 'package:Hidaya/constants/constants.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// initialization
  static Future init() async {
    InitializationSettings settings = InitializationSettings(
      android: AndroidInitializationSettings("@drawable/splash"),
      iOS: DarwinInitializationSettings(),
    );
    await flutterLocalNotificationsPlugin.initialize(settings);
  }

  static final Future<bool?>? areNotificationsEnabled =
      FlutterLocalNotificationsPlugin().resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.areNotificationsEnabled();

  static final Future<bool?>? requestNotificationPermission =
      FlutterLocalNotificationsPlugin().resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

  /// Send basic notification
  static Future<void> showBasicNotification() async {
    print("basic Notification");
    NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails("id 1", "basic",
          importance: Importance.max,
          priority: Priority.high,
          color: Constants.primaryColor),
      iOS: DarwinNotificationDetails(),
    );
    await flutterLocalNotificationsPlugin.show(
      5,
      "hi - basic",
      "basic body",
      details,
    );
  }

  /// Send periodic notification every X period of time
  static Future<void> showPeriodicNotification() async {
    NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        "id 2",
        "periodic",
        importance: Importance.max,
        priority: Priority.high,
        color: Constants.primaryColor,
      ),
      iOS: DarwinNotificationDetails(),
    );
    await flutterLocalNotificationsPlugin.periodicallyShow(
      6,
      "صلي على محمد ﷺ",
      null,
      RepeatInterval.hourly,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Send scheduled notification at date/time X
  static Future<void> showScheduledNotification({
    required int id,
    required String title,
    required DateTime dateTime,
    required DateTime nextDateTime,
    required bool playSoundOnSilent,
    required bool isFullAzan,
  }) async {
    List<String> generalStrings = [
      "الصَّلَوَاتُ الخَمْسُ، وَالْجُمُعَةُ إِلَى الْجُمُعَةِ، كَفَّارَةٌ لِمَا بَيْنَهُنَّ إِذَا اجْتُنِبَتِ الْكَبَائِرُ. (حَدِيثٌ نَبَوِيٌّ)",
      "حَيَّ عَلَى الصَّلَاةِ، حَيَّ عَلَى الفَلَاحِ.",
      "الصَّلَاةُ نُورٌ، وَالصَّدَقَةُ بُرْهَانٌ، وَالصَّبْرُ ضِيَاءٌ. (حَدِيثٌ نَبَوِيٌّ)",
      "إِنَّ الصَّلَاةَ تَنْهَى عَنِ الفَحْشَاءِ وَالمُنْكَرِ. (الْقُرْآنُ الْكَرِيمُ)",
      "إِنَّ أَوَّلَ مَا يُحَاسَبُ بِهِ الْعَبْدُ يَوْمَ الْقِيَامَةِ الصَّلَاةُ. (حَدِيثٌ نَبَوِيٌّ)",
      "إِنَّ الصَّلَاةَ كَانَتْ عَلَى المُؤْمِنِينَ كِتَابًا مَوْقُوتًا (القُرْآنُ الكَرِيمُ)",
      "أَقْرَبُ مَا يَكُونُ العَبْدُ مِنْ رَبِّهِ وَهُوَ سَاجِدٌ، فَأَكْثِرُوا الدُّعَاءَ. (حَدِيثٌ نَبَوِيٌّ)",
      "وَأَقِمِ الصَّلَاةَ ۖ إِنَّ الصَّلَاةَ تَنْهَىٰ عَنِ الْفَحْشَاءِ وَالْمُنكَرِ ۗ وَلَذِكْرُ اللَّهِ أَكْبَرُ ۗ وَاللَّهُ يَعْلَمُ مَا تَصْنَعُونَ (القُرْآنُ الكَرِيمُ)",
      "وَأَقِمِ الصَّلَاةَ طَرَفَيِ النَّهَارِ وَزُلَفًا مِنَ اللَّيْلِ. (الْقُرْآنُ الْكَرِيمُ)",
      "المَلائِكَةُ تُصَلِّي عَلَى أَحَدِكُمْ مَا دَامَ فِي مُصَلاَّهُ الَّذي صَلَّى فِيهِ مَا لمْ يُحْدِثْ، تَقُولُ: اللَّهُمَّ اغْفِرْ لَهُ، اللَّهُمَّ ارْحَمْهُ. (حَدِيثٌ نَبَوِيٌّ)",
    ];

    List<String> fajrStrings = [
      "مَنْ صَلَّى الْعِشَاءَ فِي جَمَاعَةٍ فَكَأَنَّمَا قَامَ نِصْفَ اللَّيْلِ، وَمَنْ صَلَّى الصُّبْحَ فِي جَمَاعَةٍ فَكَأَنَّمَا قَامَ اللَّيْلَ كُلَّهُ. (حَدِيثٌ نَبَوِيٌّ)",
      "أَقِمِ الصَّلَاةَ لِدُلُوكِ الشَّمْسِ إِلَى غَسَقِ اللَّيْلِ وَقُرْآنَ الفَجْرِ إِنَّ قُرْآنَ الفَجْرِ كَانَ مَشْهُودًا (القُرْآنُ الكَرِيمُ)",
      "الصَّلَاةُ خَيْرٌ مِنَ النَّوْمِ",
    ] + generalStrings;

    List<String> asrStrings = [
      "حَافِظُوا عَلَى الصَّلَوَاتِ وَالصَّلَاةِ الوُسْطَى (القُرْآنُ الكَرِيمُ)",
    ] + generalStrings;

    List<String> ishaStrings = [
      "مَنْ صَلَّى الْعِشَاءَ فِي جَمَاعَةٍ فَكَأَنَّمَا قَامَ نِصْفَ اللَّيْلِ، وَمَنْ صَلَّى الصُّبْحَ فِي جَمَاعَةٍ فَكَأَنَّمَا قَامَ اللَّيْلَ كُلَّهُ. (حَدِيثٌ نَبَوِيٌّ)",
    ] + generalStrings;

    List<String> body = [];

    switch(id){
      case 0:
        body = fajrStrings;
        break;
      case 2:
        body = asrStrings;
        break;
      case 4:
        body = ishaStrings;
        break;
      default:
        body = generalStrings;
        break;
    }
    String bodyText = body[Random().nextInt(body.length)];
    NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        "$title $id ${DateTime.now()}",
        "scheduled $id",
        color: Constants.primaryColor,
        playSound: true,
        sound: isFullAzan? RawResourceAndroidNotificationSound('full_azan') : RawResourceAndroidNotificationSound('azan'),
        importance: Importance.max,
        priority: Priority.max,
        audioAttributesUsage: playSoundOnSilent? AudioAttributesUsage.media : AudioAttributesUsage.notification, // "media" makes the notification works in silent mode (makes the sound based on media volume instead of notification sound volume)
        styleInformation: BigTextStyleInformation(bodyText), // for text expanding if the notification's body text is more that one line
      ),
      iOS: DarwinNotificationDetails(),
    );
    var scheduledTime = tz.TZDateTime(
      tz.local,
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
    );
    var currentTime = tz.TZDateTime.now(tz.local);
    if (scheduledTime.isBefore(currentTime)) {
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
      bodyText,
      scheduledTime,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Ensures notifications are shown when the device is idle
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
