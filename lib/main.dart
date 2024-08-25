import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:hadith_reminder/constants/constants.dart';
import 'package:hadith_reminder/functions/local_notification_service.dart';
import 'package:hadith_reminder/cubit/main_cubit.dart';
import 'package:hadith_reminder/cubit/main_state.dart';
import 'package:hadith_reminder/generated/l10n.dart';
import 'package:hadith_reminder/screens/home_screen.dart';
import 'cache/cache_helper.dart';
import 'constants/bloc_observer.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;





Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  // this method allow all Future methods to run simultaneously
  await Future.wait([
    CacheHelper().init(),
    LocalNotificationService.init(),
  ]);
  tz.initializeTimeZones();
  // Get the local timezone identifier (e.g., 'Africa/Cairo')
  final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
  // Set the timezone location in the timezone package
  tz.setLocalLocation(tz.getLocation(currentTimeZone));



  runApp(BlocProvider(
      create: (context) => MainCubit(),
      child: const MyApp(),
    ),
  );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /// Sets a static color for the status bar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Constants.primaryColor,
      statusBarIconBrightness: Brightness.light,
    ));
    return BlocBuilder<MainCubit, MainState>(
  builder: (context, state) {
    /// ScreenUtilInit for responsive UI
    return ScreenUtilInit(
      designSize: Size(411, 890),
      builder: (context, child) => MaterialApp(
        /// Localization
        locale: Locale(context.read<MainCubit>().localLang),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        debugShowCheckedModeBanner: false,
        /// Theme
        theme: ThemeData(
          colorSchemeSeed: Constants.primaryColor,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  },
);
  }
}
