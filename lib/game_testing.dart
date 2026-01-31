import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';

class MyGameTesting extends FlameGame {
  late TiledComponent mapComponent;
  late RectangleComponent player; // Benda yang akan kita gerakkan

  @override
  Future<void> onLoad() async {
    // 1. Masukkan Map dari Tiled
    // Ganti 'map_kamu.tmx' dengan nama file map milikmu
    mapComponent = await TiledComponent.load('map_kamu.tmx', Vector2(16, 16));
    add(mapComponent);

    // 2. Buat benda bergerak (Player Testing)
    player = RectangleComponent(
      position: Vector2(100, 100),
      size: Vector2(32, 32),
      paint: Paint()..color = Colors.red, // Kotak merah untuk testing
    );
    add(player);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // 3. Logika bergerak (Contoh: gerak ke kanan terus menerus)
    player.x += 50 * dt;

    // Jika ingin balik lagi kalau mentok layar
    if (player.x > size.x) {
      player.x = 0;
    }
  }
}
