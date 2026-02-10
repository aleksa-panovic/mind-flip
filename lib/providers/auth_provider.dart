import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    } on FirebaseAuthException catch (e) {
      errorMessage = _mapAuthError(e);
      return false;
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
    } on FirebaseAuthException catch (e) {
      errorMessage = _mapAuthError(e);
      return false;
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

  Future<bool> sendPasswordReset(String email) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _repo.sendPasswordReset(email);
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = _mapAuthError(e);
      return false;
    } catch (e) {
      errorMessage = 'Reset failed. Try again.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setUser(UserModel? user) {
    currentUser = user;
    notifyListeners();
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Email nije validan.';
      case 'user-disabled':
        return 'Nalog je onemogucen.';
      case 'user-not-found':
        return 'Korisnik ne postoji.';
      case 'wrong-password':
        return 'Pogresna lozinka.';
      case 'email-already-in-use':
        return 'Email je vec zauzet.';
      case 'weak-password':
        return 'Lozinka je preslaba.';
      default:
        return 'Autentikacija nije uspela.';
    }
  }
}
