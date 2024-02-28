import 'dart:async';
import 'dart:ui';

import 'package:ecogenesis/game/entities/player.dart';
import 'package:ecogenesis/utils/assets.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/widgets.dart';

class EcoGensisGame extends FlameGame with HasKeyboardHandlerComponents {
  @override
  Color backgroundColor() => const Color(0xFF064273);

  static const srcTileSize = 64.0;

  @override
  FutureOr<void> onLoad() async {
    camera.viewfinder.zoom = 0.5;
    camera.viewfinder.anchor = Anchor.topLeft;

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
          final player = Player(Vector2(spawnPoint.x, spawnPoint.y));
          world.add(player);
          break;
        default:
      }
    }

    return super.onLoad();
  }
}
