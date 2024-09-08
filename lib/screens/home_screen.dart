import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:Hidaya/widget_builder/home_screen_widgets/prayers_notification_widget.dart';
import '../cache/cache_helper.dart';
import '../generated/l10n.dart';
import '../widget_builder/home_screen_widgets/prayers_time_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {


  late Timer _timer;
  late DateTime _targetTime;
  Duration _remainingTime = Duration.zero;
  double? lat = CacheHelper().getData(key: "lat");
  double? long = CacheHelper().getData(key: "long");
  late Coordinates _myCoordinates = Coordinates(lat?? 30.033333,long?? 31.233334); // Replace with your own location lat, lng.
  final _params = CalculationMethod.egyptian.getParameters();
  late  PrayerTimes _prayerTimes = PrayerTimes.today(_myCoordinates, _params);
  // getting next day date/time (midnight time 00:00) to use it for getting next day prayers time
  final DateTime nextDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day+1);
  DateTime? nextDayPrayerTime(String prayer){
    switch(prayer){
      case "fajr": return PrayerTimes(_myCoordinates, DateComponents(nextDay.year, nextDay.month, nextDay.day), _params).fajr;
      case "dhuhr": return PrayerTimes(_myCoordinates, DateComponents(nextDay.year, nextDay.month, nextDay.day), _params).dhuhr;
      case "asr": return PrayerTimes(_myCoordinates, DateComponents(nextDay.year, nextDay.month, nextDay.day), _params).asr;
      case "maghrib": return PrayerTimes(_myCoordinates, DateComponents(nextDay.year, nextDay.month, nextDay.day), _params).maghrib;
      case "isha": return PrayerTimes(_myCoordinates, DateComponents(nextDay.year, nextDay.month, nextDay.day), _params).isha;
      default: return null;
    }
  }
  DateTime? prayerTime(String prayer){
    switch(prayer){
      case "fajr": return _prayerTimes.fajr;
      case "dhuhr": return _prayerTimes.dhuhr;
      case "asr": return _prayerTimes.asr;
      case "maghrib": return _prayerTimes.maghrib;
      case "isha": return _prayerTimes.isha;
      default: return null;
    }
  }

  @override
  void initState() {
    super.initState();
    // The madhab used to calculate Asr time
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
      // if isha was the last prayer, next prayer will be Prayer.non until next day starts (midnight).
      // here we handle that
      if(_prayerTimes.nextPrayer() == Prayer.none){
        _targetTime =  nextDayPrayerTime("fajr")!;
      } else {
        _targetTime =  _prayerTimes.timeForPrayer(_prayerTimes.nextPrayer())!;
      }
      _remainingTime = _targetTime.difference(currentTime);
    });
  }


  // local attribute returns your device language
  final String locale = PlatformDispatcher.instance.locales.first.languageCode;
  late String _address = locale == "ar"? "القاهرة, مصر" : "Cairo, Egypt";
  List<Placemark>? placeMarks = [];
  Placemark? place;

  Future<void> _checkCurrentLocation() async {
    if(lat == null){
      _getCurrentLocation();
    } else {
      List<Placemark> placeMarks = await placemarkFromCoordinates(
        lat!,
        long!,
      );
      Placemark place = placeMarks[0];
      setState(() {
        _address = "${place.locality}, ${place.administrativeArea}, ${place.isoCountryCode}";
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).LocationDisabled)));
      });
      return;
    }

    // Request location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, handle appropriately
        log('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).PermissionDeniedMessage)));
      log('Location permissions are permanently denied');
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

    Placemark place = placeMarks.first;

    setState(() {
      _address = "${place.locality}, ${place.administrativeArea}, ${place.isoCountryCode}";
    });




  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            PrayersTimeWidget(prayerTimes: _prayerTimes, remainingTime: _remainingTime, nextFajr: nextDayPrayerTime("fajr")!, address: _address, getCurrentLocation: _getCurrentLocation,),
            PrayersNotificationWidget(prayerTime: _prayerTimes, dateTime: nextDayPrayerTime,)
          ],
        ),
      ),
    );
  }
}
