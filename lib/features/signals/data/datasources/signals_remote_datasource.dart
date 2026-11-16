import 'package:smart_trader_mobile/app/config/utils/app_constants.dart';
import 'package:smart_trader_mobile/app/core/network/api_client.dart';
import 'package:smart_trader_mobile/features/signals/data/models/signal_model.dart';

abstract class SignalsRemoteDataSource {
  Future<List<SignalModel>> getAnalyticSignals({
    required String login,
    required String passkey,
    required List<String> pairs,
    required int from,
    required int to,
  });
}

class SignalsRemoteDataSourceImpl implements SignalsRemoteDataSource {
  final ApiClient _apiClient;

  SignalsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<SignalModel>> getAnalyticSignals({
    required String login,
    required String passkey,
    required List<String> pairs,
    required int from,
    required int to,
  }) async {
    final endpoint = '${AppConstants.getAnalyticSignals}/$login';
    final response = await _apiClient.getPartner(
      endpoint,
      queryParams: {
        'tradingsystem': AppConstants.tradingSystem.toString(),
        'pairs': pairs.join(','),
        'from': from.toString(),
        'to': to.toString(),
      },
      passkey: passkey,
    );

    if (response is List) {
      return response
          .map((e) => SignalModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
