import 'package:commitlock/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository repository;

  AuthProvider(this.repository);

  bool isLoading = false;

  Future<bool> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    final result = await repository.login(email, password);

    isLoading = false;
    notifyListeners();

    return result;
  }

  Future<bool> signup(String email, String password) async {
    isLoading = true;
    notifyListeners();

    final result = await repository.signup(email, password);

    isLoading = false;
    notifyListeners();

    return result;
  }

  Future<void> logout() async {
    await repository.logout();

    notifyListeners();
  }
}
