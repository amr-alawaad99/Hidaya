import 'dart:async';
import 'dart:ui';
import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hadith_reminder/widget_builder/home_screen_widgets/prayers_notification_widget.dart';
import '../cache/cache_helper.dart';
import '../generated/l10n.dart';
import '../widget_builder/home_screen_widgets/prayers_time_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  late Timer _timer;
  Duration _remainingTime = Duration.zero;
  double? lat = CacheHelper().getData(key: "lat");
  double? long = CacheHelper().getData(key: "long");
  late Coordinates _myCoordinates = Coordinates(lat?? 30.033333,long?? 31.233334); // Replace with your own location lat, lng.
  final _params = CalculationMethod.egyptian.getParameters();
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
        _address = "${place.administrativeArea}, ${place.country}";
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              PrayersTimeWidget(prayerTimes: _prayerTimes, remainingTime: _remainingTime, nextFajr: _nextFajr, address: _address, getCurrentLocation: _getCurrentLocation,),
              PrayersNotificationWidget(prayerTime: _prayerTimes)
            ],
          ),
        ),
      ),
    );
  }
}
