import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

/// A class representing a rectangle collision component.
///
/// This class extends the [PositionComponent] class and adds a rectangle hitbox
/// to enable collision detection with other entities in the game.
///
/// Used for the houses and other rectangular objects
class RectangleCollision extends PositionComponent {
  RectangleCollision({required Vector2 size, required Vector2 position})
      : super(size: size, position: position);

  @override
  FutureOr<void> onLoad() {
    add(
      RectangleHitbox(
        size: size,
        isSolid: true,
        collisionType: CollisionType.passive,
      ),
    );
    return super.onLoad();
  }
}

/// A class representing a circle collision component.
///
/// This class extends the [PositionComponent] class and adds a rectangle hitbox
/// to enable collision detection with other entities in the game.
///
/// Used for Trees, Barrels and other circular objects
class CircleCollision extends PositionComponent {
  CircleCollision({required Vector2 size, required Vector2 position})
      : super(size: size, position: position);

  @override
  FutureOr<void> onLoad() {
    add(
      CircleHitbox(
        collisionType: CollisionType.passive,
      ),
    );
    return super.onLoad();
  }
}
