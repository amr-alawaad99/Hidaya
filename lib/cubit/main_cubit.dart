import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Hidaya/cache/cache_helper.dart';
import 'package:Hidaya/functions/local_notification_service.dart';
import 'package:Hidaya/cubit/main_state.dart';

class MainCubit extends Cubit<MainState> {

  MainCubit() : super(MainInitState());


  String localLang = CacheHelper().getDataString(key: "appLang")?? "ar"; // If it's the first time opening the app (nothing in cache memory), it will launch in Arabic
  void changeLocalLang(){
    localLang = localLang == "ar"? "en" : "ar";
    CacheHelper().saveData(key: "appLang", value: localLang);
    emit(ChangeLanguageState());
  }

  Map<String, bool> prayerNotifications = {
    "fajr": CacheHelper().getData(key: "fajr")?? false,
    "dhuhr": CacheHelper().getData(key: "dhuhr")?? false,
    "asr": CacheHelper().getData(key: "asr")?? false,
    "maghrib": CacheHelper().getData(key: "maghrib")?? false,
    "isha": CacheHelper().getData(key: "isha")?? false,
  };
  void toggleSwitch({required String prayerName, required bool isOn}) {
    prayerNotifications[prayerName] = isOn;
    CacheHelper().saveData(key: prayerName, value: isOn);
    emit(ToggleSwitchState());
  }

  Future<bool?> requestNotificationPermission () async {
    bool? areEnabled = await LocalNotificationService.requestNotificationPermission;
    emit(RequestNotificationPermissionState());
    return areEnabled;
  }

}