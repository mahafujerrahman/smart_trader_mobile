import 'package:get/get.dart';
import 'package:smart_trader_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:smart_trader_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:smart_trader_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:smart_trader_mobile/features/auth/presentation/controller/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(), fenix: true);
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(Get.find<AuthRemoteDataSource>()), fenix: true);
    Get.lazyPut<AuthController>(() => AuthController(Get.find<AuthRepository>()), fenix: true);
  }
}
