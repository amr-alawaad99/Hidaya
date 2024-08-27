import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:Hidaya/cache/cache_helper.dart';
import 'package:Hidaya/functions/local_notification_service.dart';
import 'package:Hidaya/screens/home_screen.dart';
import 'package:workmanager/workmanager.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class WorkManagerService{

  Future<void> init() async {
    await Workmanager().initialize(
        callbackDispatcher, // The top level function, aka callbackDispatcher
        isInDebugMode: false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
    );
  }

  Future<void> registerMyTask({
    required int id,
    required String title,
    required String prayerName
  }) async {
    await Workmanager().registerPeriodicTask(
      id.toString(),
      "dailyNotification",
      inputData: <String, dynamic>{
        "id" : id,
        "title" : title,
        "prayerName" : prayerName,
      },
      frequency: Duration(hours: 8),
      constraints: Constraints(
        networkType: NetworkType.not_required,
        requiresBatteryNotLow: false, // Allows task to run even if the battery is low
        requiresCharging: false, // Allows task to run even if not charging
        requiresDeviceIdle: false, // Allows task to run even if the device is not idle
      ),
    );
  }

  void cancelTask(int id){
    Workmanager().cancelByUniqueName(id.toString());
  }


}

@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await CacheHelper().init();
    DateTime currentPrayer = HomeScreenState().prayerTime(inputData!["prayerName"])!;
    DateTime nextPrayer = HomeScreenState().nextDayPrayerTime(inputData["prayerName"])!;
    tz.initializeTimeZones();
    // Get the local timezone identifier (e.g., 'Africa/Cairo')
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    // Set the timezone location in the timezone package
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    switch(task){
      case "dailyNotification":
        await LocalNotificationService.showScheduledNotification(id: inputData['id'], title: inputData["title"], dateTime: currentPrayer, nextDateTime: nextPrayer);
        break;
    }
    return Future.value(true);
  });
}