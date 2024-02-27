import 'dart:ui';

import 'package:flame/components.dart';

class Selector extends SpriteComponent {
  bool show = false;
  Selector(double size, Image image)
      : super(
          sprite: Sprite(image, srcSize: Vector2.all(32)),
          size: Vector2(132, 99),
        );

  @override
  void render(Canvas canvas) {
    show = true;

    if (!show) {
      return;
    }
    super.render(canvas);
  }
}
