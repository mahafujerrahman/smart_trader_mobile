import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:smart_trader_mobile/app/core/network/api_client.dart';
import 'package:smart_trader_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:smart_trader_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:smart_trader_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:smart_trader_mobile/features/auth/presentation/controller/auth_controller.dart';
import 'package:smart_trader_mobile/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:smart_trader_mobile/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:smart_trader_mobile/features/profile/domain/repositories/profile_repository.dart';
import 'package:smart_trader_mobile/features/profile/presentation/controller/profile_controller.dart';
import 'package:smart_trader_mobile/features/promo/data/datasources/promo_remote_datasource.dart';
import 'package:smart_trader_mobile/features/promo/data/repositories/promo_repository_impl.dart';
import 'package:smart_trader_mobile/features/promo/domain/repositories/promo_repository.dart';
import 'package:smart_trader_mobile/features/promo/presentation/controller/promo_controller.dart';
import 'package:smart_trader_mobile/features/shell/home_controller.dart';
import 'package:smart_trader_mobile/features/signals/data/datasources/signals_remote_datasource.dart';
import 'package:smart_trader_mobile/features/signals/data/repositories/signals_repository_impl.dart';
import 'package:smart_trader_mobile/features/signals/domain/repositories/signals_repository.dart';
import 'package:smart_trader_mobile/features/signals/presentation/controller/signals_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<ApiClient>(() => ApiClient(client: http.Client()), fenix: true);
    Get.lazyPut<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(), fenix: true);
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(Get.find<AuthRemoteDataSource>()), fenix: true);
    Get.lazyPut<AuthController>(() => AuthController(Get.find<AuthRepository>()), fenix: true);

    Get.lazyPut<ProfileRemoteDataSource>(() => ProfileRemoteDataSourceImpl(), fenix: true);
    Get.lazyPut<ProfileRepository>(() => ProfileRepositoryImpl(Get.find<ProfileRemoteDataSource>()), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(Get.find<ProfileRepository>()), fenix: true);


    Get.lazyPut<SignalsRemoteDataSource>(() => SignalsRemoteDataSourceImpl(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<SignalsRepository>(() => SignalsRepositoryImpl(Get.find<SignalsRemoteDataSource>()), fenix: true);
    Get.lazyPut<SignalsController>(() => SignalsController(Get.find<SignalsRepository>()), fenix: true);


    Get.lazyPut<PromoRemoteDataSource>(() => PromoRemoteDataSourceImpl(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<PromoRepository>(() => PromoRepositoryImpl(Get.find<PromoRemoteDataSource>()), fenix: true);
    Get.lazyPut<PromoController>(() => PromoController(Get.find<PromoRepository>()), fenix: true);


    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
  }
}
