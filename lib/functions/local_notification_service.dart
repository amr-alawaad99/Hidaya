import 'dart:math';
import 'package:Hidaya/cache/cache_helper.dart';
import 'package:Hidaya/constants/constants.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService{

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// initialization
  static Future init() async{
    InitializationSettings settings = InitializationSettings(
      android: AndroidInitializationSettings("@drawable/splash"),
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
      androidScheduleMode:AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Send scheduled notification at date/time X
  static Future<void> showScheduledNotification({
    required int id,
    required String title,
    required DateTime dateTime,
    required DateTime nextDateTime,
  }) async {
    List<String> body = [
      "المَلائِكَةُ تُصَلِّي عَلَى أَحَدِكُمْ مَا دَامَ فِي مُصَلاَّهُ الَّذي صَلَّى فِيهِ مَا لمْ يُحْدِثْ، تَقُولُ: اللَّهُمَّ اغْفِرْ لَهُ، اللَّهُمَّ ارْحَمْهُ. (حَدِيثٌ نَبَوِيٌّ)",
      "مَنْ صَلَّى الْعِشَاءَ فِي جَمَاعَةٍ فَكَأَنَّمَا قَامَ نِصْفَ اللَّيْلِ، وَمَنْ صَلَّى الصُّبْحَ فِي جَمَاعَةٍ فَكَأَنَّمَا قَامَ اللَّيْلَ كُلَّهُ. (حَدِيثٌ نَبَوِيٌّ)",
      "الصَّلَوَاتُ الخَمْسُ، وَالْجُمُعَةُ إِلَى الْجُمُعَةِ، كَفَّارَةٌ لِمَا بَيْنَهُنَّ إِذَا اجْتُنِبَتِ الْكَبَائِرُ. (حَدِيثٌ نَبَوِيٌّ)",
      "حَيَّ عَلَى الصَّلَاةِ، حَيَّ عَلَى الفَلَاحِ.",
      "الصَّلَاةُ نُورٌ، وَالصَّدَقَةُ بُرْهَانٌ، وَالصَّبْرُ ضِيَاءٌ. (حَدِيثٌ نَبَوِيٌّ)",
      "إِنَّ الصَّلَاةَ تَنْهَى عَنِ الفَحْشَاءِ وَالمُنْكَرِ. (الْقُرْآنُ الْكَرِيمُ)",
      "وَأَقِمِ الصَّلَاةَ طَرَفَيِ النَّهَارِ وَزُلَفًا مِنَ اللَّيْلِ. (الْقُرْآنُ الْكَرِيمُ)",
      "وَاسْتَعِينُوا بِالصَّبْرِ وَالصَّلَاةِ. (الْقُرْآنُ الْكَرِيمُ)",
      "إِنَّ أَوَّلَ مَا يُحَاسَبُ بِهِ الْعَبْدُ يَوْمَ الْقِيَامَةِ الصَّلَاةُ. (حَدِيثٌ نَبَوِيٌّ)",
      "إذا نوديَ بالصَّلاةِ فلا تَأْتُوها تَسعَوْن؛ ولكِنِ امْشُوا مَشيًا عليكمُ السكينةُ، فما أَدرَكتُم فصَلُّوا، وما سبَقَكم فاقْضُوا. (حَدِيثٌ نَبَوِيٌّ)",
      "الصَّلَاةُ خَيْرٌ مِنَ النَّوْمِ",
      "حَافِظُوا عَلَى الصَّلَوَاتِ وَالصَّلَاةِ الوُسْطَى (القُرْآنُ الكَرِيمُ)",
      "إِنَّ الصَّلَاةَ كَانَتْ عَلَى المُؤْمِنِينَ كِتَابًا مَوْقُوتًا (القُرْآنُ الكَرِيمُ)",
      "أَقِمِ الصَّلَاةَ لِدُلُوكِ الشَّمْسِ إِلَى غَسَقِ اللَّيْلِ وَقُرْآنَ الفَجْرِ إِنَّ قُرْآنَ الفَجْرِ كَانَ مَشْهُودًا (القُرْآنُ الكَرِيمُ)",
      "أَقْرَبُ مَا يَكُونُ العَبْدُ مِنْ رَبِّهِ وَهُوَ سَاجِدٌ، فَأَكْثِرُوا الدُّعَاءَ. (حَدِيثٌ نَبَوِيٌّ)",
      "وَأَقِمِ الصَّلَاةَ ۖ إِنَّ الصَّلَاةَ تَنْهَىٰ عَنِ الْفَحْشَاءِ وَالْمُنكَرِ ۗ وَلَذِكْرُ اللَّهِ أَكْبَرُ ۗ وَاللَّهُ يَعْلَمُ مَا تَصْنَعُونَ (القُرْآنُ الكَرِيمُ)"
    ];
    String bodyText = body[Random().nextInt(body.length)];
    NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        "id 3",
        "scheduled",
        color: Constants.primaryColor,
        sound: RawResourceAndroidNotificationSound('azan'),
        playSound: true,
        importance: Importance.max,
        priority: Priority.high,
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
      bodyText,
      scheduledTime,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,// Ensures notifications are shown when the device is idle
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }


}