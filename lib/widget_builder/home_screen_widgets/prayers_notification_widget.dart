import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hadith_reminder/constants/constants.dart';
import 'package:hadith_reminder/cubit/main_cubit.dart';
import 'package:hadith_reminder/widget_builder/home_screen_widgets/prayers_time_widget.dart';
import '../../generated/l10n.dart';

class PrayersNotificationWidget extends StatelessWidget {

  final PrayerTimes prayerTime;
  const PrayersNotificationWidget({super.key, required this.prayerTime});


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(15.sp),
          child: Text(S.of(context).PrayerNotification, style: Constants.headingTitle2.copyWith(color: Colors.black),),
        ),
        Container(height: 0.5, color: Colors.black,),
        notificationCard(Prayer.fajr.name, prayerTime.fajr, context),
        notificationCard(Prayer.dhuhr.name, prayerTime.dhuhr, context),
        notificationCard(Prayer.asr.name, prayerTime.asr, context),
        notificationCard(Prayer.maghrib.name, prayerTime.maghrib, context),
        notificationCard(Prayer.isha.name, prayerTime.isha, context),
      ],
    );
  }
}


Widget notificationCard (String prayerName, DateTime prayerTime, BuildContext context) => Container(
  padding: EdgeInsets.all(15.sp),
  decoration: BoxDecoration(
    border: BorderDirectional(bottom: BorderSide(color: Colors.black, width: 0.5.w))
  ),
  child: Row(
    children: [
      Expanded(child: Text(ar_enPrayerName(prayerName, context), style: Constants.headingCaption.copyWith(color: Colors.black),)),
      Switch(
        value: context.read<MainCubit>().prayerNotifications[prayerName]!,
        onChanged: (value) {
          context.read<MainCubit>().toggleSwitch(isOn: value, prayerName: prayerName);
        },
      ),
    ],
  ),
);