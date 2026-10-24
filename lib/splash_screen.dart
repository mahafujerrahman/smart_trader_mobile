import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:smart_trader_mobile/app/config/utils/app_colors.dart';
import 'package:smart_trader_mobile/app/config/utils/app_images.dart';
import 'package:smart_trader_mobile/app/config/utils/style.dart';
import 'package:smart_trader_mobile/app/core/base/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:smart_trader_mobile/app/core/routes/routes.dart';
import 'app/config/utils/app_constants.dart';

import 'app/helpers/prefs_helpers.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StreamSubscription? streamSubscription;
  bool isConnection = false;
  bool hasNavigated = false;

  final Duration splashDuration = const Duration(seconds: 3);
  late Stopwatch stopwatch;

  @override
  void initState() {
    super.initState();
    stopwatch = Stopwatch()..start();
    checkInitialConnection();
    getConnectivity();
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }

  void checkInitialConnection() async {
    isConnection = await InternetConnectionChecker.instance.hasConnection;
    Duration elapsed = stopwatch.elapsed;

    if (isConnection) {
      debugPrint("✅ Initial Internet available");
      if (elapsed < splashDuration) {
        await Future.delayed(splashDuration - elapsed);
      }
      navigateAfterDelay(skipDelay: true);
    } else {
      AppCustomToast.errorShowCustomToast('No Internet \nConnect your device to the internet');
      Get.snackbar("No Internet", 'Connect your device to the internet');
    }
  }

  void getConnectivity() {
    streamSubscription = Connectivity().onConnectivityChanged.listen((event) async {
      isConnection = await InternetConnectionChecker.instance.hasConnection;

      if (isConnection && !hasNavigated) {
        debugPrint("✅ Internet reconnected");
        Duration elapsed = stopwatch.elapsed;

        if (elapsed < splashDuration) {
          await Future.delayed(splashDuration - elapsed);
        }

        navigateAfterDelay(skipDelay: true);
      } else if (!isConnection) {
        AppCustomToast.errorShowCustomToast('No Internet \nConnect your device to the internet.');
        debugPrint("❌ No internet connection");
      }
    });
  }

  void navigateAfterDelay({bool skipDelay = false}) {
    if (hasNavigated) return;
    hasNavigated = true;

    if (skipDelay) {
      goToNextScreen();
    } else {
      Timer(splashDuration, goToNextScreen);
    }
  }

  void goToNextScreen() async {
    bool? isLogged = await PrefsHelper.getBool(AppConstants.isLogged);

    if (isLogged == true) {
      Get.offAllNamed(AppRoutes.logInScreen);
    } else {
      Get.offAllNamed(AppRoutes.logInScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FFF7),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Center(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 60.h),
                Center(
                  child:
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Image.asset(
                      AppImages.appLogo,
                      width: 150,
                    ),
                  ),
                  // SvgPicture.asset('assets/icons/shadhinwifi_logo.svg'),
                ),
                SizedBox(height: 50.h),
                Column(
                  children: [
                    Text('Welcome to \n Shadhin Transmission',style: AppStyles.fontSize32(color : AppColors.primaryColor,fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,),
                    SizedBox(height: 20.h),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
