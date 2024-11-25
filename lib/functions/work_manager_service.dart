import 'package:Hidaya/functions/prayer_times_manager.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:Hidaya/cache/cache_helper.dart';
import 'package:Hidaya/functions/local_notification_service.dart';
import 'package:workmanager/workmanager.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class WorkManagerService {
  Future<void> init() async {
    await Workmanager().initialize(
        callbackDispatcher, // The top level function, aka callbackDispatcher
        isInDebugMode:
            false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
        );
  }

  Future<void> registerMyTask({
    required int id,
    required String title,
    required String prayerName,
    required bool isSoundOnSilent,
    required bool isFullAzan,
      }) async {
    await Workmanager().registerPeriodicTask(
      id.toString(),
      "dailyNotification",
      inputData: <String, dynamic>{
        "id": id,
        "title": title,
        "prayerName": prayerName,
        "isSoundOnSilent": isSoundOnSilent,
        "isFullAzan": isFullAzan,
      },
      frequency: Duration(hours: 8),
      constraints: Constraints(
        networkType: NetworkType.not_required,
        requiresBatteryNotLow:
            false, // Allows task to run even if the battery is low
        requiresCharging: false, // Allows task to run even if not charging
        requiresDeviceIdle:
            false, // Allows task to run even if the device is not idle
      ),
    );
  }

  void cancelTask(int id) {
    Workmanager().cancelByUniqueName(id.toString());
  }
}

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await CacheHelper().init();
    DateTime currentPrayer =
        PrayerTimesManager().prayerTime(inputData!["prayerName"])!;
    DateTime nextPrayer =
        PrayerTimesManager().nextDayPrayerTime(inputData["prayerName"])!;
    tz.initializeTimeZones();
    // Get the local timezone identifier (e.g., 'Africa/Cairo')
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    // Set the timezone location in the timezone package
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    print("WM ${inputData["isFullAzan"]}");
    print("WM ${inputData["isSoundOnSilent"]}");
    switch (task) {
      case "dailyNotification":
        await LocalNotificationService.showScheduledNotification(
          id: inputData['id'],
          title: inputData["title"],
          dateTime: currentPrayer,
          nextDateTime: nextPrayer,
          playSoundOnSilent: inputData["isSoundOnSilent"],
          isFullAzan: inputData["isFullAzan"],
        );
        break;
    }
    return Future.value(true);
  });
}
