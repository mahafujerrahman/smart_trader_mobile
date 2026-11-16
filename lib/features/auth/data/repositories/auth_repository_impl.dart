import 'package:smart_trader_mobile/app/core/error/failures.dart';
import 'package:smart_trader_mobile/app/helpers/prefs_helper.dart';
import 'package:smart_trader_mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:smart_trader_mobile/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<void> login(String login, String password) async {

    final peanutToken = await _remoteDataSource.isAccountCredentialsCorrect(login, password);
    final partnerToken = await _remoteDataSource.requestPartnerToken(login, password);

    if (partnerToken.isEmpty) {
      throw const ServerFailure('Failed to retrieve session token. Please try again.');
    }


    await PrefsHelper.saveUserLogin(login);
    await PrefsHelper.saveUserPassword(password);
    await PrefsHelper.savePeanutToken(peanutToken);
    await PrefsHelper.savePartnerToken(partnerToken);
    await PrefsHelper.setLoggedIn(true);
  }

  @override
  Future<void> logout() async {
    await PrefsHelper.clearAll();
  }

  @override
  bool isLoggedIn() => PrefsHelper.isLoggedIn();

  @override
  String? getUserLogin() => PrefsHelper.getUserLogin();

  @override
  String? getPeanutToken() => PrefsHelper.getPeanutToken();

  @override
  String? getPartnerToken() => PrefsHelper.getPartnerToken();
}
