import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../services/firebase_auth_service.dart';
import '../services/firebase_db_service.dart';

class SkinProvider extends ChangeNotifier {
  SkinProvider({
    FirebaseDbService? firebaseDb,
    FirebaseAuthService? firebaseAuth,
  })  : _firebaseDb = firebaseDb,
        _firebaseAuth = firebaseAuth {
    _load();
  }

  final FirebaseDbService? _firebaseDb;
  final FirebaseAuthService? _firebaseAuth;

  String currentFrontSet = 'emoji';
  String currentBackSkin = 'default';
  int diamonds = 100;

  final Set<String> ownedFrontSets = {'emoji'};
  final Set<String> ownedBackSkins = {'default'};

  static const Map<String, List<String>> frontSets = {
    'emoji': [
      'assets/card_skins/emoji_skin/e1.png',
      'assets/card_skins/emoji_skin/e2.png',
      'assets/card_skins/emoji_skin/e3.png',
      'assets/card_skins/emoji_skin/e4.png',
      'assets/card_skins/emoji_skin/e5.png',
      'assets/card_skins/emoji_skin/e6.png',
      'assets/card_skins/emoji_skin/e7.png',
      'assets/card_skins/emoji_skin/e8.png',
      'assets/card_skins/emoji_skin/e9.png',
      'assets/card_skins/emoji_skin/e10.png',
      'assets/card_skins/emoji_skin/e11.png',
      'assets/card_skins/emoji_skin/e12.png',
      'assets/card_skins/emoji_skin/e13.png',
      'assets/card_skins/emoji_skin/e14.png',
      'assets/card_skins/emoji_skin/e15.png',
      'assets/card_skins/emoji_skin/e16.png',
      'assets/card_skins/emoji_skin/e17.png',
      'assets/card_skins/emoji_skin/e18.png',
    ],
    'animal': [
      'assets/card_skins/animal_skin/a1.png',
      'assets/card_skins/animal_skin/a2.png',
      'assets/card_skins/animal_skin/a3.png',
      'assets/card_skins/animal_skin/a4.png',
      'assets/card_skins/animal_skin/a5.png',
      'assets/card_skins/animal_skin/a6.png',
      'assets/card_skins/animal_skin/a7.png',
      'assets/card_skins/animal_skin/a8.png',
      'assets/card_skins/animal_skin/a9.png',
      'assets/card_skins/animal_skin/a10.png',
      'assets/card_skins/animal_skin/a11.png',
      'assets/card_skins/animal_skin/a12.png',
      'assets/card_skins/animal_skin/a13.png',
      'assets/card_skins/animal_skin/a14.png',
      'assets/card_skins/animal_skin/a15.png',
      'assets/card_skins/animal_skin/a16.png',
      'assets/card_skins/animal_skin/a17.png',
      'assets/card_skins/animal_skin/a18.png',
    ],
    'space': [
      'assets/card_skins/space_skin/s1.png',
      'assets/card_skins/space_skin/s2.png',
      'assets/card_skins/space_skin/s3.png',
      'assets/card_skins/space_skin/s4.png',
      'assets/card_skins/space_skin/s6.png',
      'assets/card_skins/space_skin/s7.png',
      'assets/card_skins/space_skin/s8.png',
      'assets/card_skins/space_skin/s9.png',
      'assets/card_skins/space_skin/s10.png',
      'assets/card_skins/space_skin/s11.png',
      'assets/card_skins/space_skin/s13.png',
      'assets/card_skins/space_skin/s14.png',
      'assets/card_skins/space_skin/s15.png',
      'assets/card_skins/space_skin/s16.png',
      'assets/card_skins/space_skin/s17.png',
      'assets/card_skins/space_skin/s18.png',
      'assets/card_skins/space_skin/s6-removebg-preview.png',
    ],
    'sport': [
      'assets/card_skins/sport_skin/Sp1.png',
      'assets/card_skins/sport_skin/sp2.png',
      'assets/card_skins/sport_skin/sp3.png',
      'assets/card_skins/sport_skin/sp4.png',
      'assets/card_skins/sport_skin/sp5.png',
      'assets/card_skins/sport_skin/sp6.png',
      'assets/card_skins/sport_skin/sp7.png',
      'assets/card_skins/sport_skin/sp8.png',
      'assets/card_skins/sport_skin/sp9.png',
      'assets/card_skins/sport_skin/sp10.png',
      'assets/card_skins/sport_skin/sp11.png',
      'assets/card_skins/sport_skin/sp12.png',
      'assets/card_skins/sport_skin/sp13.png',
      'assets/card_skins/sport_skin/sp14.png',
      'assets/card_skins/sport_skin/sp15.png',
      'assets/card_skins/sport_skin/sp16.png',
      'assets/card_skins/sport_skin/sp17.png',
      'assets/card_skins/sport_skin/sp18.png',
    ],
  };

