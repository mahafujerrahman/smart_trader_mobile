
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:smart_trader_mobile/features/auth/bindings/auth_binding.dart';
import 'package:smart_trader_mobile/features/auth/views/login_screen.dart';
import 'package:smart_trader_mobile/splash_screen.dart';

final List<GetPage> routes=[
//SplashScreen
GetPage(name:AppRoutes.splashScreen, page: ()=> SplashScreen(),transition: Transition.noTransition),
  GetPage(name:AppRoutes.logInScreen, page: ()=> LogInScreen(),binding:AuthBinding(), transition: Transition.noTransition),
];

class AppRoutes {
  AppRoutes._();

  static String splashScreen = "/splash_screen";
  static String logInScreen = "/logIn_screen";
}