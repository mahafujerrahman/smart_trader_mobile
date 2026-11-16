import 'package:smart_trader_mobile/features/profile/data/models/profile_model.dart';

abstract class ProfileRepository {
  Future<ProfileModel> getProfile(String login, String password);
}
