import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:ggj2026repository/arena/arena_player.dart';

import 'package:flame/sprite.dart';

class ArenaGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  ArenaPlayer? player;
  TiledComponent? mapComponent;

  @override
  Color backgroundColor() => const Color(0xFF111111);

  @override
  FutureOr<void> onLoad() async {
    try {
      print('DEBUG: Starting onLoad');
      
      // 1. Load background image (tile_1.png)
      final bgImage = await images.load('map.png');
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
        position: Vector2(0, 0),
        size: Vector2(960, 60),
      ));
      // Tembok Bawah
      world.add(CollisionBlock(
        position: Vector2(0, 580),
        size: Vector2(960, 60),
      ));
      // Tembok Kiri
      world.add(CollisionBlock(
        position: Vector2(0, 0),
        size: Vector2(60, 640),
      ));
      // Tembok Kanan
      world.add(CollisionBlock(
        position: Vector2(900, 0),
        size: Vector2(60, 640),
      ));

      // 3. Spawn Player di tengah arena
      player = ArenaPlayer(position: Vector2(480, 320));
      player!.priority = 100; // Pastikan paling atas
      world.add(player!);
      print('DEBUG: Player added to world at (480, 320)');

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

class CollisionBlock extends SpriteComponent with HasGameRef<ArenaGame> {
  CollisionBlock({required Vector2 position, required Vector2 size})
      : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    try {
      // 1. Load gambar (Gunakan map.png)
      final image = await gameRef.images.load('map.png');

      // 2. Buat SpriteSheet
      final spriteSheet = SpriteSheet.fromColumnsAndRows(
        image: image,
        columns: 5,
        rows: 1,
      );

      // 3. Ambil sprite
      sprite = spriteSheet.getSprite(0, 0);

    } catch (e) {
      print('DEBUG: Fallback for CollisionBlock: $e');
    }

    // 5. Tambahkan Hitbox
    add(RectangleHitbox()..collisionType = CollisionType.passive);
    
    // Matikan debugMode jika sudah yakin pas posisinya
    debugMode = false; 
    
    // Jika asset gagal, beri warna agar tetap terlihat temboknya
    if (sprite == null) {
       paint = Paint()..color = const Color(0x88808080);
    }
  }
}
