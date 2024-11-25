import 'dart:async';
import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:Hidaya/widget_builder/home_screen_widgets/prayers_notification_widget.dart';
import '../functions/location_manager.dart';
import '../functions/prayer_times_manager.dart';
import '../widget_builder/home_screen_widgets/prayers_time_widget.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late PrayerTimesManager prayerTimesManager;
  late LocationManager locationManager;
  late Timer _timer;
  late DateTime _targetTime;
  Duration _remainingTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    prayerTimesManager = PrayerTimesManager();
    locationManager = LocationManager(context, prayerTimesManager);
    locationManager.checkCurrentLocation();
    locationManager.getCurrentLocation(); // updates your current location on opening the app
    _updateRemainingTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _updateRemainingTime();
    });
  }

  void _updateRemainingTime() {
    setState(() {
      DateTime currentTime = DateTime.now();
      if (prayerTimesManager.prayerTimes.nextPrayer() == Prayer.none) {
        _targetTime = prayerTimesManager.nextDayPrayerTime("fajr")!;
      } else {
        _targetTime = prayerTimesManager.prayerTimes.timeForPrayer(prayerTimesManager.prayerTimes.nextPrayer())!;
      }
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            PrayersTimeWidget(
              prayerTimes: prayerTimesManager.prayerTimes,
              remainingTime: _remainingTime,
              nextFajr: prayerTimesManager.nextDayPrayerTime("fajr")!,
              address: locationManager.address,
              getCurrentLocation: locationManager.getCurrentLocation,
            ),
            PrayersNotificationWidget(
              prayerTime: prayerTimesManager.prayerTimes,
              dateTime: prayerTimesManager.nextDayPrayerTime,
            )
          ],
        ),
      ),
    );
  }
}
