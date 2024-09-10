import 'dart:developer';
import 'package:Hidaya/functions/prayer_times_manager.dart';
import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../cache/cache_helper.dart';
import '../generated/l10n.dart';

class LocationManager {
  final BuildContext context;
  double? lat = CacheHelper().getData(key: "lat");
  double? long = CacheHelper().getData(key: "long");
  String address = "Cairo, Egypt";
  List<Placemark>? placeMarks = [];
  Placemark? place;
  final PrayerTimesManager prayerTimesManager;

  LocationManager(this.context, this.prayerTimesManager) {
    address = CacheHelper().getData(key: "address")?? "Cairo, Egypt";
  }

  Future<void> checkCurrentLocation() async {
    if (lat == null) {
      await getCurrentLocation();
    } else {
      await updateAddressFromCoordinates(lat!, long!);
      // prayerTimesManager.updateCoordinates(Coordinates(lat!, long!));  // **Update prayer times after location update**
    }
  }

  Future<void> updateAddressFromCoordinates(double latitude, double longitude) async {
    placeMarks = await placemarkFromCoordinates(latitude, longitude);
    place = placeMarks?[0];
    if (place != null) {
      address = "${place!.locality}, ${place!.administrativeArea}, ${place!.isoCountryCode}";
      CacheHelper().saveData(key: "address", value: address);
      CacheHelper().saveData(key: "CountryName", value: place!.country);
    }
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showSnackBar(S.of(context).LocationDisabled);
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
      showSnackBar(S.of(context).PermissionDeniedMessage);
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    CacheHelper().saveData(key: "lat", value: position.latitude);
    CacheHelper().saveData(key: "long", value: position.longitude);
    lat = position.latitude;
    long = position.longitude;
    PrayerTimesManager().myCoordinates = Coordinates(lat!, long!);
    PrayerTimesManager().prayerTimes = PrayerTimes.today(PrayerTimesManager().myCoordinates, PrayerTimesManager().params);
    await updateAddressFromCoordinates(lat!, long!);
    prayerTimesManager.updateCoordinates(Coordinates(lat!, long!));  // **Recalculate prayer times with new coordinates**

  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
