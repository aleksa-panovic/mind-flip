import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  AuthRepository(this._service);

  final AuthService _service;

  Future<UserModel> login({
    required String email,
    required String password,
  }) {
    return _service.login(email: email, password: password);
  }

  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
  }) {
    return _service.register(
      username: username,
      email: email,
      password: password,
    );
  }

  Future<void> logout() {
    return _service.logout();
  }
}
