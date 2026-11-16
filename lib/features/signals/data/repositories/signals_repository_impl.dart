import 'package:smart_trader_mobile/features/signals/data/datasources/signals_remote_datasource.dart';
import 'package:smart_trader_mobile/features/signals/data/models/signal_model.dart';
import 'package:smart_trader_mobile/features/signals/domain/repositories/signals_repository.dart';

class SignalsRepositoryImpl implements SignalsRepository {
  final SignalsRemoteDataSource _remoteDataSource;

  SignalsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<SignalModel>> getSignals({
    required String login,
    required String passkey,
    required List<String> pairs,
    required DateTime from,
    required DateTime to,
  }) async {
    final fromTimestamp = from.millisecondsSinceEpoch ~/ 1000;
    final toTimestamp = to.millisecondsSinceEpoch ~/ 1000;
    return _remoteDataSource.getAnalyticSignals(
      login: login,
      passkey: passkey,
      pairs: pairs,
      from: fromTimestamp,
      to: toTimestamp,
    );
  }
}
