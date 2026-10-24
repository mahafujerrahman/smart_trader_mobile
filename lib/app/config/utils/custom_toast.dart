import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:smart_trader_mobile/app/config/utils/app_colors.dart';

class AppCustomToast {
  // Bottom toast
  static void showCustomToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      textColor: Colors.white,
      backgroundColor: AppColors.primaryColor,
    );
  }

  // Bottom toast
  static void errorShowCustomToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      textColor: Colors.white,
      backgroundColor: AppColors.redColor,
    );
  }

  // Centered toast
  static void statusToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.CENTER,
      textColor: Colors.white,
      backgroundColor: AppColors.primaryColor,
    );
  }

  // Snackbar (iPhone style)
  static void showIphoneSnackbar(String title, String message, int seconds) {
    Get.snackbar(title, message, duration: Duration(seconds: seconds));
  }
}
