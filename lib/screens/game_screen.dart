import 'dart:ui';

import 'package:ecogenesis/levels/level_one.dart';
import 'package:flame/camera.dart';
import 'package:flame/game.dart';

class EcoGensisGame extends FlameGame {
  @override
  Color backgroundColor() => const Color(0xFF000000);

  late final CameraComponent cam;

  final world = LevelOne();

  @override
  Future<void> onLoad() async {
    cam = CameraComponent.withFixedResolution(
      width: 1920,
      height: 1080,
      world: world,
    );

    addAll([
      cam,
      world,
    ]);
  }
}
