import 'dart:async';
import 'dart:ui';

import 'package:ecogenesis/game/eco_genesis_game.dart';
import 'package:flame/components.dart';

class DayNightCycleShader extends PositionComponent
    with HasGameRef<EcoGensisGame> {
  double time = 0;
  late final FragmentProgram program;

  DayNightCycleShader()
      : super(
          position: Vector2.zero(),
        );

  @override
  FutureOr<void> onLoad() async {
    program = await FragmentProgram.fromAsset('shaders/day_night.frag');

    return super.onLoad();
  }

  @override
  void update(double dt) {
    time += dt;
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    final shader = program.fragmentShader();
    shader.setFloat(0, game.size.x);
    shader.setFloat(1, game.size.y);
    shader.setFloat(2, 1.0);
    shader.setFloat(3, 1.0);
    shader.setFloat(4, 0);

    final paint = Paint()
      ..shader = shader
      ..blendMode = BlendMode.darken;
    canvas
      ..save()
      ..drawRect(
        Offset.zero & game.size.toSize(),
        paint,
      )
      ..restore();
    super.render(canvas);
  }
}
