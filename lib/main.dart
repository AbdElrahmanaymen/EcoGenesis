import 'package:ecogenesis/screens/game_screen.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    GameWidget(
      game: EcoGensisGame(),
    ),
  );
}
