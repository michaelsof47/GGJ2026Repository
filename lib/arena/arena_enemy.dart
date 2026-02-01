import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:ggj2026repository/arena/arena_game.dart';
import 'package:ggj2026repository/arena/arena_player.dart';

enum EnemyState { walk_down, walk_top }

class ArenaEnemy extends SpriteAnimationGroupComponent<EnemyState>
    with HasGameRef<ArenaGame>, CollisionCallbacks {
  Vector2? moveRange;
  double speed;

  Vector2? startPosition;
  double direction = 1;
  Vector2? velocity;

  ArenaEnemy({
    required Vector2 position,
    required Vector2 size,
    required this.moveRange,
    this.speed = 100.0,
  }) : super(
          position: position,
          size: size,
          anchor: Anchor.center, // Gunakan center agar konsisten dengan player
        );

  @override
  Future<void> onLoad() async {
    priority = 50;
    startPosition = position.clone();
    velocity = Vector2(0.0, speed);

    final walkSheet = await Future.wait(List.generate(
        35,
        (i) =>
            Sprite.load("enemy_walk/00${i.toString().padLeft(2, '0')}.png")));

    final walkTopSheet = await Future.wait(List.generate(
        35,
        (i) => Sprite.load(
            "enemy_walk_top/00${i.toString().padLeft(2, '0')}.png")));

    animations = {
      EnemyState.walk_down:
          SpriteAnimation.spriteList(walkSheet, stepTime: 0.1),
      EnemyState.walk_top:
          SpriteAnimation.spriteList(walkTopSheet, stepTime: 0.1),
    };

    current = EnemyState.walk_down;

    // Hitbox musuh disesuaikan 30x45 (sama seperti player)
    add(RectangleHitbox(
      size: Vector2(30, 45),
      position: Vector2(size.x / 2 - 15, size.y / 2 - 22.5),
    ));
  }

  // Helper untuk mendapatkan koordinat kotak badan musuh
  Rect get _hitboxRect => Rect.fromCenter(
        center: position.toOffset(),
        width: 30,
        height: 45,
      );

  @override
  void update(double dt) {
    super.update(dt);

    if (moveRange != null && moveRange!.y > 0) {
      // Logic patrol: ganti arah hanya jika mencapai batas DAN masih bergerak ke arah tersebut
      if (position.y >= startPosition!.y + moveRange!.y && direction > 0) {
        direction = -1;
      } else if (position.y <= startPosition!.y - moveRange!.y &&
          direction < 0) {
        direction = 1;
      }
    }

    velocity?.y = direction * speed;

    if (velocity != null) {
      double dy = velocity!.y * dt;
      position.y += dy;
      _checkVerticalCollision(dy);
    }

    // Update animasi
    current = direction < 0 ? EnemyState.walk_top : EnemyState.walk_down;
  }

  void _checkVerticalCollision(double dy) {
    for (final block in gameRef.world.children.query<CollisionBlock>()) {
      if (_hitboxRect.overlaps(block.toRect())) {
        if (dy > 0) {
          // Nabrak bawah -> stop di tepi atas tembok & balik arah
          position.y = block.y - 22.5;
          direction = -1;
        } else if (dy < 0) {
          // Nabrak atas -> stop di tepi bawah tembok & balik arah
          position.y = block.y + block.height + 22.5;
          direction = 1;
        }
        velocity?.y = direction * speed;
      }
    }
  }

  // DI DALAM FILE arena_enemy.dart
  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is ArenaPlayer) {
      // PASTIKAN HANYA MEMANGGIL die()
      other.die();
      // JANGAN ADA other.respawn() DI SINI!
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}
