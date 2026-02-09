import 'package:flutter/material.dart';

import 'game_screen.dart';

class Game5x6Screen extends StatelessWidget {
  const Game5x6Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GameScreen(rows: 6, cols: 5);
  }
}
