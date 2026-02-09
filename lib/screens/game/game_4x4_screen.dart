import 'package:flutter/material.dart';

import 'game_screen.dart';

class Game4x4Screen extends StatelessWidget {
  const Game4x4Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GameScreen(rows: 4, cols: 4);
  }
}
