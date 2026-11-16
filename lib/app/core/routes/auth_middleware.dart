import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_trader_mobile/app/core/routes/app_routes.dart';
import 'package:smart_trader_mobile/features/auth/presentation/controller/auth_controller.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (route == null || route == AppRoutes.splash) return null;

    try {
      final authCtrl = Get.find<AuthController>();
      final isLoggedIn = authCtrl.isAuthenticated;
      final isOnLogin = route == AppRoutes.login;

      if (!isLoggedIn && !isOnLogin) {
        return const RouteSettings(name: AppRoutes.login);
      }
      if (isLoggedIn && isOnLogin) {
        return const RouteSettings(name: AppRoutes.profile);
      }
    } catch (_) {

    }
    return null;
  }
}
