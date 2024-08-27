import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Hidaya/constants/constants.dart';
import 'package:Hidaya/functions/local_notification_service.dart';
import 'package:Hidaya/cubit/main_cubit.dart';
import 'package:Hidaya/cubit/main_state.dart';
import 'package:Hidaya/functions/work_manager_service.dart';
import 'package:Hidaya/generated/l10n.dart';
import 'package:Hidaya/screens/home_screen.dart';
import 'cache/cache_helper.dart';
import 'constants/bloc_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Sets a static color for the status bar
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Constants.primaryColor,
    statusBarIconBrightness: Brightness.light,
  ));
  // this method allow all Future methods to run simultaneously
  await Future.wait([
    CacheHelper().init(),
    LocalNotificationService.init(),
    WorkManagerService().init(),
  ]);

  Bloc.observer = MyBlocObserver();

  bool isPeriodicNotificationOn =
      CacheHelper().getData(key: "periodicNotification") ?? false;
  if (!isPeriodicNotificationOn) {
    LocalNotificationService.showPeriodicNotification();
  }

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    /// ScreenUtilInit for responsive UI
    return ScreenUtilInit(
      designSize: Size(411, 890),
      minTextAdapt: true,
      splitScreenMode: true,
      child: BlocProvider(
        create: (context) => MainCubit(),
        child: BlocBuilder<MainCubit, MainState>(
          builder: (context, state) {
            return MaterialApp(
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
            );
          },
        ),
      ),
    );
  }
}
