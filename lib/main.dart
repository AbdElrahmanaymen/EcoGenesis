import 'package:ecogenesis/game/eco_genesis_game.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  runApp(
    GameWidget(
      game: EcoGensisGame(),
    ),
  );
}
