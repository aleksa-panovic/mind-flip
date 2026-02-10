import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDbService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> users() => _db.collection('users');
  CollectionReference<Map<String, dynamic>> results() =>
      _db.collection('results');
  CollectionReference<Map<String, dynamic>> shopItems() =>
      _db.collection('shop_items');
  CollectionReference<Map<String, dynamic>> purchases() =>
      _db.collection('purchases');

  Stream<Map<String, dynamic>?> userStream(String uid) {
    return users().doc(uid).snapshots().map((d) => d.data());
  }

  Stream<List<Map<String, dynamic>>> topLeaderboard({int limit = 50}) {
    return results()
        .orderBy('score', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).toList());
  }

  Stream<List<Map<String, dynamic>>> purchasesForUser(
    String userId, {
    int limit = 10,
  }) {
    return purchases()
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).toList());
  }
}
