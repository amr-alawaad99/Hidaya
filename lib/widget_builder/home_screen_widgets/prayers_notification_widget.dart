import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Hidaya/cache/cache_helper.dart';
import 'package:Hidaya/constants/constants.dart';
import 'package:Hidaya/functions/local_notification_service.dart';
import 'package:Hidaya/cubit/main_cubit.dart';
import 'package:Hidaya/functions/work_manager_service.dart';
import 'package:Hidaya/widget_builder/home_screen_widgets/prayers_time_widget.dart';
import '../../generated/l10n.dart';

class PrayersNotificationWidget extends StatelessWidget {
  final PrayerTimes prayerTime;
  final DateTime? Function(String) dateTime;

  const PrayersNotificationWidget(
      {super.key, required this.prayerTime, required this.dateTime});

  @override
  Widget build(BuildContext context) {
    CacheHelper().saveData(key: "a", value: prayerTime.fajr.toString());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(15.sp),
          child: Text(
            S.of(context).PrayerNotification,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Container(
          height: 0.5,
          color: Theme.of(context).dividerColor,
        ),
        notificationCard(Prayer.fajr.name, context),
        notificationCard(Prayer.dhuhr.name, context),
        notificationCard(Prayer.asr.name, context),
        notificationCard(Prayer.maghrib.name, context),
        notificationCard(Prayer.isha.name, context),
      ],
    );
  }
}

Map<String, int> prayerId = {
  "fajr": 0,
  "dhuhr": 1,
  "asr": 2,
  "maghrib": 3,
  "isha": 4,
};

Widget notificationCard(String prayerName, BuildContext context) => Container(
      padding: EdgeInsets.all(15.sp),
      decoration: BoxDecoration(
        border: BorderDirectional(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: 0.5.w),
        ),
      ),
      child: Row(
        children: [
          /// prayer Name
          Expanded(
              child: Text(
            ar_enPrayerName(prayerName, context),
            style: Theme.of(context).textTheme.bodySmall,
          )),
          /// Turn notification on/off switch
          Switch(
            value: context.watch<MainCubit>().prayerNotifications[prayerName]!,
            onChanged: (value) async {
              bool? areNotificationsEnabled = await context.read<MainCubit>().requestNotificationPermission();
              if (areNotificationsEnabled!) {
                context.read<MainCubit>().toggleSwitch(isOn: value, prayerName: prayerName);
                switch (value) {
                  case true:
                    WorkManagerService().registerMyTask(id: prayerId[prayerName]!, title: "صلاة ${ar_enPrayerName(prayerName, context)} - $prayerName prayer", prayerName: prayerName); // title example "صلاة الفحر - fajr prayer"
                    return null;
                  case false:
                    LocalNotificationService.cancelNotification(prayerId[prayerName]!);
                    WorkManagerService().cancelTask(prayerId[prayerName]!);
                    return null;
                }
              } else if (!areNotificationsEnabled) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).NotificationsDisabled)));
              }
            },
          ),
        ],
      ),
    );
