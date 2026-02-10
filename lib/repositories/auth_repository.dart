import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firebase_auth_service.dart';
import '../services/firebase_db_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  AuthRepository(
    this._service, {
    FirebaseAuthService? firebaseAuth,
    FirebaseDbService? firebaseDb,
  })  : _firebaseAuth = firebaseAuth,
        _firebaseDb = firebaseDb;

  final AuthService _service;
  final FirebaseAuthService? _firebaseAuth;
  final FirebaseDbService? _firebaseDb;

  Future<UserModel> login({
    required String email,
    required String password,
  }) {
    if (_firebaseAuth == null) {
      return _service.login(email: email, password: password);
    }
    return _firebaseAuth!
        .login(email: email, password: password)
        .then((cred) async {
      final uid = cred.user?.uid ?? 'unknown';
      final snap = await _firebaseDb!.users().doc(uid).get();
      if (snap.exists) {
        final data = snap.data()!;
        return UserModel(
          id: uid,
          username: data['username'] ?? 'User',
          email: data['email'] ?? email,
          diamonds: (data['diamonds'] ?? 0) as int,
          role: _parseRole(data['role']),
        );
      }
      return UserModel(
        id: uid,
        username: email.split('@').first,
        email: email,
        diamonds: 0,
        role: UserRole.user,
      );
    });
  }

  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
  }) {
    if (_firebaseAuth == null) {
      return _service.register(
        username: username,
        email: email,
        password: password,
      );
    }
    return _firebaseAuth!
        .register(email: email, password: password)
        .then((cred) async {
      final uid = cred.user?.uid ?? 'unknown';
      await _firebaseDb!.users().doc(uid).set({
        'username': username,
        'email': email,
        'role': 'user',
        'diamonds': 100,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return UserModel(
        id: uid,
        username: username,
        email: email,
        diamonds: 100,
        role: UserRole.user,
      );
    });
  }

  Future<void> logout() {
    if (_firebaseAuth == null) return _service.logout();
    return _firebaseAuth!.logout();
  }

  UserRole _parseRole(dynamic role) {
    if (role == 'admin') return UserRole.admin;
    if (role == 'guest') return UserRole.guest;
    return UserRole.user;
  }
}
