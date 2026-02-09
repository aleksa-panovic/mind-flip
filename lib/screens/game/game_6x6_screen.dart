import 'package:flutter/material.dart';

import 'game_screen.dart';

class Game6x6Screen extends StatelessWidget {
  const Game6x6Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GameScreen(gridSize: 6);
  }
}
