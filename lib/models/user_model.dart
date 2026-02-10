class UserModel {
  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.diamonds,
    this.bestScore = 0,
    this.lastScore = 0,
    this.gamesPlayed = 0,
    this.totalScore = 0,
    this.totalTimeSeconds = 0,
    this.totalMoves = 0,
    this.totalCardsFlipped = 0,
    required this.ownedFrontSets,
    required this.ownedBackSkins,
    required this.currentFrontSet,
    required this.currentBackSkin,
    this.role = UserRole.user,
  });

  final String id;
  final String username;
  final String email;
  final int diamonds;
  final int bestScore;
  final int lastScore;
  final int gamesPlayed;
  final int totalScore;
  final int totalTimeSeconds;
  final int totalMoves;
  final int totalCardsFlipped;
  final List<String> ownedFrontSets;
  final List<String> ownedBackSkins;
  final String currentFrontSet;
  final String currentBackSkin;
  final UserRole role;
}

enum UserRole { guest, user, admin }
