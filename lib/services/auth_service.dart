import '../models/user_model.dart';

class AuthService {
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // TODO(KT3): replace with real backend call.
    await Future.delayed(const Duration(milliseconds: 300));
    return UserModel(
      id: 'u_demo',
      username: 'Alex_Pro',
      email: email,
      diamonds: 100,
      bestScore: 0,
      lastScore: 0,
      ownedFrontSets: const ['emoji'],
      ownedBackSkins: const ['default'],
      currentFrontSet: 'emoji',
      currentBackSkin: 'default',
      role: UserRole.user,
    );
  }

  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
  }) async {
    // TODO(KT3): replace with real backend call.
    await Future.delayed(const Duration(milliseconds: 300));
    return UserModel(
      id: 'u_demo',
      username: username,
      email: email,
      diamonds: 100,
      bestScore: 0,
      lastScore: 0,
      ownedFrontSets: const ['emoji'],
      ownedBackSkins: const ['default'],
      currentFrontSet: 'emoji',
      currentBackSkin: 'default',
      role: UserRole.user,
    );
  }

  Future<void> logout() async {
    // TODO(KT3): replace with real backend call.
    await Future.delayed(const Duration(milliseconds: 150));
  }
}
