import 'package:get/get.dart';
import 'package:smart_trader_mobile/features/auth/controller/auth_controller.dart';


class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController(),
    );
  }
}
