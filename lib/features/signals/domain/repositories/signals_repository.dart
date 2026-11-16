import 'package:smart_trader_mobile/features/signals/data/models/signal_model.dart';

abstract class SignalsRepository {
  Future<List<SignalModel>> getSignals({
    required String login,
    required String passkey,
    required List<String> pairs,
    required DateTime from,
    required DateTime to,
  });
}
