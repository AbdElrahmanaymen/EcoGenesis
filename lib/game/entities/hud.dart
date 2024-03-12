import 'dart:async';

import 'package:ecogenesis/game/eco_genesis_game.dart';
import 'package:ecogenesis/utils/assets.dart';
import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';

class HUD extends PositionComponent with HasGameRef<EcoGensisGame> {
  HUD() : super() {}

  late final StateMachineController? controller;

  SMIInput<double>? _TimeInput;
  SMIInput<double>? _HealthInput;

  double time = 0;

  @override
  FutureOr<void> onLoad() async {
    final skillsArtboard = await loadArtboard(RiveFile.asset(Assets.HUD));
    controller = StateMachineController.fromArtboard(
      skillsArtboard,
      "State Machine 1",
    );

    if (controller != null) {
      skillsArtboard.addController(controller!);
      _TimeInput = controller?.findInput<double>('Time');
      _TimeInput?.value = 0;
      _HealthInput = controller?.findInput<double>('Health');
      _HealthInput?.value = 100;
    }

    add(RiveComponent(artboard: skillsArtboard, size: Vector2.all(120)));

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updateDayNightCycleHUD();
    super.update(dt);
  }

  void _updateDayNightCycleHUD() {
    _TimeInput?.value = time * 100;
  }
}
