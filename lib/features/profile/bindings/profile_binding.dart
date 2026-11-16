import 'package:get/get.dart';
import 'package:smart_trader_mobile/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:smart_trader_mobile/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:smart_trader_mobile/features/profile/domain/repositories/profile_repository.dart';
import 'package:smart_trader_mobile/features/profile/presentation/controller/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileRemoteDataSource>(() => ProfileRemoteDataSourceImpl(), fenix: true);
    Get.lazyPut<ProfileRepository>(() => ProfileRepositoryImpl(Get.find<ProfileRemoteDataSource>()), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(Get.find<ProfileRepository>()), fenix: true);
  }
}
