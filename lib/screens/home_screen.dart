import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hadith_reminder/constants/constants.dart';
import 'package:hadith_reminder/cubit/main_cubit.dart';
import 'package:hadith_reminder/cubit/main_state.dart';
import 'package:hadith_reminder/widget_builder/prayers_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainCubit(),
      child: BlocConsumer<MainCubit, MainState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const PrayersWidget(),
                    Container(
                      height: 2000.h,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                      ),
                      // Add other widgets here if needed
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
