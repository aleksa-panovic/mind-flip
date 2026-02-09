import 'package:flutter/material.dart';

class GameCardModel {
  GameCardModel({
    required this.id,
    required this.pairId,
    required this.icon,
  });

  final int id;
  final int pairId;
  final IconData icon;
  bool isFaceUp = false;
  bool isMatched = false;
}
