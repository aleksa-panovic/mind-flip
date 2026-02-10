import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SkinProvider extends ChangeNotifier {
  SkinProvider() {
    _load();
  }

  String currentFrontSet = 'emoji';
  String currentBackSkin = 'default';
  int diamonds = 2450;

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
    if (!ownedFrontSets.contains(key)) return false;
    if (currentFrontSet == key) return true;
    currentFrontSet = key;
    _save();
    notifyListeners();
    return true;
  }

  bool setBack(String key) {
    if (!ownedBackSkins.contains(key)) return false;
    if (currentBackSkin == key) return true;
    currentBackSkin = key;
    _save();
    notifyListeners();
    return true;
  }

  bool buyFront(String key, int price) {
    if (ownedFrontSets.contains(key)) return false;
    if (diamonds < price) return false;
    diamonds -= price;
    ownedFrontSets.add(key);
    _save();
    notifyListeners();
    return true;
  }

  bool buyBack(String key, int price) {
    if (ownedBackSkins.contains(key)) return false;
    if (diamonds < price) return false;
    diamonds -= price;
    ownedBackSkins.add(key);
    _save();
    notifyListeners();
    return true;
  }

  void addDiamonds(int amount) {
    if (amount <= 0) return;
    diamonds += amount;
    _save();
    notifyListeners();
  }

  void setDiamonds(int value) {
    diamonds = value;
    _save();
    notifyListeners();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    diamonds = prefs.getInt('diamonds') ?? 2450;
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
}
