import 'dart:async';

import 'package:ecogenesis/game/eco_genesis_game.dart';
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
    with HasGameRef<EcoGensisGame>, KeyboardHandler {
  // Animation variables
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation walkAnimation;

  final double stepTime = 0.05;

  PlayerDirection playerDirection = PlayerDirection.none;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
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

  /// Loads all animations for the player entity.
  ///
  /// This method asynchronously loads the idle and walk animations for the player.
  /// It uses the [_spriteAnimation] method to load each animation with the specified parameters.
  /// The loaded animations are then added to the `animations` map, with the corresponding player state as the key.
  /// Finally, the current animation is set to idle.
  void _loadAllAnimations() async {
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
    double dirX = 0.0;
    double dirY = 0.0;
    switch (playerDirection) {
      case PlayerDirection.left:
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        current = PlayerState.walk;
        dirX -= moveSpeed;
        break;
      case PlayerDirection.right:
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        current = PlayerState.walk;
        dirX += moveSpeed;
        break;
      case PlayerDirection.up:
        current = PlayerState.walk;
        dirY -= moveSpeed;
        break;
      case PlayerDirection.down:
        current = PlayerState.walk;
        dirY += moveSpeed;
        break;
      case PlayerDirection.upLeft:
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        current = PlayerState.walk;
        dirX -= moveSpeed;
        dirY -= moveSpeed;
        break;
      case PlayerDirection.upRight:
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        current = PlayerState.walk;
        dirX += moveSpeed;
        dirY -= moveSpeed;
        break;
      case PlayerDirection.downLeft:
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        current = PlayerState.walk;
        dirX -= moveSpeed;
        dirY += moveSpeed;
        break;
      case PlayerDirection.downRight:
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        current = PlayerState.walk;
        dirX += moveSpeed;
        dirY += moveSpeed;
        break;
      default:
        current = PlayerState.idle;
    }
    velocity = Vector2(dirX, dirY);
    position += velocity * dt;
  }
}
