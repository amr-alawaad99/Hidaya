import 'package:Hidaya/functions/prayer_times_manager.dart';
import 'package:adhan/adhan.dart';
import 'package:flutter/cupertino.dart';
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
            Column(
              children: [
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
                if(S.of(context).Language == "ar")
                  Row(
                  children: [
                    SizedBox(width: 50.w,),
                    Text(S.of(context).HourlyNotificationDescription, style: Theme.of(context).textTheme.labelMedium,),
                  ],
                ),
              ],
            ),
            Divider(),
            /// Recommended settings switch
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Row(
                  children: [
                    SizedBox(width: 50.w,),
                    Text(context.read<MainCubit>().calculationMethodMap(context)[PrayerTimesManager.getCalculationMethodParameters().method.name]!,
                    style: Theme.of(context).textTheme.labelMedium),
                    SizedBox(width: 10.w,),
                    Icon(Icons.verified, color: CupertinoColors.activeGreen,),
                  ],
                ),
              ],
            ),
            Divider(),
            if(!context.watch<MainCubit>().isRecommendedSettingsOn) ...[
              /// Calculation Method
              Row(
                children: [
                  Text(S.of(context).CalculationMethod),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      showDialog(context: context, builder: (context) => Dialog(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(20.sp),
                            child: Text(S.of(context).CalculationMethodDescription),
                          ),
                        ),
                      ),);
                    },
                    icon: Icon(Icons.info, color: Colors.amber,),
                  ),
                ],
              ),
              /// Calculation Method Menu
              DropdownMenu(
                initialSelection: context.watch<MainCubit>().initialMethod,
                textStyle: Theme.of(context).textTheme.labelLarge,
                width: double.infinity,
                onSelected: (value) {
                  context.read<MainCubit>().changeCalculationMethod(value!);
                },
                dropdownMenuEntries: [
                  DropdownMenuEntry(value: CalculationMethod.egyptian, label: S.of(context).EgyptianGeneralAuthorityOfSurvey),
                  DropdownMenuEntry(value: CalculationMethod.north_america, label: S.of(context).IslamicSocietyOfNorthAmerica),
                  DropdownMenuEntry(value: CalculationMethod.muslim_world_league, label: S.of(context).MuslimWorldLeague),
                  DropdownMenuEntry(value: CalculationMethod.karachi, label: S.of(context).UniversityOfIslamicSciencesKarachi),
                  DropdownMenuEntry(value: CalculationMethod.umm_al_qura, label: S.of(context).UmmAlQuraUniversityMakkah),
                  DropdownMenuEntry(value: CalculationMethod.dubai, label: S.of(context).UAE),
                  DropdownMenuEntry(value: CalculationMethod.qatar, label: S.of(context).Qatar),
                  DropdownMenuEntry(value: CalculationMethod.kuwait, label: S.of(context).Kuwait),
                  DropdownMenuEntry(value: CalculationMethod.moon_sighting_committee, label: S.of(context).MoonsightingCommittee),
                  DropdownMenuEntry(value: CalculationMethod.singapore, label: S.of(context).Singapore),
                  DropdownMenuEntry(value: CalculationMethod.turkey, label: S.of(context).Turkey),
                  DropdownMenuEntry(value: CalculationMethod.tehran, label: S.of(context).Tehran),
                ],
              ),
              Divider(),
              /// Asr Method
              Row(
                children: [
                  Text(S.of(context).AsrMethod),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      showDialog(context: context, builder: (context) => Dialog(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(20.sp),
                            child: Text(S.of(context).AsrMethodDescription),
                          ),
                        ),
                      ),);
                    },
                    icon: Icon(Icons.info, color: Colors.amber,),
                  ),
                ],
              ),
              /// Asr Method Menu
              DropdownMenu(
                initialSelection: context.watch<MainCubit>().initialMadhab,
                textStyle: Theme.of(context).textTheme.labelLarge,
                width: double.infinity,
                menuHeight: 400.h,
                onSelected: (value) {
                  context.read<MainCubit>().changeMadhab(value!);
                },
                dropdownMenuEntries: [
                  DropdownMenuEntry(value: Madhab.shafi, label: S.of(context).Shafi),
                  DropdownMenuEntry(value: Madhab.hanafi, label: S.of(context).Hanafi),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
