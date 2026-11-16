class LanguageModel {
  String languageName;
  String languageCode;
  String countryCode;

  LanguageModel({
    this.languageName = 'English',
    required this.countryCode,
    required this.languageCode,
  });
}