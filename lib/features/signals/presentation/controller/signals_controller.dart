import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:smart_trader_mobile/app/config/utils/app_constants.dart';
import 'package:smart_trader_mobile/app/core/error/failures.dart';
import 'package:smart_trader_mobile/app/helpers/prefs_helper.dart';
import 'package:smart_trader_mobile/features/signals/data/models/signal_model.dart';
import 'package:smart_trader_mobile/features/signals/domain/repositories/signals_repository.dart';

enum SignalsStatus { initial, loading, loaded, empty, error }

class SignalsController extends GetxController {
  final SignalsRepository _repository;

  SignalsController(this._repository);

  final _status = SignalsStatus.initial.obs;
  final _errorMessage = ''.obs;
  final _signals = <SignalModel>[].obs;
  final _selectedPairs = <String>[].obs;
  final _from = DateTime.now().subtract(const Duration(days: 30)).obs;
  final _to = DateTime.now().obs;

  SignalsStatus get status => _status.value;
  String get errorMessage => _errorMessage.value;
  List<SignalModel> get signals => _signals;
  List<String> get selectedPairs => _selectedPairs;
  DateTime get from => _from.value;
  DateTime get to => _to.value;
  bool get isLoading => _status.value == SignalsStatus.loading;

  @override
  void onInit() {
    super.onInit();
    _selectedPairs.add(AppConstants.availablePairs.first);
  }

  void togglePair(String pair) {
    if (_selectedPairs.contains(pair)) {
      if (_selectedPairs.length > 1) {
        _selectedPairs.remove(pair);
      }
    } else {
      _selectedPairs.add(pair);
    }
  }

  void setFrom(DateTime date) => _from.value = date;
  void setTo(DateTime date) => _to.value = date;
  void setDateRange(DateTime from, DateTime to) {
    _from.value = from;
    _to.value = to;
  }

  Future<void> fetchSignals() async {
    if (_selectedPairs.isEmpty) {
      _errorMessage.value = 'Please select at least one currency pair.';
      _status.value = SignalsStatus.error;
      return;
    }

    _status.value = SignalsStatus.loading;
    _errorMessage.value = '';
    _signals.clear();

    try {
      final login = PrefsHelper.getUserLogin() ?? '';
      final passkey = PrefsHelper.getPartnerToken() ?? '';

      final result = await _repository.getSignals(
        login: login,
        passkey: passkey,
        pairs: List.from(_selectedPairs),
        from: _from.value,
        to: _to.value,
      );

      if (result.isEmpty) {
        _status.value = SignalsStatus.empty;
      } else {
        _signals.assignAll(result);
        _status.value = SignalsStatus.loaded;
      }
    } on NetworkFailure catch (e) {
      _errorMessage.value = e.message;
      _status.value = SignalsStatus.error;
    } on ServerFailure catch (e) {
      _errorMessage.value = e.message;
      _status.value = SignalsStatus.error;
    } on SocketException {
      _errorMessage.value = 'No internet connection. Please check your network.';
      _status.value = SignalsStatus.error;
    } on TimeoutException {
      _errorMessage.value = 'Request timed out. Please try again.';
      _status.value = SignalsStatus.error;
    } catch (e) {
      _errorMessage.value = 'Failed to load signals. Please try again.';
      _status.value = SignalsStatus.error;
    }
  }
}
