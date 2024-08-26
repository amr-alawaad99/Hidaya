import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hadith_reminder/cubit/main_cubit.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

import '../../constants/constants.dart';
import '../../generated/l10n.dart';

class PrayersTimeWidget extends StatelessWidget {
  final PrayerTimes prayerTimes;
  final Duration remainingTime;
  final String address;
  final DateTime nextFajr;
  final Future<void> Function() getCurrentLocation;

  const PrayersTimeWidget(
      {super.key,
      required this.prayerTimes,
      required this.remainingTime,
      required this.address,
      required this.nextFajr,
      required this.getCurrentLocation});

  @override
  Widget build(BuildContext context) {
    HijriCalendar.setLocal(S.of(context).Language);
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      padding: EdgeInsets.all(15.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Hijri Date
          Row(
            children: [
              FittedText(
                text: HijriCalendar.now()
                    .toFormat("dd MMMM yyyy ${S.of(context).Hijri}"),
                textStyle: Constants.headingTitle2,
                boxConstraints:
                    BoxConstraints(maxWidth: 0.6.sw, maxHeight: 0.05.sh),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  context.read<MainCubit>().changeLocalLang();
                },
                child: Text(S.of(context).Language == "en"
                    ? "AR"
                    : "EN"), // if the app is in Arabic show EN button and vice versa
              ),
            ],
          ),
          SizedBox(
            height: 0.h,
          ),

          /// Address
          Row(
            children: [
              /// Address
              FittedText(
                boxConstraints:
                    BoxConstraints(maxWidth: 0.5.sw, maxHeight: 0.03.sh),
                text: address,
                textStyle: Constants.headingCaption,
              ),
              SizedBox(
                width: 10.w,
              ),

              /// reload address button
              GestureDetector(
                onTap: () {
                  getCurrentLocation();
                },
                child: Icon(
                  TablerIcons.repeat,
                  color: Colors.white,
                  size: 15.sp,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30.h,
          ),

          /// Next prayer, it's time, and how much time left
          Center(
            child: Column(
              children: [
                Text(
                  ar_enPrayerName(
                      prayerTimes.nextPrayer().name == Prayer.none.name
                          ? Prayer.fajr.name
                          : prayerTimes.nextPrayer().name,
                      context),
                  style: Constants.headingCaption,
                ),
                Text(
                  DateFormat.jm(S.of(context).Language).format(
                      prayerTimes.timeForPrayer(prayerTimes.nextPrayer()) ??
                          nextFajr),
                  style: Constants.headingTitle1,
                ),
                Text(
                  "${S.of(context).TimeLeft} "
                  "${remainingTime.inHours > 0 ? "${remainingTime.inHours} ${S.of(context).Hour}${remainingTime.inHours > 1 && S.of(context).Language == "en" ? 's' : ''} " : ""}"
                  "${remainingTime.inMinutes > 0 ? "${remainingTime.inMinutes % 60} ${S.of(context).Minute}${remainingTime.inMinutes > 1 && S.of(context).Language == "en" ? 's' : ''} " : ""}"
                  "${remainingTime.inHours == 0 ? "${remainingTime.inSeconds % 60} ${S.of(context).Second}${remainingTime.inSeconds > 1 && S.of(context).Language == "en" ? 's' : ''} " : ""}",
                  style: Constants.headingCaption,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30.h,
          ),

          /// Each prayer name, icon, and time
          Row(
            children: [
              const Spacer(),
              prayerTimeCard(prayerTimes.fajr, S.of(context).Fajr,
                  TablerIcons.sun_moon, context),
              const Spacer(),
              prayerTimeCard(prayerTimes.dhuhr, S.of(context).Dhuhr,
                  TablerIcons.sun_filled, context),
              const Spacer(),
              prayerTimeCard(prayerTimes.asr, S.of(context).Asr,
                  TablerIcons.sunset_2, context),
              const Spacer(),
              prayerTimeCard(prayerTimes.maghrib, S.of(context).Maghrib,
                  TablerIcons.sunset, context),
              const Spacer(),
              prayerTimeCard(prayerTimes.isha, S.of(context).Isha,
                  TablerIcons.moon, context),
              const Spacer(),
            ],
          ),
          SizedBox(
            height: 30.h,
          ),
        ],
      ),
    );
  }
}

String ar_enPrayerName(String enPrayerName, context) {
  switch (enPrayerName) {
    case "fajr":
      return S.of(context).Fajr;
    case "dhuhr":
      return S.of(context).Dhuhr;
    case "asr":
      return S.of(context).Asr;
    case "maghrib":
      return S.of(context).Maghrib;
    case "isha":
      return S.of(context).Isha;
    default:
      return "";
  }
}

Widget prayerTimeCard(
        DateTime? prayerTime, String prayerName, IconData icon, context) =>
    Column(
      children: [
        Text(
          prayerName,
          style: Constants.headingSmall,
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            color: Colors.white,
            size: 30.sp,
          ),
        ),
        Text(
          DateFormat.jm(S.of(context).Language).format(prayerTime!),
          style: Constants.headingSmall,
        )
      ],
    );
