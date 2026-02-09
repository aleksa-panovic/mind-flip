import '../models/game_result.dart';

class GameService {
  GameResult buildResult({
    required int timeSeconds,
    required int moves,
    required int bestCombo,
    required int gridCells,
  }) {
    // Basic scoring formula for KT2. Replace with backend rules in KT3.
    final base = gridCells * 50;
    final timePenalty = timeSeconds * 2;
    final movePenalty = moves * 3;
    final comboBonus = bestCombo * 25;
    final score = (base - timePenalty - movePenalty + comboBonus).clamp(0, 99999);
    final coins = (score / 7).round();
    return GameResult(
      score: score,
      timeSeconds: timeSeconds,
      moves: moves,
      bestCombo: bestCombo,
      coinsEarned: coins,
    );
  }
}
