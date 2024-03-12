import 'dart:async';

import 'package:ecogenesis/game/eco_genesis_game.dart';
import 'package:ecogenesis/game/entities/plastic.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

// The PlayerState enum represents the different states of the player.
enum PlayerState { idle, walk }

// The PlayerDirection enum represents the different directions the player can move.
enum PlayerDirection {
  left,
  right,
  up,
  down,
  upLeft,
  upRight,
  downLeft,
  downRight,
  none
}

/// Represents a player entity in the game.
///
/// The [Player] class extends [SpriteAnimationGroupComponent] and implements [HasGameRef] to have access to the game reference.
/// It contains animations for idle and walking states, and provides methods to load and retrieve sprite animations.
class Player extends SpriteAnimationGroupComponent
    with HasGameRef<EcoGensisGame>, KeyboardHandler, CollisionCallbacks {
  // Animation variables
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation walkAnimation;

  final double stepTime = 0.05;

  // The current state of the player
  PlayerDirection playerDirection = PlayerDirection.none;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;

  // The direction of the collision
  PlayerDirection collidingDirection = PlayerDirection.none;

  @override
  FutureOr<void> onLoad() {
    // Load all animations
    _loadAllAnimations();

    // Add a hitbox to the player
    add(
      PolygonHitbox(
        [
          Vector2(0, 0),
          Vector2(0, 10),
          Vector2(50, 10),
          Vector2(50, 0),
        ],
        position: Vector2(0, 115),
      ),
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // Check if the player is moving in a direction
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);
    final isUpKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp);
    final isDownKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyS) ||
        keysPressed.contains(LogicalKeyboardKey.arrowDown);

    // Set the player direction based on the keys pressed
    if (isLeftKeyPressed && isRightKeyPressed) {
      playerDirection = PlayerDirection.none;
    } else if (isLeftKeyPressed && isUpKeyPressed) {
      playerDirection = PlayerDirection.upLeft;
    } else if (isLeftKeyPressed && isDownKeyPressed) {
      playerDirection = PlayerDirection.downLeft;
    } else if (isRightKeyPressed && isUpKeyPressed) {
      playerDirection = PlayerDirection.upRight;
    } else if (isRightKeyPressed && isDownKeyPressed) {
      playerDirection = PlayerDirection.downRight;
    } else if (isLeftKeyPressed) {
      playerDirection = PlayerDirection.left;
    } else if (isRightKeyPressed) {
      playerDirection = PlayerDirection.right;
    } else if (isUpKeyPressed) {
      playerDirection = PlayerDirection.up;
    } else if (isDownKeyPressed) {
      playerDirection = PlayerDirection.down;
    } else {
      playerDirection = PlayerDirection.none;
    }

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Plastic) {
      other.colidingWithPlayer();
      print('plastic');
    } else {
      if (velocity.x > 0 && velocity.y == 0) {
        collidingDirection = PlayerDirection.right;
      } else if (velocity.x < 0 && velocity.y == 0) {
        collidingDirection = PlayerDirection.left;
      } else if (velocity.y > 0 && velocity.x == 0) {
        collidingDirection = PlayerDirection.down;
      } else if (velocity.y < 0 && velocity.x == 0) {
        collidingDirection = PlayerDirection.up;
      } else if (velocity.x > 0 && velocity.y > 0) {
        collidingDirection = PlayerDirection.downRight;
      } else if (velocity.x > 0 && velocity.y < 0) {
        collidingDirection = PlayerDirection.upRight;
      } else if (velocity.x < 0 && velocity.y > 0) {
        collidingDirection = PlayerDirection.downLeft;
      } else if (velocity.x < 0 && velocity.y < 0) {
        collidingDirection = PlayerDirection.upLeft;
      }
    }

    super.onCollision(intersectionPoints, other);
  }

  /// Callback method called when the player's collision with another entity ends.
  ///
  /// This method sets the [collidingDirection] to [PlayerDirection.none]
  @override
  void onCollisionEnd(PositionComponent other) {
    collidingDirection = PlayerDirection.none;
    super.onCollisionEnd(other);
  }

  /// Loads all animations for the player entity.
  ///
  /// This method asynchronously loads the idle and walk animations for the player.
  /// It uses the [_spriteAnimation] method to load each animation with the specified parameters.
  /// The loaded animations are then added to the `animations` map, with the corresponding player state as the key.
  /// Finally, the current animation is set to idle.
  Future<void> _loadAllAnimations() async {
    // Load all animations
    idleAnimation = await _spriteAnimation('idle', 10, Vector2(49, 125));
    walkAnimation = await _spriteAnimation('walk', 10, Vector2(54, 129));

    // Add all animations to the animations map
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.walk: walkAnimation,
    };

    // Set the current animation to idle
    current = PlayerState.idle;
  }

  /// Returns a future [SpriteAnimation] based on the specified [animation], [amount], and [textureSize].
  ///
  /// The [animation] parameter represents the name of the animation.
  /// The [amount] parameter represents the number of frames in the animation.
  /// The [textureSize] parameter represents the size of each frame in the animation.
  ///
  /// This method loads the image for the specified animation and creates a [SpriteAnimation] using the loaded image.
  /// The [stepTime] parameter is used to determine the duration of each frame in the animation.
  ///
  /// Returns a future [SpriteAnimation] object.
  Future<SpriteAnimation> _spriteAnimation(
    String animation,
    int amount,
    Vector2 textureSize,
  ) async {
    final image = await gameRef.images.load('character/$animation.png');
    return SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: textureSize,
      ),
    );
  }

  /// Updates the player's movement based on the current player direction.
  ///
  /// The player's movement is determined by the [playerDirection] property.
  /// The player can move left, right, up, down, or diagonally.
  /// The [moveSpeed] property determines the speed at which the player moves.
  /// The player's position is updated based on the velocity and the elapsed time [dt].
  void _updatePlayerMovement(double dt) {
    var dirX = 0.0;
    var dirY = 0.0;

    // Update the player's position based on the current direction
    switch (playerDirection) {
      case PlayerDirection.left:
        // If the player is colliding with an entity from the left, stop moving
        if (isColliding && collidingDirection == PlayerDirection.left) {
          break;
        }
        // If the player is not facing left, flip the player horizontally
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        current = PlayerState.walk;
        dirX -= moveSpeed;
      case PlayerDirection.right:
        // If the player is colliding with an entity from the right, stop moving
        if (isColliding && collidingDirection == PlayerDirection.right) {
          break;
        }
        // If the player is not facing right, flip the player horizontally
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        current = PlayerState.walk;
        dirX += moveSpeed;
      case PlayerDirection.up:
        // If the player is colliding with an entity from the top, stop moving
        if (isColliding && collidingDirection == PlayerDirection.up) {
          break;
        }
        current = PlayerState.walk;
        dirY -= moveSpeed;
      case PlayerDirection.down:
        // If the player is colliding with an entity from the bottom, stop moving
        if (isColliding && collidingDirection == PlayerDirection.down) {
          break;
        }
        current = PlayerState.walk;
        dirY += moveSpeed;
      case PlayerDirection.upLeft:
        // If the player is colliding with an entity from the top left, stop moving
        if (isColliding && collidingDirection == PlayerDirection.upLeft) {
          break;
        }
        // If the player is not facing left, flip the player horizontally
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        current = PlayerState.walk;
        dirX -= moveSpeed;
        dirY -= moveSpeed;
      case PlayerDirection.upRight:
        // If the player is colliding with an entity from the top right, stop moving
        if (isColliding && collidingDirection == PlayerDirection.upRight) {
          break;
        }
        // If the player is not facing right, flip the player horizontally
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        current = PlayerState.walk;
        dirX += moveSpeed;
        dirY -= moveSpeed;
      case PlayerDirection.downLeft:
        // If the player is colliding with an entity from the bottom left, stop moving
        if (isColliding && collidingDirection == PlayerDirection.downLeft) {
          break;
        }
        // If the player is not facing left, flip the player horizontally
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        current = PlayerState.walk;
        dirX -= moveSpeed;
        dirY += moveSpeed;
      case PlayerDirection.downRight:
        // If the player is colliding with an entity from the bottom right, stop moving
        if (isColliding && collidingDirection == PlayerDirection.downRight) {
          break;
        }
        // If the player is not facing right, flip the player horizontally
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        current = PlayerState.walk;
        dirX += moveSpeed;
        dirY += moveSpeed;
      default:
        current = PlayerState.idle;
    }
    // Update the player's velocity and position
    velocity = Vector2(dirX, dirY);
    position += velocity * dt;
  }
}
