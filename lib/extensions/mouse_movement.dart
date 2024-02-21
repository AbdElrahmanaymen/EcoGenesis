import 'package:flame/extensions.dart';

/// Extension method on [Vector2] that calculates the world camera transform.
///
/// The [viewport] parameter represents the size of the viewport.
/// The [viewfinder] parameter represents the position of the viewfinder.
/// The [zoom] parameter represents the zoom level.
///
/// Returns a new [Vector2] representing the transformed coordinates in the world.
extension CameraTransform on Vector2 {
  Vector2 worldCameraTransform(
    Vector2 viewport,
    Vector2 viewfinder,
    double zoom,
  ) {
    double worldX = (x - viewport.x / 2) / zoom + viewfinder.x;
    double worldY = (y - viewport.y / 2) / zoom + viewfinder.y;
    return Vector2(worldX, worldY);
  }
}
