import 'package:flame/components.dart' show CameraComponent;
import 'package:flame_oxygen/flame_oxygen.dart';

class CamInit {
  final CameraComponent cameraComponent;

  const CamInit(this.cameraComponent);

  factory CamInit.load(
    CameraComponent cameraComponent,
  ) {
    return CamInit(cameraComponent);
  }
}

class CamComponent extends Component<CamInit> {
  late CameraComponent? cameraComponent;

  @override
  void init([CamInit? data]) => cameraComponent = data?.cameraComponent;

  @override
  void reset() => cameraComponent = null;
}
