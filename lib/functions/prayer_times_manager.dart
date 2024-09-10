import 'package:adhan/adhan.dart';
import '../cache/cache_helper.dart';

class PrayerTimesManager {
  late Coordinates myCoordinates;
  late CalculationParameters params;
  late PrayerTimes prayerTimes;
  final DateTime nextDay = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
  double? lat = CacheHelper().getData(key: "lat");
  double? long = CacheHelper().getData(key: "long");
  Map calculationMethodsMap = {
    CalculationMethod.egyptian.name: CalculationMethod.egyptian.getParameters(),
    CalculationMethod.muslim_world_league.name:
        CalculationMethod.muslim_world_league.getParameters(),
    CalculationMethod.karachi.name: CalculationMethod.karachi.getParameters(),
    CalculationMethod.umm_al_qura.name:
        CalculationMethod.umm_al_qura.getParameters(),
    CalculationMethod.qatar.name: CalculationMethod.qatar.getParameters(),
    CalculationMethod.kuwait.name: CalculationMethod.kuwait.getParameters(),
    CalculationMethod.moon_sighting_committee.name:
        CalculationMethod.moon_sighting_committee.getParameters(),
    CalculationMethod.singapore.name:
        CalculationMethod.singapore.getParameters(),
    CalculationMethod.north_america.name:
        CalculationMethod.north_america.getParameters(),
    CalculationMethod.turkey.name: CalculationMethod.turkey.getParameters(),
    CalculationMethod.tehran.name: CalculationMethod.tehran.getParameters(),
    CalculationMethod.dubai.name: CalculationMethod.dubai.getParameters(),
  };
  Map madhabMap = {
    Madhab.shafi.name: Madhab.shafi,
    Madhab.hanafi.name: Madhab.hanafi,
  };
  PrayerTimesManager() {
    myCoordinates = Coordinates(lat ?? 30.033333, long ?? 31.233334);
    if (CacheHelper().getData(key: "isRecommendedSettingsOn") ?? true) {
      params = getCalculationMethodParameters();
    } else if (CacheHelper().getData(key: "CalculationMethod") != null) {
      params = calculationMethodsMap[CacheHelper().getData(key: "CalculationMethod")];
    } else {
      params = getCalculationMethodParameters();
    }
    if (CacheHelper().getData(key: "isRecommendedSettingsOn") ?? true) {
      params.madhab = Madhab.shafi; // Default madhab
    } else if (CacheHelper().getData(key: "Madhab") != null) {
      params.madhab = madhabMap[CacheHelper().getData(key: "Madhab")];
    } else {
      params.madhab = Madhab.shafi; // Default madhab
    }
    prayerTimes = PrayerTimes.today(myCoordinates, params);
  }

  static String get myCountry =>
      CacheHelper().getData(key: "CountryName") ?? "Egypt";

  static CalculationParameters getCalculationMethodParameters() {
    switch (myCountry) {
      case 'Egypt':
        return CalculationMethod.egyptian.getParameters();
      case 'Saudi Arabia':
        return CalculationMethod.umm_al_qura.getParameters();
      case 'Pakistan':
        return CalculationMethod.karachi.getParameters();
      case 'United States':
      case 'Canada':
        return CalculationMethod.north_america.getParameters();
      case 'Turkey':
        return CalculationMethod.turkey.getParameters();
      case 'United Arab Emirates':
        return CalculationMethod.dubai.getParameters();
      case 'Qatar':
        return CalculationMethod.qatar.getParameters();
      case 'Kuwait':
        return CalculationMethod.kuwait.getParameters();
      case 'Singapore':
        return CalculationMethod.singapore.getParameters();
      case 'Iran':
      case 'Tehran':
        return CalculationMethod.tehran.getParameters();
      case 'Malaysia':
      case 'Indonesia':
      case 'Brunei':
        return CalculationMethod.moon_sighting_committee.getParameters();
      default:
        return CalculationMethod.muslim_world_league.getParameters();
    }
  }

  DateTime? prayerTime(String prayer) {
    switch (prayer) {
      case "fajr":
        return prayerTimes.fajr;
      case "dhuhr":
        return prayerTimes.dhuhr;
      case "asr":
        return prayerTimes.asr;
      case "maghrib":
        return prayerTimes.maghrib;
      case "isha":
        return prayerTimes.isha;
      default:
        return null;
    }
  }

  DateTime? nextDayPrayerTime(String prayer) {
    switch (prayer) {
      case "fajr":
        return PrayerTimes(
                myCoordinates,
                DateComponents(nextDay.year, nextDay.month, nextDay.day),
                params)
            .fajr;
      case "dhuhr":
        return PrayerTimes(
                myCoordinates,
                DateComponents(nextDay.year, nextDay.month, nextDay.day),
                params)
            .dhuhr;
      case "asr":
        return PrayerTimes(
                myCoordinates,
                DateComponents(nextDay.year, nextDay.month, nextDay.day),
                params)
            .asr;
      case "maghrib":
        return PrayerTimes(
                myCoordinates,
                DateComponents(nextDay.year, nextDay.month, nextDay.day),
                params)
            .maghrib;
      case "isha":
        return PrayerTimes(
                myCoordinates,
                DateComponents(nextDay.year, nextDay.month, nextDay.day),
                params)
            .isha;
      default:
        return null;
    }
  }

  /// **Update prayer times when the location changes**
  void updateCoordinates(Coordinates newCoordinates) {
    if(CacheHelper().getData(key: "isRecommendedSettingsOn")?? true){
      params = getCalculationMethodParameters();
    }
    myCoordinates = newCoordinates;
    prayerTimes = PrayerTimes.today(myCoordinates,
        params); // **Recalculate prayer times based on the new location**
  }
}
