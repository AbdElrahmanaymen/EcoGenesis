import 'dart:ui';

import 'package:ecogenesis/component/map_component.dart';
import 'package:flame_oxygen/flame_oxygen.dart';

class MapSystem extends BaseSystem {
  @override
  List<Filter<Component>> get filters => [Has<MapComponent>()];

  @override
  void renderEntity(Canvas canvas, Entity entity) {
    final map = entity.get<MapComponent>()?.tiledComponent;

    map?.render(canvas);
  }
}
