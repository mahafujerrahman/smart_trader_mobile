import 'package:smart_trader_mobile/features/promo/data/datasources/promo_remote_datasource.dart';
import 'package:smart_trader_mobile/features/promo/data/models/promo_model.dart';
import 'package:smart_trader_mobile/features/promo/domain/repositories/promo_repository.dart';

class PromoRepositoryImpl implements PromoRepository {
  final PromoRemoteDataSource _remoteDataSource;

  PromoRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<PromoModel>> getPromo() async {
    return _remoteDataSource.getCCPromo();
  }
}
