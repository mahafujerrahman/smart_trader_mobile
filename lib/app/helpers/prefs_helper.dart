import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_trader_mobile/app/config/utils/app_constants.dart';

class PrefsHelper {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get _instance {
    if (_prefs == null) throw Exception('PrefsHelper not initialized');
    return _prefs!;
  }

  // --- Auth ---
  static Future<void> savePeanutToken(String token) async {
    await _instance.setString(AppConstants.peanutTokenKey, token);
  }

  static String? getPeanutToken() =>
      _instance.getString(AppConstants.peanutTokenKey);

  static Future<void> savePartnerToken(String token) async {
    await _instance.setString(AppConstants.partnerTokenKey, token);
  }

  static String? getPartnerToken() =>
      _instance.getString(AppConstants.partnerTokenKey);

  static Future<void> saveUserLogin(String login) async {
    await _instance.setString(AppConstants.userLoginKey, login);
  }

  static String? getUserLogin() =>
      _instance.getString(AppConstants.userLoginKey);

  /// Save password so peanut profile endpoints can use it
  static Future<void> saveUserPassword(String password) async {
    await _instance.setString(AppConstants.userPasswordKey, password);
  }

  static String? getUserPassword() =>
      _instance.getString(AppConstants.userPasswordKey);

  static Future<void> setLoggedIn(bool value) async {
    await _instance.setBool(AppConstants.isLoggedInKey, value);
  }

  static bool isLoggedIn() =>
      _instance.getBool(AppConstants.isLoggedInKey) ?? false;

  static Future<void> clearAll() async {
    await _instance.clear();
  }

  // --- Generic ---
  static Future<void> setString(String key, String value) async {
    await _instance.setString(key, value);
  }

  static String? getString(String key) => _instance.getString(key);

  static Future<void> setBool(String key, bool value) async {
    await _instance.setBool(key, value);
  }

  static bool? getBool(String key) => _instance.getBool(key);
}
