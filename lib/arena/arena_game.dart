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

      // 1. Load background image
      final bgImage = await images.load('map_new.png');
      final background = SpriteComponent(
        sprite: Sprite(bgImage),
        size: Vector2(960, 640),
        priority: -1,
      );
      world.add(background);

      // 2. Tambahkan Tembok Pembatas
      _addCollisionBlocks();

      // 3. Tambahkan Area Menang (Karpet)
      final winArea = WinArea(
        position: Vector2(0, 50),
        size: Vector2(64, 64),
      );
      world.add(winArea);

      // 4. Spawn Player
      player = ArenaPlayer(position: Vector2(100, 600));
      player!.priority = 100;
      world.add(player!);

      // 5. Spawn Enemies
      _spawnEnemies();

      // -- KAMERA SETUP --
      camera.viewfinder.anchor = Anchor.center;
      camera.viewfinder.zoom = 1.0;

      if (player != null) {
        camera.viewfinder.position = player!.position;
        camera.follow(player!);
      }
    } catch (e, stackTrace) {
      print('ERROR loading game details: $e');
      print('Stack trace: $stackTrace');
    }

    return super.onLoad();
  }

  // --- FUNGSI KONTROL OVERLAY ---
  void showWinScreen() {
    overlays.add('WinMenu'); // Munculkan pop-up
    pauseEngine(); // Berhentikan game agar musuh diam
  }

  void restartGame() {
    overlays.remove('WinMenu'); // Hapus pop-up
    resumeEngine(); // Jalankan game lagi
    player?.respawn(); // Kembalikan player ke posisi awal
  }

  void _addCollisionBlocks() {
    world
        .add(CollisionBlock(position: Vector2(0, -40), size: Vector2(960, 40)));
    world
        .add(CollisionBlock(position: Vector2(0, 640), size: Vector2(960, 40)));
    world
        .add(CollisionBlock(position: Vector2(-40, 0), size: Vector2(40, 640)));
    world
        .add(CollisionBlock(position: Vector2(960, 0), size: Vector2(40, 640)));
    world
        .add(CollisionBlock(position: Vector2(0, 145), size: Vector2(390, 60)));
    world.add(
        CollisionBlock(position: Vector2(390, 75), size: Vector2(95, 263)));
    world.add(
        CollisionBlock(position: Vector2(485, 208), size: Vector2(95, 130)));
    world.add(
        CollisionBlock(position: Vector2(187, 310), size: Vector2(98, 330)));
    world.add(
        CollisionBlock(position: Vector2(560, 437), size: Vector2(400, 130)));
    world.add(
        CollisionBlock(position: Vector2(652, 122), size: Vector2(308, 66)));
  }

  void _spawnEnemies() {
    world.add(ArenaEnemy(
      position: Vector2(340.0, 450.0),
      size: Vector2(64.0, 64.0),
      moveRange: Vector2(400.0, 260.0),
      speed: 70.0,
    ));
    world.add(ArenaEnemy(
      position: Vector2(630.0, 350.0),
      size: Vector2(64.0, 64.0),
      moveRange: Vector2(400.0, 400.0),
      speed: 70.0,
    ));
  }

  @override
  bool get debugMode => true;
}

class WinArea extends SpriteComponent
    with HasGameRef<ArenaGame>, CollisionCallbacks {
  WinArea({required Vector2 position, required Vector2 size})
      : super(position: position, size: size, priority: 0);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('Karpet.png');
    add(RectangleHitbox()..collisionType = CollisionType.passive);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is ArenaPlayer) {
      gameRef.showWinScreen(); // Panggil overlay saat tersentuh
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}

class CollisionBlock extends PositionComponent with HasGameRef<ArenaGame> {
  CollisionBlock({required Vector2 position, required Vector2 size})
      : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox()..collisionType = CollisionType.passive);
    debugMode = false;
  }
}
