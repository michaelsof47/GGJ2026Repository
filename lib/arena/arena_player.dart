import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ggj2026repository/arena/arena_game.dart';

class ArenaPlayer extends RectangleComponent
    with HasGameRef<ArenaGame>, KeyboardHandler, CollisionCallbacks {
  Vector2? velocity;
  var isDeviceSmartphoneInput;
  var horizontalDirection;
  var verticalDirection;
  ArenaPlayer({super.position})
      : super(
          size: Vector2.all(44),
          paint: Paint()..color = Colors.red,
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    velocity = Vector2.zero();
    add(RectangleHitbox());
    isDeviceSmartphoneInput = false;
    // Gunakan clone() agar benar-benar menyalin nilai posisi awal
    previousPosition = position.clone();
  }

  Vector2 previousPosition = Vector2.zero();
  Vector2 touchDelta = Vector2.zero();

  void moveByTouchDelta(double dx, double dy) {
    isDeviceSmartphoneInput = true;
    touchDelta.setValues(dx, dy);
  }

  @override
  void update(double dt) {
    // 1. Simpan posisi aman SEBELUM bergerak
    previousPosition.setFrom(position);

    super.update(dt);

    if (isDeviceSmartphoneInput) {
      if (!touchDelta.isZero()) {
        // Gunakan delta langsung
        position.add(touchDelta * 1.1);
        touchDelta.setZero();
      }
    } else {
      if (velocity != null && !velocity!.isZero()) {
        position += velocity! * dt;
      }
    }

    // 1. Hitung potensi posisi baru
    final displacement = velocity! * dt;
    
    // 2. Cek collision secara horizontal
    position.x += displacement.x;
    _checkHorizontalCollision();
    
    // 3. Cek collision secara vertikal
    position.y += displacement.y;
    _checkVerticalCollision();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is CollisionBlock) {
      position -= velocity!;
    }
  }

  void _checkHorizontalCollision() {
    for (final block in gameRef.world.children.query<CollisionBlock>()) {
      if (this.collidingWith(block)) {
        if (velocity!.x > 0) {
          // Bergerak ke kanan
          velocity?.x = 0;
          position.x = block.x - width;
        } else if (velocity!.x < 0) {
          // Bergerak ke kiri
          velocity?.x = 0;
          position.x = block.x + block.width;
        }
        break;
      }
    }
  }

  void _checkVerticalCollision() {
    for (final block in gameRef.world.children.query<CollisionBlock>()) {
      if (this.collidingWith(block)) {
        if (velocity!.y > 0) {
          // Bergerak ke bawah
          velocity?.y = 0;
          position.y = block.y - height;
        } else if (velocity!.y < 0) {
          // Bergerak ke atas
          velocity?.y = 0;
          position.y = block.y + block.height;
        }
        break;
      }
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keyPressed) {
    velocity?.setZero();
    isDeviceSmartphoneInput = false;
    const double speed = 150;
    if (keyPressed.contains(LogicalKeyboardKey.keyW)) velocity?.y -= speed;
    if (keyPressed.contains(LogicalKeyboardKey.keyS)) velocity?.y += speed;
    if (keyPressed.contains(LogicalKeyboardKey.keyA)) velocity?.x -= speed;
    if (keyPressed.contains(LogicalKeyboardKey.keyD)) velocity?.x += speed;
    return true;
  }
}
