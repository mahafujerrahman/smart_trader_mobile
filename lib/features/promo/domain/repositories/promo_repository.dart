import 'package:smart_trader_mobile/features/promo/data/models/promo_model.dart';

abstract class PromoRepository {
  Future<List<PromoModel>> getPromo();
}
