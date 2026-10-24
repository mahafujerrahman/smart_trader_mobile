import 'dart:convert';
import 'package:smart_trader_mobile/app/config/utils/app_constants.dart';
import 'package:smart_trader_mobile/app/helpers/localization_controller.dart';
import 'package:smart_trader_mobile/app/helpers/theme_controller.dart';
import 'package:smart_trader_mobile/common_model/language_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_trader_mobile/app/helpers/theme_controller.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);

  // Repository
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find()));


  //Retrieving localized data
  Map<String, Map<String, String>> _languages = Map();

  for (LanguageModel languageModel in AppConstants.languages) {
    try {
      String jsonStringValues = await rootBundle.loadString('assets/language/${languageModel.languageCode}.json');
      Map<String, dynamic> _mappedJson = json.decode(jsonStringValues);
      Map<String, String> _json = {};
      _mappedJson.forEach((key, value) {
        _json[key] = value.toString();
      });
      _languages['${languageModel.languageCode}_${languageModel.countryCode}'] = _json;
    }
    catch (e) {
      print('Error loading language file for ${languageModel.languageCode}: $e');
    }
  }
  return _languages;
}
