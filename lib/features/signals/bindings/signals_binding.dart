import 'package:get/get.dart';
import 'package:smart_trader_mobile/app/core/network/api_client.dart';
import 'package:smart_trader_mobile/features/signals/data/datasources/signals_remote_datasource.dart';
import 'package:smart_trader_mobile/features/signals/data/repositories/signals_repository_impl.dart';
import 'package:smart_trader_mobile/features/signals/domain/repositories/signals_repository.dart';
import 'package:smart_trader_mobile/features/signals/presentation/controller/signals_controller.dart';

class SignalsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignalsRemoteDataSource>(() => SignalsRemoteDataSourceImpl(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<SignalsRepository>(() => SignalsRepositoryImpl(Get.find<SignalsRemoteDataSource>()), fenix: true);
    Get.lazyPut<SignalsController>(() => SignalsController(Get.find<SignalsRepository>()), fenix: true);
  }
}
