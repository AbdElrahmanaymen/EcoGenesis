import 'dart:async';
import 'dart:ui';

import 'package:ecogenesis/component/cam_component.dart';
import 'package:ecogenesis/component/map_component.dart';
import 'package:ecogenesis/system/map_system.dart';
import 'package:flame/game.dart';
import 'package:flame_oxygen/flame_oxygen.dart';
import 'package:flame_tiled/flame_tiled.dart';

class MyGame extends OxygenGame {
  @override
  Color backgroundColor() => const Color(0xFF064273);

  @override
  Future<void> init() async {
    world.registerComponent(MapComponent.new);
    world.registerComponent(CamComponent.new);
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

  // late final CameraComponent cam;

  // @override
  // final world = Map();

  // @override
  // Future<void> onLoad() async {
  //   cam = CameraComponent.withFixedResolution(
  //     width: 3280,
  //     height: 1900,
  //     world: world,
  //   );

  //   cam.viewfinder.anchor = Anchor.topLeft;
  //   cam.viewfinder.zoom = 1;

  //   addAll([
  //     world,
  //     cam,
  //   ]);
  // }
}
