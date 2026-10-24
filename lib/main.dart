import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smart_trader_mobile/app/core/routes/routes.dart';
import 'app/config/utils/app_constants.dart';
import 'app/config/utils/message.dart';
import 'app/helpers/di.dart' as di;
import 'app/helpers/localization_controller.dart';
import 'app/helpers/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  Map<String, Map<String, String>> languages = await di.init();
  runApp(MyApp(
    languages: languages,
  ));
}
//
class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.languages});

  final Map<String, Map<String, String>> languages;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetBuilder<LocalizationController>(builder: (localizeController) {
        return ScreenUtilInit(
            designSize:  Size(393, 852),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (_, child) {
              return GetMaterialApp(
                title: 'Shadhin Transmission App',
                debugShowCheckedModeBanner: false,
                navigatorKey: Get.key,
                // theme: themeController.darkTheme ? dark(): light(),
                defaultTransition: Transition.topLevel,
                locale: localizeController.locale,
                translations: Messages(languages: languages),
                fallbackLocale: Locale(AppConstants.languages[0].languageCode, AppConstants.languages[0].countryCode),
                transitionDuration: const Duration(milliseconds: 500),
                getPages: routes,
                initialRoute: AppRoutes.splashScreen,
              );
            });
      });
    });
  }
}