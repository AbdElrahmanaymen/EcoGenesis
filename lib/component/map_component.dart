import 'package:flame_oxygen/flame_oxygen.dart' show Component;
import 'package:flame_tiled/flame_tiled.dart';

class MapInit {
  final TiledComponent tiledComponent;

  const MapInit(this.tiledComponent);

  factory MapInit.load(
    TiledComponent tiledComponent,
  ) {
    return MapInit(tiledComponent);
  }
}

class MapComponent extends Component<MapInit> {
  late TiledComponent? tiledComponent;

  @override
  void init([MapInit? data]) => tiledComponent = data?.tiledComponent;

  @override
  void reset() => tiledComponent = null;
}
