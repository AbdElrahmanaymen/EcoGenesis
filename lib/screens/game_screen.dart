import 'dart:async';
import 'dart:ui';

import 'package:ecogenesis/component/selector_component.dart';
import 'package:ecogenesis/utils/assets.dart';
import 'package:ecogenesis/utils/generate_tiled_map.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import '../extensions//mouse_movement.dart';

class EcoGensisGame extends FlameGame
    with MouseMovementDetector, ScaleDetector {
  @override
  Color backgroundColor() => const Color(0xFF064273);

  final topLeft = Vector2.all(0);
  static const scale = 2.0;
  static const srcTileSize = 32.0;
  static const destTileSize = scale * srcTileSize;

  static const halfSize = true;
  static const tileHeight = scale * (halfSize ? 8.0 : 16.0);

  late IsometricTileMapComponent map;
  late Selector selector;

  late double startZoom;

  @override
  FutureOr<void> onLoad() async {
    camera.viewfinder.zoom = 0.5;
    camera.viewfinder.position = Vector2(0, 700);

    final tilesetImage = await images.load(Assets.spriteSheet);
    final tileset = SpriteSheet(
      image: tilesetImage,
      srcSize: Vector2.all(srcTileSize),
    );

    final matrix = generateTiledMap(50, 50);

    map = IsometricTileMapComponent(
      tileset,
      matrix,
      destTileSize: Vector2.all(destTileSize),
      tileHeight: tileHeight,
      position: topLeft,
    );

    final selectorImage = await images.load(Assets.selectorShort);
    selector = Selector(destTileSize, selectorImage);

    world.addAll([
      map,
      selector,
    ]);

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
    final block = map.getBlock(screenPosition);
    selector.show = map.containsBlock(block);
    selector.position.setFrom(map.getBlockRenderPosition(block));

    super.onMouseMove(info);
  }
}
