import 'dart:async';

import 'package:ecogenesis/game/eco_genesis_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Plastic extends SpriteAnimationComponent
    with HasGameRef<EcoGensisGame>, CollisionCallbacks {
  Plastic(Vector2 position)
      : super(
          size: Vector2(64, 64),
          position: position,
        );

  @override
  FutureOr<void> onLoad() async {
    final image = await gameRef.images.load('plastic_bottle.png');
    animation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 0.05,
        textureSize: Vector2(64, 64),
      ),
    );

    add(RectangleHitbox(position: Vector2(0, 0), size: size));

    return super.onLoad();
  }

  void colidingWithPlayer() {
    super.removeFromParent();
  }
}
