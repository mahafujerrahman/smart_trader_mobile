import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:smart_trader_mobile/app/core/error/failures.dart';
import 'package:smart_trader_mobile/app/helpers/prefs_helper.dart';
import 'package:smart_trader_mobile/features/profile/data/models/profile_model.dart';
import 'package:smart_trader_mobile/features/profile/domain/repositories/profile_repository.dart';

enum ProfileStatus { initial, loading, loaded, error }

class ProfileController extends GetxController {
  final ProfileRepository _profileRepository;

  ProfileController(this._profileRepository);

  final _status = ProfileStatus.initial.obs;
  final _errorMessage = ''.obs;
  final Rx<ProfileModel?> _profile = Rx<ProfileModel?>(null);

  ProfileStatus get status => _status.value;
  String get errorMessage => _errorMessage.value;
  ProfileModel? get profile => _profile.value;
  bool get isLoading => _status.value == ProfileStatus.loading;
  bool get isLoaded => _status.value == ProfileStatus.loaded;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    _status.value = ProfileStatus.loading;
    _errorMessage.value = '';
    try {
      final login = PrefsHelper.getUserLogin() ?? '';
      final token = PrefsHelper.getPeanutToken() ?? '';

      if (login.isEmpty) {
        _errorMessage.value = 'Session expired. Please login again.';
        _status.value = ProfileStatus.error;
        return;
      }

      final profile = await _profileRepository.getProfile(login, token);
      _profile.value = profile;
      _status.value = ProfileStatus.loaded;
    } on NetworkFailure catch (e) {
      _errorMessage.value = e.message;
      _status.value = ProfileStatus.error;
    } on ServerFailure catch (e) {
      _errorMessage.value = e.message;
      _status.value = ProfileStatus.error;
    } on SocketException {
      _errorMessage.value = 'No internet connection. Please check your network.';
      _status.value = ProfileStatus.error;
    } on TimeoutException {
      _errorMessage.value = 'Request timed out. Please try again.';
      _status.value = ProfileStatus.error;
    } catch (e) {
      _errorMessage.value = 'Failed to load profile. Please try again.';
      _status.value = ProfileStatus.error;
    }
  }
}
