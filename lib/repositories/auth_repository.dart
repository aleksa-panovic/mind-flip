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
        final ownedFront =
            _readList(data['ownedFrontSets'], const ['emoji']);
        final ownedBack = _readList(data['ownedBackSkins'], const ['default']);
        final currentFront =
            _readString(data['currentFrontSet'], 'emoji');
        final currentBack =
            _readString(data['currentBackSkin'], 'default');
        return UserModel(
          id: uid,
          username: data['username'] ?? 'User',
          email: data['email'] ?? email,
          diamonds: _readInt(data['diamonds'], 0),
          bestScore: _readInt(data['bestScore'], 0),
          lastScore: _readInt(data['lastScore'], 0),
          gamesPlayed: _readInt(data['gamesPlayed'], 0),
          totalScore: _readInt(data['totalScore'], 0),
          totalTimeSeconds: _readInt(data['totalTimeSeconds'], 0),
          totalMoves: _readInt(data['totalMoves'], 0),
          totalCardsFlipped: _readInt(data['totalCardsFlipped'], 0),
          ownedFrontSets: ownedFront,
          ownedBackSkins: ownedBack,
          currentFrontSet: currentFront,
          currentBackSkin: currentBack,
          role: _parseRole(data['role']),
        );
      }
      return UserModel(
        id: uid,
        username: email.split('@').first,
        email: email,
        diamonds: 0,
        bestScore: 0,
        lastScore: 0,
        gamesPlayed: 0,
        totalScore: 0,
        totalTimeSeconds: 0,
        totalMoves: 0,
        totalCardsFlipped: 0,
        ownedFrontSets: const ['emoji'],
        ownedBackSkins: const ['default'],
        currentFrontSet: 'emoji',
        currentBackSkin: 'default',
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
        'bestScore': 0,
        'lastScore': 0,
        'gamesPlayed': 0,
        'totalScore': 0,
        'totalTimeSeconds': 0,
        'totalMoves': 0,
        'totalCardsFlipped': 0,
        'ownedFrontSets': ['emoji'],
        'ownedBackSkins': ['default'],
        'currentFrontSet': 'emoji',
        'currentBackSkin': 'default',
        'createdAt': FieldValue.serverTimestamp(),
      });
      return UserModel(
        id: uid,
        username: username,
        email: email,
        diamonds: 100,
        bestScore: 0,
        lastScore: 0,
        gamesPlayed: 0,
        totalScore: 0,
        totalTimeSeconds: 0,
        totalMoves: 0,
        totalCardsFlipped: 0,
        ownedFrontSets: const ['emoji'],
        ownedBackSkins: const ['default'],
        currentFrontSet: 'emoji',
        currentBackSkin: 'default',
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

  int _readInt(dynamic value, int fallback) {
    if (value is num) return value.toInt();
    return fallback;
  }

  String _readString(dynamic value, String fallback) {
    if (value is String && value.isNotEmpty) return value;
    return fallback;
  }

  List<String> _readList(dynamic value, List<String> fallback) {
    if (value is Iterable) {
      return value.whereType<String>().toList();
    }
    return fallback;
  }
}
