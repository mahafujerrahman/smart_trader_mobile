import 'package:get/get.dart';
import 'package:smart_trader_mobile/app/core/routes/app_routes.dart';

class HomeController extends GetxController {

  final selectedIndex = 0.obs;

  static const List<String> tabRoutes = [
    AppRoutes.profile,
    AppRoutes.signals,
    AppRoutes.promo,
  ];

  @override
  void onInit() {
    super.onInit();
    syncWithRoute(Get.currentRoute);
  }


  void syncWithRoute(String route) {
    final index = tabIndexForRoute(route);
    if (selectedIndex.value != index) selectedIndex.value = index;
  }

  int tabIndexForRoute(String route) {
    if (route.startsWith(AppRoutes.signals)) return 1;
    if (route.startsWith(AppRoutes.promo)) return 2;
    return 0;
  }

  void changeTab(int index) {
    if (index < 0 || index >= tabRoutes.length) return;
    selectedIndex.value = index;
    if (Get.currentRoute != tabRoutes[index]) {
      Get.offAllNamed(tabRoutes[index]);
    }
  }
}
