import 'package:hive/hive.dart';

class AuthLocalDataSource {
  final Box box;

  AuthLocalDataSource(this.box);

  Future<void> setLoggedIn(bool value) async {
    await box.put("isLoggedIn", value);
  }

  bool isLoggedIn() {
    return box.get("isLoggedIn", defaultValue: false);
  }

  Future<void> logout() async {
    await box.put("isLoggedIn", false);
  }
}
