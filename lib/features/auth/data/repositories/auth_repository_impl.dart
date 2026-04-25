import 'package:commitlock/features/auth/data/data_sources/auth_local_datasource.dart';
import 'package:commitlock/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource local;

  AuthRepositoryImpl(this.local);

  @override
  Future<bool> login(String email, String password) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      await local.setLoggedIn(true);
      return true;
    }
    return false;
  }

  @override
  Future<bool> signup(String email, String password) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      await local.setLoggedIn(true); // SAME AS LOGIN
      return true;
    }
    return false;
  }

  @override
  bool checkLogin() => local.isLoggedIn();

  @override
  Future<void> logout() => local.logout();
}
