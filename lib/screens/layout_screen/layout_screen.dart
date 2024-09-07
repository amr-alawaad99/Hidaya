import 'package:Hidaya/constants/bloc_observer.dart';
import 'package:Hidaya/cubit/main_cubit.dart';
import 'package:Hidaya/cubit/main_state.dart';
import 'package:Hidaya/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import '../../generated/l10n.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
  builder: (context, state) {
    return Scaffold(
      body: context.read<MainCubit>().pages[context.read<MainCubit>().currentPage],
      bottomNavigationBar: NavigationBar(
        selectedIndex: context.read<MainCubit>().currentPage,
        height: 80.h,
        onDestinationSelected: (value) {
          context.read<MainCubit>().changeCurrentPage(value);
        },
        destinations: [
          NavigationDestination(
            icon: Icon(TablerIcons.home),
            label: S.of(context).Home,
          ),
          NavigationDestination(
            icon: Icon(TablerIcons.compass),
            label: S.of(context).Qibla,
          ),
          NavigationDestination(
            icon: Icon(TablerIcons.settings),
            label: S.of(context).Settings,
          ),
        ],
      ),
    );
  },
);
  }
}
