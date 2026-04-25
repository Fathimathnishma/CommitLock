abstract class AuthRepository {
  Future<bool> login(String email, String password);

  Future<bool> signup(String email, String password);

  bool checkLogin();

  Future<void> logout();
}
