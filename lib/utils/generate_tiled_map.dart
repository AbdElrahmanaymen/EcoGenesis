List<List<int>> generateTiledMap(int width, int height) {
  return List.generate(
    height,
    (y) => List.generate(
      width,
      (x) => 0,
    ),
  );
}
