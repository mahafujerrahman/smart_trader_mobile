import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:smart_trader_mobile/app/core/error/failures.dart';
import 'package:smart_trader_mobile/features/auth/domain/repositories/auth_repository.dart';

enum AuthStatus { initial, loading, authenticated, error, loggedOut }

class AuthController extends GetxController {
  final AuthRepository _authRepository;

  AuthController(this._authRepository);

  // Public Rx observables
  final status = AuthStatus.initial.obs;
  final errorMessage = ''.obs;
  final userLogin = ''.obs;

  final rememberMe = false.obs;

  void toggleRememberMe(bool? value) => rememberMe.value = value ?? false;

  bool get isLoading => status.value == AuthStatus.loading;
  bool get isAuthenticated => status.value == AuthStatus.authenticated;

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  void checkAuthStatus() {
    if (_authRepository.isLoggedIn()) {
      userLogin.value = _authRepository.getUserLogin() ?? '';
      status.value = AuthStatus.authenticated;
    } else {
      status.value = AuthStatus.initial;
    }
  }

  Future<void> login(String login, String password) async {
    status.value = AuthStatus.loading;
    errorMessage.value = '';
    try {
      await _authRepository.login(login, password);
      userLogin.value = login;
      status.value = AuthStatus.authenticated;
    } on AuthFailure catch (e) {
      errorMessage.value = e.message;
      status.value = AuthStatus.error;
    } on NetworkFailure catch (e) {
      errorMessage.value = e.message;
      status.value = AuthStatus.error;
    } on ServerFailure catch (e) {
      errorMessage.value = e.message;
      status.value = AuthStatus.error;
    } on http.ClientException catch (e, st) {
      debugPrint('[AuthController] ClientException: $e\n$st');
      errorMessage.value = 'Unable to reach server. Check your connection.';
      status.value = AuthStatus.error;
    } on SocketException catch (e, st) {
      debugPrint('[AuthController] SocketException: $e\n$st');
      errorMessage.value = 'No internet connection.';
      status.value = AuthStatus.error;
    } on TimeoutException catch (e, st) {
      debugPrint('[AuthController] TimeoutException: $e\n$st');
      errorMessage.value = 'Request timed out. Please try again.';
      status.value = AuthStatus.error;
    } on FormatException catch (e, st) {
      debugPrint('[AuthController] FormatException: $e\n$st');
      errorMessage.value = 'Invalid server response. Please try again.';
      status.value = AuthStatus.error;
    } catch (e, st) {
      debugPrint('[AuthController] UNEXPECTED ${e.runtimeType}: $e\n$st');
      errorMessage.value = kDebugMode
          ? '${e.runtimeType}: $e'
          : 'An unexpected error occurred. Please try again.';
      status.value = AuthStatus.error;
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    userLogin.value = '';
    status.value = AuthStatus.loggedOut;
  }

  String? getPeanutToken() => _authRepository.getPeanutToken();
  String? getPartnerToken() => _authRepository.getPartnerToken();
}
