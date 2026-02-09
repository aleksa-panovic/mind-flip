class GameResult {
  const GameResult({
    required this.score,
    required this.timeSeconds,
    required this.moves,
    required this.bestCombo,
    required this.coinsEarned,
  });

  final int score;
  final int timeSeconds;
  final int moves;
  final int bestCombo;
  final int coinsEarned;
}
