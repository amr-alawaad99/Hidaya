import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import '../cubit/main_cubit.dart';
import '../generated/l10n.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15.sp),
        child: Column(
          children: [
            /// Dark mode switch
            Row(
              children: [
                Icon(TablerIcons.moon_filled, color: Colors.amber, size: 35.sp,),
                SizedBox(width: 10.w,),
                Expanded(child: Text(S.of(context).DarkMode, style: Theme.of(context).textTheme.bodySmall, maxLines: 1,overflow: TextOverflow.ellipsis,),),
                Switch(
                  value: context.watch<MainCubit>().isDarkMode,
                  onChanged: (value) {
                    context.read<MainCubit>().switchThemeMode();
                  },
                ),
              ],
            ),
            Divider(),
            /// hourly Notification switch
            Row(
              children: [
                Icon(Icons.notifications_active_outlined, color: Colors.amber, size: 35.sp,),
                SizedBox(width: 10.w,),
                Expanded(child: Text(S.of(context).HourlyNotification, style: Theme.of(context).textTheme.bodySmall, maxLines: 1,overflow: TextOverflow.ellipsis,),),
                Switch(
                  value: context.watch<MainCubit>().isHourlyNotificationsOn,
                  onChanged: (value) async {
                    bool? areNotificationsEnabled = await context.read<MainCubit>().requestNotificationPermission();
                    if (areNotificationsEnabled!) {
                      context.read<MainCubit>().switchHourlyNotifications();
                    } else if (!areNotificationsEnabled) {
                      value = false;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).NotificationsDisabled)));
                    }
                  },
                ),
              ],
            ),
            Divider(),
            /// Recommended settings switch
            Row(
              children: [
                Icon(Icons.settings, color: Colors.amber, size: 35.sp,),
                SizedBox(width: 10.w,),
                Expanded(child: Text(S.of(context).RecommendedSettings, style: Theme.of(context).textTheme.bodySmall, maxLines: 1,overflow: TextOverflow.ellipsis,),),
                Switch(
                  value: context.watch<MainCubit>().isRecommendedSettingsOn,
                  onChanged: (value) async {
                    context.read<MainCubit>().switchRecommendedSettings();
                  },
                ),
              ],
            ),
            Divider(),
            /// Calculation Method
            Row(
              children: [
                Text(S.of(context).CalculationMethod),
                Spacer(),
                IconButton(
                  onPressed: () {}, 
                  icon: Icon(Icons.info, color: Colors.amber,),
                ),
              ],
            ),
            /// Calculation Method Menu
            DropdownMenu(
              initialSelection: 1,
              textStyle: Theme.of(context).textTheme.labelLarge,
              menuHeight: 400.h,
              width: double.infinity,
              dropdownMenuEntries: [
                DropdownMenuEntry(value: 1, label: S.of(context).EgyptianGeneralAuthorityOfSurvey),
                DropdownMenuEntry(value: 2, label: S.of(context).MuslimWorldLeague),
                DropdownMenuEntry(value: 3, label: S.of(context).UniversityOfIslamicSciencesKarachi),
                DropdownMenuEntry(value: 4, label: S.of(context).UmmAlQuraUniversityMakkah),
                DropdownMenuEntry(value: 5, label: S.of(context).UAE),
                DropdownMenuEntry(value: 6, label: S.of(context).Qatar),
                DropdownMenuEntry(value: 7, label: S.of(context).Kuwait),
                DropdownMenuEntry(value: 8, label: S.of(context).MoonsightingCommittee),
                DropdownMenuEntry(value: 9, label: S.of(context).Singapore),
                DropdownMenuEntry(value: 10, label: S.of(context).IslamicSocietyOfNorthAmerica),
                DropdownMenuEntry(value: 11, label: S.of(context).Turkey),
                DropdownMenuEntry(value: 12, label: S.of(context).Tehran),
              ],
            ),
            Divider(),
            /// Asr Method
            Row(
              children: [
                Text(S.of(context).AsrMethod),
                Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.info, color: Colors.amber,),
                ),
              ],
            ),
            /// Asr Method Menu
            DropdownMenu(
              initialSelection: 1,
              textStyle: Theme.of(context).textTheme.labelLarge,
              width: double.infinity,
              menuHeight: 400.h,
              dropdownMenuEntries: [
                DropdownMenuEntry(value: 1, label: S.of(context).Shafi),
                DropdownMenuEntry(value: 2, label: S.of(context).Hanafi),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
