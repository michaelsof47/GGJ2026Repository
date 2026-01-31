import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:ggj2026repository/arena/arena_enemy.dart';
import 'package:ggj2026repository/arena/arena_player.dart';

import 'package:flame/sprite.dart';

class ArenaGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  ArenaPlayer? player;
  @override
  Color backgroundColor() => const Color(0xFF111111);

  @override
  FutureOr<void> onLoad() async {
    try {
      print('DEBUG: Starting onLoad');

      // 1. Load background image (tile_1.png)
      final bgImage = await images.load('map_new.png');
      final background = SpriteComponent(
        sprite: Sprite(bgImage),
        size: Vector2(960, 640),
        priority: -1, // Pastikan paling bawah
      );
      world.add(background);
      print('DEBUG: Background tile_1.png added at priority -1');

      // 2. Tambahkan Tembok Pembatas (Manual)
      // Tembok Atas
      world.add(CollisionBlock(
        position: Vector2(0, -40),
        size: Vector2(960, 40),
      ));
      // Tembok Bawah
      world.add(CollisionBlock(
        position: Vector2(0, 640),
        size: Vector2(960, 40),
      ));
      // Tembok Kiri
      world.add(CollisionBlock(
        position: Vector2(-40, 0),
        size: Vector2(40, 640),
      ));
      // Tembok Kanan
      world.add(CollisionBlock(
        position: Vector2(960, 0),
        size: Vector2(40, 640),
      ));
      //Tembok 1
      world.add(CollisionBlock(
        position: Vector2(0, 145),
        size: Vector2(390, 60),
      ));
      //Tembok 2
      world.add(CollisionBlock(
        position: Vector2(390, 75),
        size: Vector2(95, 263),
      ));
      //Tembok 3
      world.add(CollisionBlock(
        position: Vector2(485, 208),
        size: Vector2(95, 130),
      ));
      //Tembok 4
      world.add(CollisionBlock(
        position: Vector2(187, 310),
        size: Vector2(98, 330),
      ));
      //Tembok 5
      world.add(CollisionBlock(
        position: Vector2(560, 437),
        size: Vector2(400, 130),
      ));
      //Tembok 6
      world.add(CollisionBlock(
        position: Vector2(652, 122),
        size: Vector2(308, 66),
      ));

      // 3. Spawn Player di lokasi yang aman
      player = ArenaPlayer(position: Vector2(100, 400));
      player!.priority = 100; // Pastikan paling atas
      world.add(player!);
      print('DEBUG: Player added to world at (480, 320)');

      world.add(ArenaEnemy(
        position: Vector2(400, 450),
        size: Vector2(64, 64),
        moveRange: Vector2(400, 140),
        speed: 70,
      ));

      // -- KAMERA SETUP --
      camera.viewfinder.anchor = Anchor.center;
      camera.viewfinder.zoom = 1.0;

      if (player != null) {
        // Paksa kamera langsung lihat ke player agar tidak "tersesat" di awal
        camera.viewfinder.position = player!.position;
        camera.follow(player!);
        print('DEBUG: Camera forced to player position');
      }
    } catch (e, stackTrace) {
      print('ERROR loading game details: $e');
      print('Stack trace: $stackTrace');
    }

    return super.onLoad();
  }

  @override
  bool get debugMode => true;
}

class CollisionBlock extends PositionComponent with HasGameRef<ArenaGame> {
  CollisionBlock({required Vector2 position, required Vector2 size})
      : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Tembok ini sekarang "gaib" (PositionComponent),
    // jadi tidak butuh load gambar atau sprite lagi.

    // Tambahkan Hitbox untuk deteksi tabrakan
    add(RectangleHitbox()..collisionType = CollisionType.passive);

    // debugMode bisa dinyalakan (true) jika ingin melihat garis pink pembatasnya,
    // atau matikan (false) jika ingin benar-benar bersih.
    debugMode = false;
  }
}
