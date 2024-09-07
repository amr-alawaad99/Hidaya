import 'package:Hidaya/constants/bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../cubit/main_cubit.dart';
import '../generated/l10n.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(15.sp),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(TablerIcons.moon_filled, color: Colors.amber, size: 35.sp,),
                  SizedBox(width: 10.w,),
                  Text(S.of(context).DarkMode, style: Theme.of(context).textTheme.bodySmall,),
                  Spacer(),
                  Switch(
                    value: context.read<MainCubit>().isDarkMode,
                    onChanged: (value) {
                      context.read<MainCubit>().switchThemeMode();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
