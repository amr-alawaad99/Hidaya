
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../cubit/main_cubit.dart';
import '../model/hadith_model.dart';

class HadithWidget extends StatelessWidget {
  const HadithWidget({super.key});

  static final TextEditingController _jumpToText = TextEditingController();
  static final ItemScrollController _itemScrollController = ItemScrollController();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HadithMapModel?>(
      future: context.read<MainCubit>().getHadith(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                SizedBox(
                  width: 30,
                  height: 20,
                  child: TextFormField(
                    controller: _jumpToText,
                  ),
                ),
                MaterialButton(onPressed: () {
                  _itemScrollController.scrollTo(
                      index: int.parse(_jumpToText.text)-1,
                      duration: Duration(seconds: 2),
                      curve: Curves.easeInOutCubic);
                },
                  child: Icon(Icons.arrow_forward),
                ),
              ],
            ),
            body: ScrollablePositionedList.builder(
              itemScrollController: _itemScrollController,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                  padding: EdgeInsets.all(10.sp),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(15.sp)
                  ),
                  child: Column(
                    children: [
                      /// Hadith Number and Copy Button
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: snapshot.data!.ahadith[index].text!)).then((_) {
                                // Show a snack bar or other notification to indicate success
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Copied to clipboard!'),
                                  ),
                                );
                              });
                            },
                            child: const Icon(Icons.copy),
                          ),
                          const Spacer(),
                          Container(
                            width: 40.sp,
                            height: 40.sp,
                            decoration: BoxDecoration(
                              color: Colors.brown,
                              borderRadius: BorderRadius.circular(25.sp),
                            ),
                            child: Center(child: Text(snapshot.data!.ahadith[index].hadithnumber.toString())),
                          ),
                        ],
                      ),
                      /// Hadith Text
                      Text(snapshot.data!.ahadith[index].text!),
                    ],
                  ),
                ),
              ),
              itemCount: snapshot.data!.ahadith.length,
            ),
          );
        } else if (snapshot.hasError) {
          throw snapshot.error!;
        } else {
          return const Center(child: Text("No Data Available"));
        }
      },
    );
  }
}
