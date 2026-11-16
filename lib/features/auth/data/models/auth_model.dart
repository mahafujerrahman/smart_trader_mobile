class AuthModel {
  final bool isSuccess;
  final String? token;
  final String? errorMessage;

  const AuthModel({
    required this.isSuccess,
    this.token,
    this.errorMessage,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {

    if (json.containsKey('token')) {
      return AuthModel(
        isSuccess: true,
        token: json['token'] as String?,
      );
    }

    final result = json['result'] ?? json['IsAccountCredentialsCorrectResult'];
    return AuthModel(
      isSuccess: result == true || result == 'true',
    );
  }

  factory AuthModel.fromBool(bool value) {
    return AuthModel(isSuccess: value);
  }
}

class PartnerTokenModel {
  final String token;

  const PartnerTokenModel({required this.token});

  factory PartnerTokenModel.fromJson(Map<String, dynamic> json) {

    final token = json['token'] ?? json['Token'] ?? json['accessToken'] ?? '';
    return PartnerTokenModel(token: token.toString());
  }
}
