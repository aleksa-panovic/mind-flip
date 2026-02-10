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
}
