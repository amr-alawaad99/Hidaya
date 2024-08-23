import 'dart:async';
import 'dart:ui';
import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hadith_reminder/cache/cache_helper.dart';
import 'package:hadith_reminder/cubit/main_cubit.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import '../constants/constants.dart';
import '../generated/l10n.dart';

class PrayersWidget extends StatefulWidget {
  const PrayersWidget({super.key});

  @override
  State<PrayersWidget> createState() => _PrayersWidgetState();
}

class _PrayersWidgetState extends State<PrayersWidget> {
  late Timer _timer;
  Duration _remainingTime = Duration.zero;
  double? lat = CacheHelper().getData(key: "lat");
  double? long = CacheHelper().getData(key: "long");
  late Coordinates _myCoordinates = Coordinates(lat?? 30.033333,long?? 31.233334); // Replace with your own location lat, lng.
  final _params = CalculationMethod.north_america.getParameters();
  late  PrayerTimes _prayerTimes = PrayerTimes.today(_myCoordinates, _params);
  late DateTime _targetTime;
  final DateTime nextDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day+1);
  late final DateTime _nextFajr = PrayerTimes(_myCoordinates, DateComponents(nextDay.year, nextDay.month, nextDay.day), _params).fajr;

  @override
  void initState() {
    super.initState();
    _params.madhab = Madhab.shafi;
    _checkCurrentLocation();
    _updateRemainingTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _updateRemainingTime();
    });
  }
  void _updateRemainingTime() {
    setState(() {
      DateTime currentTime = DateTime.now();
      if(_prayerTimes.nextPrayer() == Prayer.none){
        _targetTime =  _nextFajr;
      } else {
        _targetTime =  _prayerTimes.timeForPrayer(_prayerTimes.nextPrayer())!;
      }
      _remainingTime = _targetTime.difference(currentTime);
    });
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }


  final String locale = PlatformDispatcher.instance.locales.first.languageCode;
  late String _address = locale == "ar"? "القاهرة - مصر" : "Cairo - Egypt";
  List<Placemark>? placeMarks = [];

  Placemark? place;
  Future<void> _checkCurrentLocation() async {
    if(lat == null){
      _getCurrentLocation();
    } else {
      print("$lat , $long");
      List<Placemark> placeMarks = await placemarkFromCoordinates(
        lat!,
        long!,
      );
      Placemark place = placeMarks[0];
      setState(() {
        _address = "${place.locality}, ${place.administrativeArea}";
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, handle appropriately
      setState(() {
        _address = 'Location services are disabled.';
      });
      return;
    }

    // Request location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, handle appropriately
        print('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).PermissionDeniedMessage)));
      print('Location permissions are permanently denied');
      return;
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition();

    //Save position in cache memory
    CacheHelper().saveData(key: "lat", value: position.latitude);
    CacheHelper().saveData(key: "long", value: position.longitude);
    setState(() {
      lat = CacheHelper().getData(key: "lat");
      long = CacheHelper().getData(key: "long");
      _myCoordinates = Coordinates(lat!, long!);
      _prayerTimes = PrayerTimes.today(_myCoordinates, _params);
    });

    // Get address from the coordinates
    List<Placemark> placeMarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    Placemark place = placeMarks[0];

    setState(() {
      _address = "${place.administrativeArea}, ${place.country}";
    });
  }



  @override
  Widget build(BuildContext context) {
    HijriCalendar.setLocal(S.of(context).DateLang);
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/images/background.png"),
        fit: BoxFit.cover,
        alignment: Alignment.bottomCenter),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      padding: EdgeInsets.all(15.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top,),
          Row(
            children: [
              Expanded(child: Text(HijriCalendar.now().toFormat("dd MMMM yyyy ${S.of(context).Hijri}"), style: Constants.headingTitle2,)),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    print(context.read<MainCubit>().localLang);
                    context.read<MainCubit>().changeLocalLang();
                  });
                },
                child: Text(S.of(context).DateLang.toUpperCase()),
              ),
            ],
          ),
          SizedBox(height: 0.h,),
          /// Address
          Row(
            children: [
              /// Address
              SizedBox(
                width: 200,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Text(_address, style: Constants.headingCaption,),
                ),
              ),
              SizedBox(width: 10.w,),
              /// reload address button
              GestureDetector(
                onTap: () {
                  _getCurrentLocation();
                  },
                child: Icon(TablerIcons.repeat, color: Colors.white, size: 15.sp,),
              ),
            ],
          ),
          SizedBox(height: 30.h,),
          /// Next prayer, it's time, and how much time left
          Center(
            child: Column(
              children: [
                Text(arPrayerName(_prayerTimes.nextPrayer().name == Prayer.none.name? Prayer.fajr.name : _prayerTimes.nextPrayer().name, context), style: Constants.headingCaption,),
                Text(DateFormat.jm(S.of(context).DateLang).format(_prayerTimes.timeForPrayer(_prayerTimes.nextPrayer())?? _nextFajr), style: Constants.headingTitle1,),
                Text("${S.of(context).TimeLeft} "
                    "${_remainingTime.inHours > 0? "${_remainingTime.inHours} ${S.of(context).Hour}${_remainingTime.inHours > 1 && S.of(context).DateLang == "en"? 's':''} " : ""}"
                    "${_remainingTime.inMinutes > 0? "${_remainingTime.inMinutes % 60} ${S.of(context).Minute}${_remainingTime.inMinutes > 1 && S.of(context).DateLang == "en"? 's':''} " : ""}"
                    "${_remainingTime.inHours == 0? "${_remainingTime.inSeconds % 60} ${S.of(context).Second}${_remainingTime.inSeconds > 1 && S.of(context).DateLang == "en"? 's':''} " : ""}",
                  style: Constants.headingCaption,),
              ],
            ),
          ),
          SizedBox(height: 30.h,),
          /// Each prayer name, icon, and time
          Row(
            children: [
              const Spacer(),
              prayerTimeCard(_prayerTimes.fajr, S.of(context).Fajr, TablerIcons.sun_moon, context),
              const Spacer(),
              prayerTimeCard(_prayerTimes.dhuhr, S.of(context).Dhuhr, TablerIcons.sun_filled, context),
              const Spacer(),
              prayerTimeCard(_prayerTimes.asr, S.of(context).Asr, TablerIcons.sunset_2, context),
              const Spacer(),
              prayerTimeCard(_prayerTimes.maghrib, S.of(context).Maghrib, TablerIcons.sunset, context),
              const Spacer(),
              prayerTimeCard(_prayerTimes.isha, S.of(context).Isha, TablerIcons.moon, context),
              const Spacer(),
            ],
          ),
          SizedBox(height: 30.h,),
        ],
      ),
    );
  }
}

String arPrayerName(String enPrayerName, context){
  switch(enPrayerName){
    case "fajr": return S.of(context).Fajr;
    case "dhuhr": return S.of(context).Dhuhr;
    case "asr": return S.of(context).Asr;
    case "maghrib": return S.of(context).Maghrib;
    case "isha": return S.of(context).Isha;
    default: return "";
  }
}

Widget prayerTimeCard(DateTime? prayerTime , String prayerName, IconData icon, context) => Column(
  children: [
    Text(prayerName, style: Constants.headingSmall,),
    Padding(
      padding: const EdgeInsets.all(10),
      child: Icon(icon, color: Colors.white, size: 30.sp,),
    ),
    Text(DateFormat.jm(S.of(context).DateLang).format(prayerTime!), style: Constants.headingSmall,)
  ],
);


