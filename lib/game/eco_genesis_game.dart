import 'dart:async';
import 'dart:io';

import 'package:ecogenesis/game/entities/collisions.dart';
import 'package:ecogenesis/game/entities/player.dart';
import 'package:ecogenesis/game/entities/day_night_cycle.dart';
import 'package:ecogenesis/utils/assets.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/widgets.dart';

class EcoGensisGame extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection {
  // The joystick component
  late final JoystickComponent joystick;

  late final TiledComponent<FlameGame<World>> tiledMap;

  // The player object
  final Player player = Player()..priority = 1000;

  // The size of each tile in the map
  static const srcTileSize = 64.0;

  // Show controls on mobile platforms
  bool showControls = Platform.isAndroid || Platform.isIOS;

  @override
  FutureOr<void> onLoad() async {
    // Load the map and initialize the game objects
    await _loadMap();

    // Add the joystick to the game
    if (showControls) {
      await addJoystick();
    }

    // Set the camera configuration
    _setupCamera();

    // Add Shaders
    camera.viewport.add(DayNightCycle());

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // Update the joystick
    if (showControls) {
      updateJoytick();
    }

    super.update(dt);
  }

  /// Adds a joystick to the game.
  ///
  /// This method loads the knob and background images for the joystick from the specified file paths.
  /// It then creates a [JoystickComponent] with the loaded images and sets its margin and priority.
  /// Finally, it adds the joystick to the game.
  Future<void> addJoystick() async {
    final knobImage = await images.load('HUD/Joystick/knob.png');
    final backgroundImage = await images.load('HUD/Joystick/background.png');
    joystick = JoystickComponent(
      knob: SpriteComponent.fromImage(knobImage),
      background: SpriteComponent.fromImage(backgroundImage),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
      priority: 10,
    );
    camera.viewport.add(joystick);
  }

  /// Updates the player's direction based on the current joystick direction.
  ///
  /// The [joystick] parameter represents the current joystick direction.
  /// The player's direction is updated accordingly using a switch statement.
  /// If the joystick direction is [JoystickDirection.up], the player's direction is set to [PlayerDirection.up].
  /// If the joystick direction is [JoystickDirection.right], the player's direction is set to [PlayerDirection.right].
  /// If the joystick direction is [JoystickDirection.down], the player's direction is set to [PlayerDirection.down].
  /// If the joystick direction is [JoystickDirection.left], the player's direction is set to [PlayerDirection.left].
  /// If the joystick direction is [JoystickDirection.downLeft], the player's direction is set to [PlayerDirection.downLeft].
  /// If the joystick direction is [JoystickDirection.downRight], the player's direction is set to [PlayerDirection.downRight].
  /// If the joystick direction is [JoystickDirection.upLeft], the player's direction is set to [PlayerDirection.upLeft].
  /// If the joystick direction is [JoystickDirection.upRight], the player's direction is set to [PlayerDirection.upRight].
  /// If the joystick direction is none of the above, the player's direction is set to [PlayerDirection.none].
  void updateJoytick() {
    switch (joystick.direction) {
      case JoystickDirection.up:
        player.playerDirection = PlayerDirection.up;
      case JoystickDirection.right:
        player.playerDirection = PlayerDirection.right;
      case JoystickDirection.down:
        player.playerDirection = PlayerDirection.down;
      case JoystickDirection.left:
        player.playerDirection = PlayerDirection.left;
      case JoystickDirection.downLeft:
        player.playerDirection = PlayerDirection.downLeft;
      case JoystickDirection.downRight:
        player.playerDirection = PlayerDirection.downRight;
      case JoystickDirection.upLeft:
        player.playerDirection = PlayerDirection.upLeft;
      case JoystickDirection.upRight:
        player.playerDirection = PlayerDirection.upRight;
      default:
        player.playerDirection = PlayerDirection.none;
    }
  }

  /// Loads the map and initializes the game objects.
  ///
  /// This method loads a Tiled map using the [TiledComponent.load] method and adds it to the game world.
  /// It also retrieves the spawn points layer from the map and places the player object at the specified spawn point.
  ///
  /// The [Assets.map] parameter specifies the path to the map file.
  /// The [srcTileSize] parameter specifies the size of each tile in the map.
  ///
  Future<void> _loadMap() async {
    tiledMap = await TiledComponent.load(
      Assets.map,
      Vector2.all(srcTileSize),
    );

    world.add(tiledMap);

    final spawnPointsLayer =
        tiledMap.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    for (final spawnPoint in spawnPointsLayer?.objects ?? <TiledObject>[]) {
      switch (spawnPoint.class_) {
        case 'Player':
          player.position = Vector2(spawnPoint.x, spawnPoint.y);
          world.add(player);
        default:
      }
    }

    final collisionsLayer =
        tiledMap.tileMap.getLayer<ObjectGroup>('Collisions');

    for (final collision in collisionsLayer?.objects ?? <TiledObject>[]) {
      switch (collision.class_) {
        case 'rectangle':
          world.add(
            RectangleCollision(
              size: Vector2(collision.width, collision.height),
              position: Vector2(collision.x, collision.y),
            ),
          );
        case 'circle':
          world.add(
            CircleCollision(
              size: Vector2(collision.width, collision.height),
              position: Vector2(collision.x, collision.y),
            ),
          );
        default:
      }
    }
  }

  /// Sets up the camera for the game.
  void _setupCamera() {
    final worldSizeX = tiledMap.size.x / 2;
    final worldSizeY = tiledMap.size.y / 2;

    // Set the camera bounds to the center of the world with the same size as the world.
    camera
      ..setBounds(
        Rectangle.fromCenter(
          center: Vector2(worldSizeX, worldSizeY),
          size: Vector2(worldSizeX, worldSizeY),
        ),
      )

      // Make the camera follow the player.
      ..follow(player);
  }
}
