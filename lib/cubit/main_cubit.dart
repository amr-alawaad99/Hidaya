import 'package:Hidaya/functions/prayer_times_manager.dart';
import 'package:Hidaya/screens/home_screen.dart';
import 'package:Hidaya/screens/qibla_screen.dart';
import 'package:Hidaya/screens/settings_screen.dart';
import 'package:adhan/adhan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Hidaya/cache/cache_helper.dart';
import 'package:Hidaya/functions/local_notification_service.dart';
import 'package:Hidaya/cubit/main_state.dart';

import '../generated/l10n.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitState());

  String localLang = CacheHelper().getDataString(key: "appLang") ??
      "ar"; // If it's the first time opening the app (nothing in cache memory), it will launch in Arabic
  void changeLocalLang() {
    localLang = localLang == "ar" ? "en" : "ar";
    CacheHelper().saveData(key: "appLang", value: localLang);
    emit(ChangeLanguageState());
  }

  Map<String, bool> prayerNotifications = {
    "fajr": CacheHelper().getData(key: "fajr") ?? false,
    "dhuhr": CacheHelper().getData(key: "dhuhr") ?? false,
    "asr": CacheHelper().getData(key: "asr") ?? false,
    "maghrib": CacheHelper().getData(key: "maghrib") ?? false,
    "isha": CacheHelper().getData(key: "isha") ?? false,
  };

  void toggleSwitch({required String prayerName, required bool isOn}) {
    prayerNotifications[prayerName] = isOn;
    CacheHelper().saveData(key: prayerName, value: isOn);
    emit(ToggleSwitchState());
  }

  Future<bool?> requestNotificationPermission() async {
    bool? areEnabled =
        await LocalNotificationService.requestNotificationPermission;
    emit(RequestNotificationPermissionState());
    return areEnabled;
  }

  List<Widget> pages = [
    HomeScreen(),
    QiblaScreen(),
    SettingsScreen(),
  ];
  int currentPage = 0;

  void changeCurrentPage(int currentPage) {
    this.currentPage = currentPage;
    emit(CurrentPageChangedState());
  }

  bool isDarkMode = CacheHelper().getData(key: "isDarkMode") ?? false;
  void switchThemeMode() {
    isDarkMode = !isDarkMode;
    CacheHelper().saveData(key: "isDarkMode", value: isDarkMode);
    emit(SwitchThemeModeState());
  }

  bool isHourlyNotificationsOn =
      CacheHelper().getData(key: "isHourlyNotificationsOn") ?? false;
  void switchHourlyNotifications() {
    isHourlyNotificationsOn = !isHourlyNotificationsOn;
    if (isHourlyNotificationsOn) {
      LocalNotificationService.showPeriodicNotification();
    } else {
      LocalNotificationService.cancelNotification(6);
    }
    CacheHelper().saveData(key: "isHourlyNotificationsOn", value: isHourlyNotificationsOn);
    emit(SwitchHourlyNotificationsState());
  }

  bool isRecommendedSettingsOn = CacheHelper().getData(key: "isRecommendedSettingsOn") ?? true;
  void switchRecommendedSettings() {
    isRecommendedSettingsOn = !isRecommendedSettingsOn;
    CacheHelper().saveData(key: "isRecommendedSettingsOn", value: isRecommendedSettingsOn);
    emit(SwitchRecommendedSettingsState());
  }

  // Returns a map of calculation methods and their labels
  Map<String, String> calculationMethodMap(BuildContext context) => {
    CalculationMethod.egyptian.name: S.of(context).EgyptianGeneralAuthorityOfSurvey,
    CalculationMethod.muslim_world_league.name: S.of(context).MuslimWorldLeague,
    CalculationMethod.karachi.name: S.of(context).UniversityOfIslamicSciencesKarachi,
    CalculationMethod.umm_al_qura.name: S.of(context).UmmAlQuraUniversityMakkah,
    CalculationMethod.qatar.name: S.of(context).Qatar,
    CalculationMethod.kuwait.name: S.of(context).Kuwait,
    CalculationMethod.moon_sighting_committee.name: S.of(context).MoonsightingCommittee,
    CalculationMethod.singapore.name: S.of(context).Singapore,
    CalculationMethod.north_america.name: S.of(context).IslamicSocietyOfNorthAmerica,
    CalculationMethod.turkey.name: S.of(context).Turkey,
    CalculationMethod.tehran.name: S.of(context).Tehran,
    CalculationMethod.dubai.name: S.of(context).UAE,
  };

  // Initial method for prayer calculation
  CalculationMethod initialMethod = PrayerTimesManager().params.method;

  // Change the calculation method and store it
  void changeCalculationMethod(CalculationMethod method) {
    initialMethod = method;
    CacheHelper().saveData(key: "CalculationMethod", value: method.name);
    emit(ChangeCalculationMethodState());
  }

  // Initial method for prayer madhab
  Madhab initialMadhab = PrayerTimesManager().params.madhab;

  // Change the calculation method and store it
  void changeMadhab(Madhab madhab) {
    initialMadhab = madhab;
    CacheHelper().saveData(key: "Madhab", value: madhab.name);
    emit(ChangeMadhabState());
  }


}
