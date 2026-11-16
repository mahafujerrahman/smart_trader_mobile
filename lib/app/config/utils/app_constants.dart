import 'package:smart_trader_mobile/common_model/language_model.dart';

class AppConstants {
  // Peanut Service
  static const String peanutBaseUrl = 'https://peanut.ifxdb.com';
  static const String isAccountCredentialsCorrect = '/api/ClientCabinetBasic/IsAccountCredentialsCorrect';
  static const String getAccountInformation = '/api/ClientCabinetBasic/GetAccountInformation';
  static const String getLastFourNumbersPhone = '/api/ClientCabinetBasic/GetLastFourNumbersPhone';

  // Partner Service
  static const String partnerBaseUrl = 'https://client-api.contentdatapro.com';
  static const String requestMobileToken = '/api/Authentication/RequestMoblieCabinetApiToken';
  static const String getAnalyticSignals = '/clientmobile/GetAnalyticSignals';

  // Promo SOAP Service
  static const String promoSoapUrl = 'https://api-forexcopy.contentdatapro.com/Services/CabinetMicroService.svc';
  static const String promoImageBaseUrl = 'https://forex-images.ifxdb.com';

  // SharedPreferences Keys
  static const String peanutTokenKey = 'peanut_token';
  static const String partnerTokenKey = 'partner_token';
  static const String userLoginKey = 'user_login';
  static const String isLoggedInKey = 'is_logged_in';
  static const String tokenExpiryKey = 'token_expiry';
  static const String userPasswordKey = 'user_password';

  // Trading Systems
  static  int tradingSystem = 3;

  static  List<String> availablePairs = [
    'EURUSD',
    'GBPUSD',
    'USDJPY',
    'USDCHF',
    'USDCAD',
    'AUDUSD',
    'NZDUSD',
  ];


  static List<LanguageModel> languages = [LanguageModel(languageCode: 'en', countryCode: 'US')];
}