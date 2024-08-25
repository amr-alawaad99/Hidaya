import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hadith_reminder/constants/constants.dart';
import 'package:hadith_reminder/functions/local_notification_service.dart';
import 'package:hadith_reminder/cubit/main_cubit.dart';
import 'package:hadith_reminder/widget_builder/home_screen_widgets/prayers_time_widget.dart';
import '../../generated/l10n.dart';

class PrayersNotificationWidget extends StatelessWidget {
  final PrayerTimes prayerTime;
  final DateTime? Function(String) dateTime;

  const PrayersNotificationWidget({super.key, required this.prayerTime, required this.dateTime});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(15.sp),
          child: Text(
            S.of(context).PrayerNotification,
            style: Constants.headingTitle2.copyWith(color: Colors.black),
          ),
        ),
        Container(
          height: 0.5,
          color: Colors.black,
        ),
        notificationCard(Prayer.fajr.name, prayerTime.fajr, dateTime(Prayer.fajr.name)!, context),
        notificationCard(Prayer.dhuhr.name, prayerTime.dhuhr, dateTime(Prayer.dhuhr.name)!,context),
        notificationCard(Prayer.asr.name, prayerTime.asr, dateTime(Prayer.asr.name)!,context),
        notificationCard(Prayer.maghrib.name, prayerTime.maghrib, dateTime(Prayer.maghrib.name)!,context),
        notificationCard(Prayer.isha.name, prayerTime.isha, dateTime(Prayer.isha.name)!,context),
      ],
    );
  }
}

Widget notificationCard(String prayerName, DateTime prayerTime, DateTime prayerNextDayTime, BuildContext context) => Container(
    padding: EdgeInsets.all(15.sp),
    decoration: BoxDecoration(
        border: BorderDirectional(
            bottom: BorderSide(color: Colors.black, width: 0.5.w))),
    child: Row(
      children: [
        Expanded(
            child: Text(
          ar_enPrayerName(prayerName, context),
          style: Constants.headingCaption.copyWith(color: Colors.black),
        )),
        Switch(
          value: context.read<MainCubit>().prayerNotifications[prayerName]!,
          onChanged: (value) async {
            bool? areNotificationsEnabled = await context.read<MainCubit>().requestNotificationPermission();
            if(areNotificationsEnabled!){
              context.read<MainCubit>().toggleSwitch(isOn: value, prayerName: prayerName);
              if (prayerName == "fajr") {
                LocalNotificationService.showBasicNotification();
              }
              if (prayerName == "dhuhr") {
                LocalNotificationService.showRepeatedNotification();
              }
              if (prayerName == "asr") {
                LocalNotificationService.showScheduledNotification(
                  id: 3,
                  title: prayerName,
                  body: prayerTime.toString(),
                  dateTime: prayerTime,
                  nextDateTime: prayerNextDayTime,
                );
                // WorkManagerService().init();
            }
            } else if (!areNotificationsEnabled){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).NotificationsDisabled)));
            }

          },
        ),
      ],
    ),
  );
