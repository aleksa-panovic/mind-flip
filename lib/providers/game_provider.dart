import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../models/game_card.dart';
import '../models/game_result.dart';
import '../repositories/game_repository.dart';

class GameProvider extends ChangeNotifier {
  GameProvider(this._repo);

  final GameRepository _repo;

  final List<String> _icons = const [
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
  ];

  List<GameCardModel> cards = [];
  int rows = 4;
  int cols = 4;
  int lastRows = 4;
  int lastCols = 4;
  int moves = 0;
  int matches = 0;
  int timeSeconds = 0;
  int bestCombo = 0;
  int _currentCombo = 0;
  bool isBusy = false;
  bool gameOver = false;
  GameResult? result;

  int? _firstIndex;
  Timer? _timer;

  void startGame({required int rows, required int cols}) {
    this.rows = rows;
    this.cols = cols;
    lastRows = rows;
    lastCols = cols;
    moves = 0;
    matches = 0;
    timeSeconds = 0;
    bestCombo = 0;
    _currentCombo = 0;
    isBusy = false;
    gameOver = false;
    result = null;
    _firstIndex = null;
    _buildDeck();
    _startTimer();
    notifyListeners();
  }

  void _buildDeck() {
    final totalCards = rows * cols;
    final pairs = totalCards ~/ 2;
    final rand = Random();
    final icons = List<String>.from(_icons);
    icons.shuffle(rand);
    final selected = icons.take(pairs).toList();

    final List<GameCardModel> deck = [];
    int id = 0;
    for (var i = 0; i < pairs; i++) {
      deck.add(GameCardModel(id: id++, pairId: i, assetPath: selected[i]));
      deck.add(GameCardModel(id: id++, pairId: i, assetPath: selected[i]));
    }
    deck.shuffle(rand);
    cards = deck;
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!gameOver) {
        timeSeconds++;
        notifyListeners();
      }
    });
  }

  String get formattedTime {
    final m = timeSeconds ~/ 60;
    final s = timeSeconds % 60;
    return '${m.toString().padLeft(1, '0')}:${s.toString().padLeft(2, '0')}';
  }

  int get currentScore {
    return _repo
        .buildResult(
          timeSeconds: timeSeconds,
          moves: moves,
          bestCombo: bestCombo,
          gridCells: rows * cols,
        )
        .score;
  }

  Future<void> flipCard(int index) async {
    if (gameOver || isBusy) return;
    if (index < 0 || index >= cards.length) return;
    final card = cards[index];
    if (card.isMatched || card.isFaceUp) return;

    card.isFaceUp = true;
    notifyListeners();

    if (_firstIndex == null) {
      _firstIndex = index;
      return;
    }

    moves += 1;
    isBusy = true;
    notifyListeners();

    final first = cards[_firstIndex!];
    if (first.pairId == card.pairId) {
      first.isMatched = true;
      card.isMatched = true;
      matches += 1;
      _currentCombo += 1;
      if (_currentCombo > bestCombo) bestCombo = _currentCombo;
      _firstIndex = null;
      isBusy = false;
      notifyListeners();
      if (matches == (rows * cols) ~/ 2) {
        _finishGame();
      }
      return;
    }

    _currentCombo = 0;
    await Future.delayed(const Duration(milliseconds: 650));
    first.isFaceUp = false;
    card.isFaceUp = false;
    _firstIndex = null;
    isBusy = false;
    notifyListeners();
  }

  void _finishGame() {
    gameOver = true;
    _timer?.cancel();
    result = _repo.buildResult(
      timeSeconds: timeSeconds,
      moves: moves,
      bestCombo: bestCombo,
      gridCells: rows * cols,
    );
    notifyListeners();
    if (result != null) {
      _repo.saveResult(result!);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
