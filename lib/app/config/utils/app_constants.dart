
import 'package:smart_trader_mobile/common_model/language_model.dart';

class AppConstants{

  // Share preference Key
  static String THEME ="theme";
  static const String LANGUAGE_CODE = 'language_code';
  static const String COUNTRY_CODE = 'country_code';
  static RegExp emailValidator = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static RegExp passwordValidator = RegExp(
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$"
  );
  static List<LanguageModel> languages = [
    LanguageModel( languageName: 'Bengali', countryCode: 'BN', languageCode: 'bn'),
    LanguageModel( languageName: 'English', countryCode: 'US', languageCode: 'en'),
  ];

//=================>> App Data <<=============================
  static String isLogged = "IsLogged";
  static const String bearerToken = "BearerToken";
  static const String verificationToken = "VerificationToken";
  static const String userRole = "UserRole";


}

enum Role {transmission_hqinventoryadmin, transmission_admin,transmission_supervisor,transmission_surveyor,transmission_technician}