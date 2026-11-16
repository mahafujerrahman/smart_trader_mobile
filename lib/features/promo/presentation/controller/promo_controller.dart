import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:smart_trader_mobile/app/core/error/failures.dart';
import 'package:smart_trader_mobile/features/promo/data/models/promo_model.dart';
import 'package:smart_trader_mobile/features/promo/domain/repositories/promo_repository.dart';

enum PromoStatus { initial, loading, loaded, empty, error }

class PromoController extends GetxController {
  final PromoRepository _repository;

  PromoController(this._repository);

  final _status = PromoStatus.initial.obs;
  final _errorMessage = ''.obs;
  final _promos = <PromoModel>[].obs;

  PromoStatus get status => _status.value;
  String get errorMessage => _errorMessage.value;
  List<PromoModel> get promos => _promos;
  bool get isLoading => _status.value == PromoStatus.loading;

  @override
  void onInit() {
    super.onInit();
    loadPromo();
  }

  Future<void> loadPromo() async {
    _status.value = PromoStatus.loading;
    _errorMessage.value = '';
    try {
      final result = await _repository.getPromo();
      if (result.isEmpty) {
        _status.value = PromoStatus.empty;
      } else {
        _promos.assignAll(result);
        _status.value = PromoStatus.loaded;
      }
    } on NetworkFailure catch (e) {
      _errorMessage.value = e.message;
      _status.value = PromoStatus.error;
    } on ServerFailure catch (e) {
      _errorMessage.value = e.message;
      _status.value = PromoStatus.error;
    } on SocketException {
      _errorMessage.value = 'No internet connection. Please check your network.';
      _status.value = PromoStatus.error;
    } on TimeoutException {
      _errorMessage.value = 'Request timed out. Please try again.';
      _status.value = PromoStatus.error;
    } catch (e) {
      _errorMessage.value = 'Failed to load promo materials.';
      _status.value = PromoStatus.error;
    }
  }
}
