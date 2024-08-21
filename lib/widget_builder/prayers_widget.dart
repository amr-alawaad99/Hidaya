import 'dart:async';
import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

import '../constants/constants.dart';

class PrayersWidget extends StatefulWidget {
  const PrayersWidget({super.key});

  @override
  State<PrayersWidget> createState() => _PrayersWidgetState();
}

class _PrayersWidgetState extends State<PrayersWidget> {
  late Timer _timer;
  Duration _remainingTime = Duration.zero;
  final _myCoordinates = Coordinates(31.058291, 31.379174); // Replace with your own location lat, lng.
  final _params = CalculationMethod.egyptian.getParameters();
  late final _prayerTimes = PrayerTimes.today(_myCoordinates, _params);
  late DateTime _targetTime;

  @override
  void initState() {
    super.initState();
    _params.madhab = Madhab.shafi;
    _updateRemainingTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _updateRemainingTime();
    });
  }
  void _updateRemainingTime() {
    setState(() {
      DateTime currentTime = DateTime.now();
      _targetTime =  _prayerTimes.timeForPrayer(_prayerTimes.nextPrayer())!;
      _remainingTime = _targetTime.difference(currentTime);
    });
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/images/background.png"),
        fit: BoxFit.cover,
        alignment: Alignment.bottomCenter)
      ),
      padding: EdgeInsets.all(15.sp),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top,),
          Align(alignment: Alignment.topRight,child: Text(HijriCalendar.now().toFormat("dd MMMM yyyy هـ"), style: Constants.headingTitle2,),),
          SizedBox(height: 30.h,),
          Text(arPrayerName(_prayerTimes.nextPrayer().name), style: Constants.headingCaption,),
          Text(DateFormat.jm("ar").format(_prayerTimes.timeForPrayer(_prayerTimes.nextPrayer())!), style: Constants.headingTitle1,),
          Text("متبقي "
              "${_remainingTime.inHours > 0? "${_remainingTime.inHours} ساعة " : ""}"
              "${_remainingTime.inMinutes > 0? "${_remainingTime.inMinutes % 60} دقيقة " : ""}"
              "${_remainingTime.inHours == 0? "${_remainingTime.inSeconds % 60} ثانية " : ""}",
          style: Constants.headingCaption,),
          SizedBox(height: 30.h,),
          Row(
            children: [
              const Spacer(),
              prayerTimeCard(_prayerTimes.isha, "العشاء", TablerIcons.moon),
              const Spacer(),
              prayerTimeCard(_prayerTimes.maghrib, "المغرب", TablerIcons.sunset),
              const Spacer(),
              prayerTimeCard(_prayerTimes.asr, "العصر", TablerIcons.sunset_2),
              const Spacer(),
              prayerTimeCard(_prayerTimes.dhuhr, "الظهر", TablerIcons.sun_filled),
              const Spacer(),
              prayerTimeCard(_prayerTimes.fajr, "الفجر", TablerIcons.sun_moon),
              const Spacer(),
            ],
          ),
          SizedBox(height: 30.h,),
        ],
      ),
    );
  }
}

String arPrayerName(String enPrayerName){
  switch(enPrayerName){
    case "fajr": return "الفجر";
    case "dhuhr": return "الظهر";
    case "asr": return "العصر";
    case "maghrib": return "المغرب";
    case "isha": return "العشاء";
    default: return "";
  }
}

Widget prayerTimeCard(DateTime? prayerTime , String prayerName, IconData icon) => Container(
  child: Column(
    children: [
      Text(prayerName, style: Constants.headingSmall,),
      Padding(
        padding: const EdgeInsets.all(10),
        child: Icon(icon, color: Colors.white, size: 30.sp,),
      ),
      Text(DateFormat.jm("ar").format(prayerTime!), style: Constants.headingSmall,)
    ],
  ),
);


