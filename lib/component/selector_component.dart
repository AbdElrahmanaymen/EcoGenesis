import 'dart:ui';

import 'package:flame/components.dart';

class Selector extends SpriteComponent {
  bool show = true;
  Selector(double size, Image image)
      : super(
          sprite: Sprite(image, srcSize: Vector2.all(32)),
          size: Vector2.all(size),
        );

  @override
  void render(Canvas canvas) {
    if (!show) {
      return;
    }
    super.render(canvas);
  }
}
