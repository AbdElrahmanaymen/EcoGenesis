import 'dart:async';
import 'dart:io';

import 'package:ecogenesis/game/entities/player.dart';
import 'package:ecogenesis/utils/assets.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/widgets.dart';

class EcoGensisGame extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  late final JoystickComponent joystick;
  final Player player = Player();

  static const srcTileSize = 64.0;

  bool showControls = Platform.isAndroid || Platform.isIOS;

  @override
  FutureOr<void> onLoad() async {
    camera.viewfinder.zoom = 0.5;
    camera.viewfinder.anchor = Anchor.topLeft;

    _loadMap();

    if (showControls) {
      addJoystick();
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    // updateJoytick();
  }

  /// Adds a joystick to the game.
  ///
  /// This method loads the knob and background images for the joystick from the specified file paths.
  /// It then creates a [JoystickComponent] with the loaded images and sets its margin and priority.
  /// Finally, it adds the joystick to the game.
  void addJoystick() async {
    final knobImage = await images.load('HUD/Joystick/knob.png');
    final backgroundImage = await images.load('HUD/Joystick/background.png');
    joystick = JoystickComponent(
      knob: SpriteComponent.fromImage(knobImage),
      background: SpriteComponent.fromImage(backgroundImage),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
      priority: 10,
    );
    camera.viewport.add(joystick);
    // add(joystick);
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
        break;
      case JoystickDirection.right:
        player.playerDirection = PlayerDirection.right;
        break;
      case JoystickDirection.down:
        player.playerDirection = PlayerDirection.down;
        break;
      case JoystickDirection.left:
        player.playerDirection = PlayerDirection.left;
        break;
      case JoystickDirection.downLeft:
        player.playerDirection = PlayerDirection.downLeft;
        break;
      case JoystickDirection.downRight:
        player.playerDirection = PlayerDirection.downRight;
        break;
      case JoystickDirection.upLeft:
        player.playerDirection = PlayerDirection.upLeft;
        break;
      case JoystickDirection.upRight:
        player.playerDirection = PlayerDirection.upRight;
        break;
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
  void _loadMap() async {
    final tiledMap = await TiledComponent.load(
      Assets.map,
      Vector2.all(srcTileSize),
    );

    world.add(tiledMap);

    final spawnPointsLayer =
        tiledMap.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    for (final spawnPoint in spawnPointsLayer!.objects) {
      switch (spawnPoint.class_) {
        case 'Player':
          player.position = Vector2(spawnPoint.x, spawnPoint.y);
          world.add(player);
          break;
        default:
      }
    }
  }
}