  static const Map<String, String> backSkins = {
    'default': 'assets/back_skins/default_skin.png',
    'galaxy': 'assets/back_skins/galaxy_skin.png',
    'nature': 'assets/back_skins/nature skin.png',
    'lava': 'assets/back_skins/lava_skin.png',
  };

  List<String> get currentFrontAssets =>
      frontSets[currentFrontSet] ?? frontSets['emoji']!;

  String get currentBackAsset =>
      backSkins[currentBackSkin] ?? backSkins['default']!;

  bool setFront(String key) {
    final normalized = key.toLowerCase();
    if (!ownedFrontSets.contains(normalized)) return false;
    if (currentFrontSet == normalized) return true;
    currentFrontSet = normalized;
    _save();
    notifyListeners();
    return true;
  }

  bool setBack(String key) {
    final normalized = key.toLowerCase();
    if (!ownedBackSkins.contains(normalized)) return false;
    if (currentBackSkin == normalized) return true;
    currentBackSkin = normalized;
    _save();
    notifyListeners();
    return true;
  }

  Future<bool> setFrontRemote(String key) async {
    if (!setFront(key)) return false;
    if (_firebaseDb == null || _firebaseAuth == null) return true;
    final user = _firebaseAuth!.currentUser;
    if (user == null) return true;
    await _firebaseDb!.users().doc(user.uid).set(
      {
        'currentFrontSet': key,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
    return true;
  }

  Future<bool> setBackRemote(String key) async {
    if (!setBack(key)) return false;
    if (_firebaseDb == null || _firebaseAuth == null) return true;
    final user = _firebaseAuth!.currentUser;
    if (user == null) return true;
    await _firebaseDb!.users().doc(user.uid).set(
      {
        'currentBackSkin': key,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
    return true;
  }

  bool buyFront(String key, int price) {
    final normalized = key.toLowerCase();
    if (ownedFrontSets.contains(normalized)) return false;
    if (diamonds < price) return false;
    diamonds -= price;
    ownedFrontSets.add(normalized);
    _save();
    notifyListeners();
    return true;
  }

  Future<bool> buyFrontRemote(String key, double price) async {
    final normalized = key.toLowerCase();
    if (ownedFrontSets.contains(normalized)) return true;
    if (_firebaseDb == null || _firebaseAuth == null) {
      ownedFrontSets.add(normalized);
      _save();
      notifyListeners();
      return true;
    }
    final user = _firebaseAuth!.currentUser;
    if (user == null) return false;
    final userRef = _firebaseDb!.users().doc(user.uid);
    final purchaseRef = _firebaseDb!.purchases().doc();
    await userRef.set(
      {
        'ownedFrontSets': FieldValue.arrayUnion([normalized]),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
    await purchaseRef.set({
      'userId': user.uid,
      'itemType': 'front_skin',
      'itemKey': normalized,
      'price': price,
      'currency': 'usd',
      'createdAt': FieldValue.serverTimestamp(),
    });
    ownedFrontSets.add(normalized);
    notifyListeners();
    return true;
  }

  bool buyBack(String key, int price) {
    final normalized = key.toLowerCase();
    if (ownedBackSkins.contains(normalized)) return false;
    if (diamonds < price) return false;
    diamonds -= price;
    ownedBackSkins.add(normalized);
    _save();
    notifyListeners();
    return true;
  }

  Future<bool> buyBackRemote(String key, int price) async {
    final normalized = key.toLowerCase();
    if (_firebaseDb == null || _firebaseAuth == null) {
      return buyBack(normalized, price);
    }
    final user = _firebaseAuth!.currentUser;
    if (user == null) return false;
    if (ownedBackSkins.contains(normalized)) return true;
    final userRef = _firebaseDb!.users().doc(user.uid);
    final purchaseRef = _firebaseDb!.purchases().doc();
    try {
      await FirebaseFirestore.instance.runTransaction((tx) async {
        final snap = await tx.get(userRef);
        final data = snap.data() ?? <String, dynamic>{};
        final current = _readInt(data['diamonds'], 0);
        final owned = _readList(data['ownedBackSkins'], const <String>[]);
        if (owned.contains(normalized)) return;
        if (current < price) {
          throw StateError('not-enough');
        }
        tx.set(
          userRef,
          {
            'diamonds': current - price,
            'ownedBackSkins': FieldValue.arrayUnion([normalized]),
            'updatedAt': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );
        tx.set(
          purchaseRef,
          {
            'userId': user.uid,
            'itemType': 'back_skin',
            'itemKey': normalized,
            'price': price,
            'currency': 'diamonds',
            'createdAt': FieldValue.serverTimestamp(),
          },
        );
      });
      diamonds = (diamonds - price).clamp(0, 1 << 31).toInt();
      ownedBackSkins.add(normalized);
      notifyListeners();
      return true;
    } on StateError {
      return false;
    } catch (_) {
      return false;
    }
  }

  void addDiamonds(int amount) {
    if (amount <= 0) return;
    diamonds += amount;
    _save();
    notifyListeners();
  }

  Future<void> addDiamondsRemote(int amount) async {
    if (amount <= 0) return;
    if (_firebaseDb == null || _firebaseAuth == null) {
      addDiamonds(amount);
      return;
    }
    final user = _firebaseAuth!.currentUser;
    if (user == null) {
      addDiamonds(amount);
      return;
    }
    await _firebaseDb!.users().doc(user.uid).set(
      {
        'diamonds': FieldValue.increment(amount),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
    diamonds += amount;
    notifyListeners();
  }

  void setDiamonds(int value) {
    diamonds = value;
    _save();
    notifyListeners();
  }

  void syncFromUser(UserModel user) {
    diamonds = user.diamonds;
    currentFrontSet = user.currentFrontSet.toLowerCase();
    currentBackSkin = user.currentBackSkin.toLowerCase();
    ownedFrontSets
      ..clear()
      ..addAll(user.ownedFrontSets.map((e) => e.toLowerCase()));
    ownedBackSkins
      ..clear()
      ..addAll(user.ownedBackSkins.map((e) => e.toLowerCase()));
    _save();
    notifyListeners();
  }

  void resetToDefaults() {
    diamonds = 100;
    currentFrontSet = 'emoji';
    currentBackSkin = 'default';
    ownedFrontSets
      ..clear()
      ..add('emoji');
    ownedBackSkins
      ..clear()
      ..add('default');
    _save();
    notifyListeners();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    diamonds = prefs.getInt('diamonds') ?? 100;
    currentFrontSet = prefs.getString('currentFrontSet') ?? 'emoji';
    currentBackSkin = prefs.getString('currentBackSkin') ?? 'default';
    final front = prefs.getStringList('ownedFrontSets') ?? ['emoji'];
    final back = prefs.getStringList('ownedBackSkins') ?? ['default'];
    ownedFrontSets
      ..clear()
      ..addAll(front);
    ownedBackSkins
      ..clear()
      ..addAll(back);
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('diamonds', diamonds);
    await prefs.setString('currentFrontSet', currentFrontSet);
    await prefs.setString('currentBackSkin', currentBackSkin);
    await prefs.setStringList('ownedFrontSets', ownedFrontSets.toList());
    await prefs.setStringList('ownedBackSkins', ownedBackSkins.toList());
  }

  int _readInt(dynamic value, int fallback) {
    if (value is num) return value.toInt();
    return fallback;
  }

  List<String> _readList(dynamic value, List<String> fallback) {
    if (value is Iterable) {
      return value.whereType<String>().toList();
    }
    return fallback;
  }
}
