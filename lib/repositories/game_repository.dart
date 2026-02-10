import '../models/game_result.dart';
import '../services/game_service.dart';
import '../services/firebase_db_service.dart';
import '../services/firebase_auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameRepository {
  GameRepository(
    this._service, {
    FirebaseDbService? firebaseDb,
    FirebaseAuthService? firebaseAuth,
  })  : _firebaseDb = firebaseDb,
        _firebaseAuth = firebaseAuth;

  final GameService _service;
  final FirebaseDbService? _firebaseDb;
  final FirebaseAuthService? _firebaseAuth;

  GameResult buildResult({
    required int timeSeconds,
    required int moves,
    required int bestCombo,
    required int gridCells,
  }) {
    return _service.buildResult(
      timeSeconds: timeSeconds,
      moves: moves,
      bestCombo: bestCombo,
      gridCells: gridCells,
    );
  }

  Future<void> saveResult(GameResult result) async {
    if (_firebaseDb == null || _firebaseAuth == null) {
      await Future.delayed(const Duration(milliseconds: 200));
      return;
    }
    final user = _firebaseAuth!.currentUser;
    if (user == null) return;
    final uid = user.uid;
    final userRef = _firebaseDb!.users().doc(uid);
    final userSnap = await userRef.get();
    final username = userSnap.data()?['username'] ?? 'User';
    final data = {
      'userId': uid,
      'username': username,
      'score': result.score,
      'timeSeconds': result.timeSeconds,
      'moves': result.moves,
      'bestCombo': result.bestCombo,
      'diamondsEarned': result.coinsEarned,
      'createdAt': FieldValue.serverTimestamp(),
    };
    await _firebaseDb!.results().add(data);
    final currentBest = (userSnap.data()?['bestScore'] ?? 0) as int;
    final nextBest = result.score > currentBest ? result.score : currentBest;
    await userRef.set(
      {
        'lastScore': result.score,
        'bestScore': nextBest,
        'gamesPlayed': FieldValue.increment(1),
        'totalScore': FieldValue.increment(result.score),
        'totalTimeSeconds': FieldValue.increment(result.timeSeconds),
        'totalMoves': FieldValue.increment(result.moves),
        'totalCardsFlipped': FieldValue.increment(result.moves * 2),
        'diamonds': FieldValue.increment(result.coinsEarned),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }
}
