class AuthEntity {
  final String login;
  final String peanutToken;
  final String partnerToken;

  const AuthEntity({
    required this.login,
    required this.peanutToken,
    required this.partnerToken,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthEntity &&
          runtimeType == other.runtimeType &&
          login == other.login &&
          peanutToken == other.peanutToken &&
          partnerToken == other.partnerToken;

  @override
  int get hashCode => Object.hash(login, peanutToken, partnerToken);
}
