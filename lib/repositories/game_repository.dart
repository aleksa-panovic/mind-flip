import '../models/game_result.dart';
import '../services/game_service.dart';

class GameRepository {
  GameRepository(this._service);

  final GameService _service;

  GameResult buildResult({
    required int timeSeconds,
    required int moves,
    required int bestCombo,
    required int gridSize,
  }) {
    return _service.buildResult(
      timeSeconds: timeSeconds,
      moves: moves,
      bestCombo: bestCombo,
      gridSize: gridSize,
    );
  }

  Future<void> saveResult(GameResult result) async {
    // TODO(KT3): send result to backend.
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
