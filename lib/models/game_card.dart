class GameCardModel {
  GameCardModel({
    required this.id,
    required this.pairId,
    required this.assetPath,
  });

  final int id;
  final int pairId;
  final String assetPath;
  bool isFaceUp = false;
  bool isMatched = false;
}
