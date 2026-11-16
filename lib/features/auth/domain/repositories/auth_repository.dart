abstract class AuthRepository {
  Future<void> login(String login, String password);
  Future<void> logout();
  bool isLoggedIn();
  String? getUserLogin();
  String? getPeanutToken();
  String? getPartnerToken();
}
