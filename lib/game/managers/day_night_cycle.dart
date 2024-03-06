import 'dart:async';
import 'dart:ui';

import 'package:ecogenesis/game/eco_genesis_game.dart';
import 'package:ecogenesis/utils/constants.dart';
import 'package:flame/components.dart';

class DayNightCycle extends PositionComponent with HasGameRef<EcoGensisGame> {
  // The duration of the day-night cycle
  double totalTimeElapsed = 0;
  double cycleProgress = 0;

  late final FragmentProgram program;

  DayNightCycle() : super(position: Vector2.zero());

  @override
  FutureOr<void> onLoad() async {
    // Load the fragment program from the asset
    program = await FragmentProgram.fromAsset('shaders/day_night.frag');
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updateDayNightCycle(dt);
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    // Get the fragment shader from the program
    final shader = program.fragmentShader();

    // Set the cycle progress as a uniform in the fragment shader
    shader.setFloat(0, cycleProgress);

    // Create a paint object with the shader and blend mode
    final paint = Paint()
      ..shader = shader
      ..blendMode = BlendMode.modulate;

    // Draw a rectangle with the shader applied to the canvas
    canvas
      ..save()
      ..drawRect(
        Offset.zero & game.size.toSize(),
        paint,
      )
      ..restore();

    super.render(canvas);
  }

  /// Updates the day-night cycle based on the elapsed time.
  ///
  /// This method is responsible for updating the total time elapsed and calculating
  /// the current position in the day-night cycle. It takes the elapsed time in seconds
  /// as a parameter and updates the [totalTimeElapsed] and [cycleProgress] variables accordingly.
  ///
  /// The [totalTimeElapsed] variable keeps track of the total time that has passed since
  /// the start of the day-night cycle. The [cycleProgress] variable represents the current
  /// position in the day-night cycle as a value between 0 and 1, where 0 represents the start
  /// of the cycle and 1 represents the end of the cycle.
  void _updateDayNightCycle(double dt) {
    // Update the total time elapsed
    totalTimeElapsed += dt;

    // Calculate the current position in the day-night cycle
    cycleProgress = totalTimeElapsed % cycleDuration / cycleDuration;
  }
}
