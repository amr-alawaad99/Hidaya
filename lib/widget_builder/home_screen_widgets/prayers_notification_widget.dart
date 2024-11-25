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
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              context.read<MainCubit>().changeWidgetVisibility(prayerId[prayerName]!);
            },
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
                          WorkManagerService().registerMyTask(
                            id: prayerId[prayerName]!,
                            title: "صلاة ${ar_enPrayerName(prayerName, context)} - $prayerName prayer", // title example "صلاة الفحر - fajr prayer"
                            prayerName: prayerName,
                            isFullAzan: CacheHelper().getData(key: SharedPrefConst.isFullAzan[prayerId[prayerName]!])?? false,
                            isSoundOnSilent: CacheHelper().getData(key: SharedPrefConst.playSoundOnSilent[prayerId[prayerName]!])?? false,
                          );
                          print(CacheHelper().getData(key: SharedPrefConst.isFullAzan[prayerId[prayerName]!]));
                          print(CacheHelper().getData(key: SharedPrefConst.playSoundOnSilent[prayerId[prayerName]!]));
                          return null;
                        case false:
                          LocalNotificationService.cancelNotification(prayerId[prayerName]!);
                          WorkManagerService().cancelTask(prayerId[prayerName]!);
                          return null;
                      }
                    } else if (!areNotificationsEnabled) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(S.of(context).NotificationsDisabled)));
                    }
                  },
                ),
                Icon(context.read<MainCubit>().isWidgetVisible[prayerId[prayerName]!]? Icons.keyboard_arrow_down : Icons.keyboard_arrow_left, color: Colors.black,),
              ],
            ),
          ),
          if(context.watch<MainCubit>().isWidgetVisible[prayerId[prayerName]!])
          Column(
            children: [
              CheckboxListTile(
                title: Text(
                  S.of(context).isFullAzanOn,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.normal),
                ),
                contentPadding: EdgeInsets.zero,
                value: CacheHelper().getData(key: SharedPrefConst.isFullAzan[prayerId[prayerName]!])?? false,
                onChanged: (value) {
                  CacheHelper().saveData(key: SharedPrefConst.isFullAzan[prayerId[prayerName]!], value: value);
                  context.read<MainCubit>().update();
                },
              ),
              CheckboxListTile(
                title: Text(
                  S.of(context).SoundOnSilent,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.normal),
                ),
                contentPadding: EdgeInsets.zero,
                value: CacheHelper().getData(key: SharedPrefConst.playSoundOnSilent[prayerId[prayerName]!])?? false,
                onChanged: (value) {
                  CacheHelper().saveData(key: SharedPrefConst.playSoundOnSilent[prayerId[prayerName]!], value: value);
                  context.read<MainCubit>().update();
                },
              ),
            ],
          ),
        ],
      ),
    );
