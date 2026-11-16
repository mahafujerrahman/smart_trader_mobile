import 'package:get/get.dart';
import 'package:smart_trader_mobile/app/core/network/api_client.dart';
import 'package:smart_trader_mobile/features/promo/data/datasources/promo_remote_datasource.dart';
import 'package:smart_trader_mobile/features/promo/data/repositories/promo_repository_impl.dart';
import 'package:smart_trader_mobile/features/promo/domain/repositories/promo_repository.dart';
import 'package:smart_trader_mobile/features/promo/presentation/controller/promo_controller.dart';

class PromoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PromoRemoteDataSource>(() => PromoRemoteDataSourceImpl(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<PromoRepository>(() => PromoRepositoryImpl(Get.find<PromoRemoteDataSource>()), fenix: true);
    Get.lazyPut<PromoController>(() => PromoController(Get.find<PromoRepository>()), fenix: true);
  }
}
