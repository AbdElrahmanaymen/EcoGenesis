import 'dart:async';
import 'dart:ui';

import 'package:ecogenesis/component/map_component.dart';
import 'package:ecogenesis/system/map_system.dart';
import 'package:flame/components.dart' show Vector2;
import 'package:flame_oxygen/flame_oxygen.dart' show OxygenGame;
import 'package:flame_tiled/flame_tiled.dart' show TiledComponent;

class MyGame extends OxygenGame {
  @override
  Color backgroundColor() => const Color(0xFF064273);

  @override
  Future<void> init() async {
    world.registerComponent(MapComponent.new);
    world.registerSystem(MapSystem());

    createEntity(
      position: Vector2.zero(),
      size: Vector2(128, 75),
    ).add<MapComponent, MapInit>(
      MapInit(
        await TiledComponent.load(
          'map.tmx',
          Vector2(128, 75),
        ),
      ),
    );
  }
}
