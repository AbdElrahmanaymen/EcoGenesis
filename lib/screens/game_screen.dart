import 'dart:async';
import 'dart:ui';

import 'package:ecogenesis/component/selector_component.dart';
import 'package:ecogenesis/utils/assets.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame/widgets.dart';
import 'package:flame_isometric/custom_isometric_tile_map_component.dart';
import 'package:flame_isometric/flame_isometric.dart';
import 'package:flutter/widgets.dart';
import '../extensions//mouse_movement.dart';

class EcoGensisGame extends FlameGame
    with MouseMovementDetector, ScaleDetector {
  @override
  Color backgroundColor() => const Color(0xFF064273);

  static const scale = 2.0;
  static const srcTileSize = 132;
  static const destTileSize = scale * srcTileSize;

  static const tileHeight = scale * 66;

  // late TiledComponent terrain;
  late Selector selector;

  late double startZoom;

  @override
  FutureOr<void> onLoad() async {
    camera.viewfinder.zoom = 0.5;
    camera.viewfinder.position = Vector2(300, 700);

    final selectorImage = await images.load(Assets.selectorShort);
    selector = Selector(132, selectorImage);

    world.add(selector);

    final landscapeImage = await images.load(Assets.landscapeTileSet);
    final landscapeSpriteSheet = SpriteSheet(
      image: landscapeImage,
      srcSize: Vector2(132, 99),
    );

    final flameIsometric = await FlameIsometric.create(
      tmx: 'tiles/terrain.tmx',
      tileMap: 'landscape_tileset.png',
    );

    for (var renderLayer in flameIsometric.renderLayerList) {
      world.add(
        CustomIsometricTileMapComponent(
          landscapeSpriteSheet,
          renderLayer.matrix,
          destTileSize: flameIsometric.srcTileSize,
          tileHeight: 66,
        ),
      );
    }

    return super.onLoad();
  }

  @override
  void onScaleStart(info) {
    startZoom = camera.viewfinder.zoom;
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    final currentScale = info.scale.global;
    if (!currentScale.isIdentity()) {
      camera.viewfinder.zoom = startZoom * currentScale.y;
      clampZoom();
    } else {
      camera.viewfinder.position += info.delta.global;
    }
  }

  void clampZoom() {
    camera.viewfinder.zoom = camera.viewfinder.zoom.clamp(0.05, 3.0);
  }

  @override
  void onMouseMove(PointerHoverInfo info) {
    final screenPosition = info.eventPosition.global.worldCameraTransform(
      camera.viewport.size,
      camera.viewfinder.position,
      camera.viewfinder.zoom,
    );
    final map =
        world.children.whereType<CustomIsometricTileMapComponent>().last;

    final block = map.getBlock(screenPosition);
    selector.show = map.containsBlock(block);
    selector.position.setFrom(map.getBlockRenderPosition(block));
    selector.priority = 1;
    // selector.position
    //     .setFrom(map.getBlockRenderPosition(block) + Vector2(40, 0));

    super.onMouseMove(info);
  }
}
