import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hadith_reminder/constants/constants.dart';
import 'package:hadith_reminder/generated/l10n.dart';
import 'package:hadith_reminder/screens/home_screen.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'cache/cache_helper.dart';

/// I Have not add Geo locator permissions to IOS
///

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper().init();
  await initializeDateFormatting('ar', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Constants.primaryColor,
      statusBarIconBrightness: Brightness.light,
    ));
    return ScreenUtilInit(
      designSize: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height),
      builder: (context, child) => MaterialApp(
        locale: const Locale("ar"),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
