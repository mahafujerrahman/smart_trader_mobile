import 'package:get/get.dart';
import 'package:smart_trader_mobile/app/core/routes/app_routes.dart';
import 'package:smart_trader_mobile/app/core/routes/auth_middleware.dart';
import 'package:smart_trader_mobile/features/auth/bindings/auth_binding.dart';
import 'package:smart_trader_mobile/features/auth/presentation/views/login_screen.dart';
import 'package:smart_trader_mobile/features/profile/bindings/profile_binding.dart';
import 'package:smart_trader_mobile/features/profile/presentation/views/profile_screen.dart';
import 'package:smart_trader_mobile/features/promo/bindings/promo_binding.dart';
import 'package:smart_trader_mobile/features/promo/presentation/views/promo_screen.dart';
import 'package:smart_trader_mobile/features/shell/home_shell.dart';
import 'package:smart_trader_mobile/features/signals/bindings/signals_binding.dart';
import 'package:smart_trader_mobile/features/signals/presentation/views/signals_screen.dart';
import 'package:smart_trader_mobile/splash_screen.dart';

abstract class AppPages {
  AppPages._();

  static final List<GetPage<dynamic>> routes = [
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.login, page: () => const LoginScreen(), binding: AuthBinding(), middlewares: [AuthMiddleware()]),

    GetPage(name: AppRoutes.home, page: () => const HomeShell(child: ProfileScreen()), binding: ProfileBinding(), middlewares: [AuthMiddleware()],),
    GetPage(name: AppRoutes.profile, page: () => const HomeShell(child: ProfileScreen()), binding: ProfileBinding(), middlewares: [AuthMiddleware()],),
    GetPage(name: AppRoutes.signals, page: () => const HomeShell(child: SignalsScreen()), binding: SignalsBinding(), middlewares: [AuthMiddleware()],),
    GetPage(name: AppRoutes.promo, page: () => const HomeShell(child: PromoScreen()), binding: PromoBinding(), middlewares: [AuthMiddleware()],),
  ];
}
