import 'package:smart_trader_mobile/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:smart_trader_mobile/features/profile/data/models/profile_model.dart';
import 'package:smart_trader_mobile/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<ProfileModel> getProfile(String login, String token) async {
    final profile = await _remoteDataSource.getAccountInformation(login, token);

    String lastFour = '';
    try {
      final raw = await _remoteDataSource.getLastFourNumbersPhone(login, token);
      lastFour = raw.replaceAll('*', '').trim();
      if (lastFour.isEmpty) lastFour = raw;
    } catch (_) {}

    return profile.copyWith(lastFourPhone: lastFour);
  }
}
