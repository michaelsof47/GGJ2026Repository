import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:ggj2026repository/arena/arena_player.dart';

class ArenaGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  ArenaPlayer? player;
  TiledComponent? mapComponent;

  @override
  Color backgroundColor() => const Color(0xFF111111);

  @override
  FutureOr<void> onLoad() async {
    try {
      print('Loading map...');

      // final destTileSize = Vector2.all(100);
      // mapComponent = await TiledComponent.load('COBA.tmx', destTileSize);
      // mapComponent?.priority = 0;
      // world.add(mapComponent!);

      // final mapWidth = mapComponent!.tileMap.map.width * destTileSize.x;
      // final mapHeight = mapComponent!.tileMap.map.height * destTileSize.y;

      // print('Map loaded: Total size: ${mapWidth}x${mapHeight}');

      // Perbaikan: Gunakan try-get layer agar tidak crash jika tipe salah
      // try {
      //   final collisionLayer =
      //       mapComponent?.tileMap.getLayer<ObjectGroup>('Collisions');
      //   if (collisionLayer != null) {
      //     final originalTileSize = mapComponent!.tileMap.map
      //         .tileWidth; // Mengambil ukuran tile asli dari Tiled (misal 16)
      //     final scale = destTileSize.x /
      //         originalTileSize; // Rasio skala (misal 100 / 16 = 6.25)

      //     if (collisionLayer != null) {
      //       for (final object in collisionLayer.objects) {
      //         world.add(CollisionBlock(
      //           // Posisi dan size HARUS dikalikan dengan scale
      //           position: Vector2(object.x * scale, object.y * scale),
      //           size: Vector2(object.width * scale, object.height * scale),
      //         ));
      //       }
      //     }
      //   }
      // } catch (e) {
      //   print(
      //       'INFO: Collisions layer is not an ObjectGroup (TileLayer detected). Collision skipped. $e');
      // }

      // // 2. Spawn Player di tengah peta
      // player = ArenaPlayer(position: Vector2(mapWidth / 2, mapHeight / 2));
      // player?.priority = 10; // Pastikan di atas map
      // world.add(player!);

      // -- KAMERA SETUP --
      camera.viewfinder.anchor = Anchor.center;
      camera.viewfinder.zoom = 1.0;

      // PAKSA KAMERA KE PLAYER
      camera.viewfinder.position = player!.position;
      camera.follow(player!);
    } catch (e) {
      print('ERROR loading game: $e');
    }

    return super.onLoad();
  }

  @override
  bool get debugMode => true;
}

class CollisionBlock extends PositionComponent with CollisionCallbacks {
  CollisionBlock({required Vector2 position, required Vector2 size})
      : super(position: position, size: size) {
    add(RectangleHitbox()..collisionType = CollisionType.passive);
    debugMode = true;
  }
}
