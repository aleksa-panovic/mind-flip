import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../models/game_card.dart';
import '../models/game_result.dart';
import '../repositories/game_repository.dart';

class GameProvider extends ChangeNotifier {
  GameProvider(this._repo);

  final GameRepository _repo;

  final List<IconData> _icons = const [
    Icons.star,
    Icons.favorite,
    Icons.bolt,
    Icons.catching_pokemon,
    Icons.ac_unit,
    Icons.local_fire_department,
    Icons.emoji_events,
    Icons.pets,
    Icons.sports_esports,
    Icons.lightbulb,
    Icons.flight_takeoff,
    Icons.music_note,
    Icons.palette,
    Icons.color_lens,
    Icons.security,
    Icons.flash_on,
    Icons.water_drop,
    Icons.landscape,
    Icons.auto_awesome,
    Icons.emoji_objects,
    Icons.trending_up,
    Icons.explore,
  ];

  List<GameCardModel> cards = [];
  int gridSize = 4;
  int lastGridSize = 4;
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

  void startGame(int size) {
    gridSize = size;
    lastGridSize = size;
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
    final totalCards = gridSize * gridSize;
    final pairs = totalCards ~/ 2;
    final rand = Random();
    final icons = List<IconData>.from(_icons);
    icons.shuffle(rand);
    final selected = icons.take(pairs).toList();

    final List<GameCardModel> deck = [];
    int id = 0;
    for (var i = 0; i < pairs; i++) {
      deck.add(GameCardModel(id: id++, pairId: i, icon: selected[i]));
      deck.add(GameCardModel(id: id++, pairId: i, icon: selected[i]));
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
          gridSize: gridSize,
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
      if (matches == (gridSize * gridSize) ~/ 2) {
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
      gridSize: gridSize,
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
