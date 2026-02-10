import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._repo);

  final AuthRepository _repo;

  UserModel? currentUser;
  bool isLoading = false;
  String? errorMessage;

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      currentUser = await _repo.login(email: email, password: password);
      return true;
    } catch (e) {
      errorMessage = 'Login failed. Try again.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String username,
    required String email,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      currentUser = await _repo.register(
        username: username,
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      errorMessage = 'Register failed. Try again.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    isLoading = true;
    notifyListeners();
    await _repo.logout();
    currentUser = null;
    isLoading = false;
    notifyListeners();
  }

  void setUser(UserModel? user) {
    currentUser = user;
    notifyListeners();
  }
}
