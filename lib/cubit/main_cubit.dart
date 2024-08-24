import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith_reminder/cache/cache_helper.dart';
import 'package:hadith_reminder/cubit/main_state.dart';
import 'package:hadith_reminder/model/hadith_model.dart';

class MainCubit extends Cubit<MainState> {

  MainCubit() : super(MainInitState());

  HadithMapModel? hadithMapModel;
  Future<HadithMapModel?> getHadith() async {

    final String response = await rootBundle.loadString('assets/local_apis/ara-bukhari.json');
    hadithMapModel = HadithMapModel.fromJson(jsonDecode(response));
    return hadithMapModel;
  }

  String localLang = CacheHelper().getDataString(key: "appLang")?? "ar"; // If it's the first time opening the app (nothing in cache memory), it will launch in Arabic
  void changeLocalLang(){
    localLang = localLang == "ar"? "en" : "ar";
    CacheHelper().saveData(key: "appLang", value: localLang);
    emit(ChangeLanguageState());
  }


}