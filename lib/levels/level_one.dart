import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class LevelOne extends World {
  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('assets/tiles/map.tmx', Vector2.all(32));
    add(level);
    return super.onLoad();
  }
}
