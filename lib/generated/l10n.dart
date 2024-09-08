// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `en`
  String get Language {
    return Intl.message(
      'en',
      name: 'Language',
      desc: '',
      args: [],
    );
  }

  /// `H`
  String get Hijri {
    return Intl.message(
      'H',
      name: 'Hijri',
      desc: '',
      args: [],
    );
  }

  /// `Fajr`
  String get Fajr {
    return Intl.message(
      'Fajr',
      name: 'Fajr',
      desc: '',
      args: [],
    );
  }

  /// `Sunrise`
  String get Sunrise {
    return Intl.message(
      'Sunrise',
      name: 'Sunrise',
      desc: '',
      args: [],
    );
  }

  /// `Dhuhr`
  String get Dhuhr {
    return Intl.message(
      'Dhuhr',
      name: 'Dhuhr',
      desc: '',
      args: [],
    );
  }

  /// `Asr`
  String get Asr {
    return Intl.message(
      'Asr',
      name: 'Asr',
      desc: '',
      args: [],
    );
  }

  /// `Maghrib`
  String get Maghrib {
    return Intl.message(
      'Maghrib',
      name: 'Maghrib',
      desc: '',
      args: [],
    );
  }

  /// `Isha`
  String get Isha {
    return Intl.message(
      'Isha',
      name: 'Isha',
      desc: '',
      args: [],
    );
  }

  /// `Time left`
  String get TimeLeft {
    return Intl.message(
      'Time left',
      name: 'TimeLeft',
      desc: '',
      args: [],
    );
  }

  /// `Hour`
  String get Hour {
    return Intl.message(
      'Hour',
      name: 'Hour',
      desc: '',
      args: [],
    );
  }

  /// `Minute`
  String get Minute {
    return Intl.message(
      'Minute',
      name: 'Minute',
      desc: '',
      args: [],
    );
  }

  /// `Second`
  String get Second {
    return Intl.message(
      'Second',
      name: 'Second',
      desc: '',
      args: [],
    );
  }

  /// `Location permissions are denied, please allow location access from the app settings.`
  String get PermissionDeniedMessage {
    return Intl.message(
      'Location permissions are denied, please allow location access from the app settings.',
      name: 'PermissionDeniedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Location services are disabled.`
  String get LocationDisabled {
    return Intl.message(
      'Location services are disabled.',
      name: 'LocationDisabled',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get PrayerNotification {
    return Intl.message(
      'Notifications',
      name: 'PrayerNotification',
      desc: '',
      args: [],
    );
  }

  /// `Notifications permission is denied, please allow Notifications from the app settings.`
  String get NotificationsDisabled {
    return Intl.message(
      'Notifications permission is denied, please allow Notifications from the app settings.',
      name: 'NotificationsDisabled',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get Home {
    return Intl.message(
      'Home',
      name: 'Home',
      desc: '',
      args: [],
    );
  }

  /// `Qibla`
  String get Qibla {
    return Intl.message(
      'Qibla',
      name: 'Qibla',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get Settings {
    return Intl.message(
      'Settings',
      name: 'Settings',
      desc: '',
      args: [],
    );
  }

  /// `DarkMode`
  String get DarkMode {
    return Intl.message(
      'DarkMode',
      name: 'DarkMode',
      desc: '',
      args: [],
    );
  }

  /// `Hourly Notifications`
  String get HourlyNotification {
    return Intl.message(
      'Hourly Notifications',
      name: 'HourlyNotification',
      desc: '',
      args: [],
    );
  }

  /// `Calculation method`
  String get CalculationMethod {
    return Intl.message(
      'Calculation method',
      name: 'CalculationMethod',
      desc: '',
      args: [],
    );
  }

  /// `Egyptian General Authority of Survey`
  String get EgyptianGeneralAuthorityOfSurvey {
    return Intl.message(
      'Egyptian General Authority of Survey',
      name: 'EgyptianGeneralAuthorityOfSurvey',
      desc: '',
      args: [],
    );
  }

  /// `Muslim World League`
  String get MuslimWorldLeague {
    return Intl.message(
      'Muslim World League',
      name: 'MuslimWorldLeague',
      desc: '',
      args: [],
    );
  }

  /// `University of Islamic Sciences, Karachi`
  String get UniversityOfIslamicSciencesKarachi {
    return Intl.message(
      'University of Islamic Sciences, Karachi',
      name: 'UniversityOfIslamicSciencesKarachi',
      desc: '',
      args: [],
    );
  }

  /// `Umm al-Qura University, Makkah`
  String get UmmAlQuraUniversityMakkah {
    return Intl.message(
      'Umm al-Qura University, Makkah',
      name: 'UmmAlQuraUniversityMakkah',
      desc: '',
      args: [],
    );
  }

  /// `UAE`
  String get UAE {
    return Intl.message(
      'UAE',
      name: 'UAE',
      desc: '',
      args: [],
    );
  }

  /// `Qatar`
  String get Qatar {
    return Intl.message(
      'Qatar',
      name: 'Qatar',
      desc: '',
      args: [],
    );
  }

  /// `Kuwait`
  String get Kuwait {
    return Intl.message(
      'Kuwait',
      name: 'Kuwait',
      desc: '',
      args: [],
    );
  }

  /// `Moonsighting Committee`
  String get MoonsightingCommittee {
    return Intl.message(
      'Moonsighting Committee',
      name: 'MoonsightingCommittee',
      desc: '',
      args: [],
    );
  }

  /// `Singapore`
  String get Singapore {
    return Intl.message(
      'Singapore',
      name: 'Singapore',
      desc: '',
      args: [],
    );
  }

  /// `Islamic Society of North America`
  String get IslamicSocietyOfNorthAmerica {
    return Intl.message(
      'Islamic Society of North America',
      name: 'IslamicSocietyOfNorthAmerica',
      desc: '',
      args: [],
    );
  }

  /// `Turkey`
  String get Turkey {
    return Intl.message(
      'Turkey',
      name: 'Turkey',
      desc: '',
      args: [],
    );
  }

  /// `Tehran`
  String get Tehran {
    return Intl.message(
      'Tehran',
      name: 'Tehran',
      desc: '',
      args: [],
    );
  }

  /// `Asr method`
  String get AsrMethod {
    return Intl.message(
      'Asr method',
      name: 'AsrMethod',
      desc: '',
      args: [],
    );
  }

  /// `Shafi`
  String get Shafi {
    return Intl.message(
      'Shafi',
      name: 'Shafi',
      desc: '',
      args: [],
    );
  }

  /// `Hanafi`
  String get Hanafi {
    return Intl.message(
      'Hanafi',
      name: 'Hanafi',
      desc: '',
      args: [],
    );
  }

  /// `Recommended settings`
  String get RecommendedSettings {
    return Intl.message(
      'Recommended settings',
      name: 'RecommendedSettings',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
