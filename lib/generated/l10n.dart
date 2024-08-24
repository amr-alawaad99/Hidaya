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

  /// `Location permissions are denied, please allow location access from the app settings`
  String get PermissionDeniedMessage {
    return Intl.message(
      'Location permissions are denied, please allow location access from the app settings',
      name: 'PermissionDeniedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Notification`
  String get PrayerNotification {
    return Intl.message(
      'Notification',
      name: 'PrayerNotification',
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
