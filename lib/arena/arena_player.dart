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
    previousPosition.setFrom(position);
    super.update(dt);

    Vector2 delta = Vector2.zero();
    if (isDeviceSmartphoneInput) {
      if (!touchDelta.isZero()) {
        delta.setFrom(touchDelta);
        // touchDelta.setZero(); // Keep delta for this frame
      }
    } else {
      if (velocity != null && !velocity!.isZero()) {
        delta = velocity! * dt;
      }
    }

    if (!delta.isZero()) {
      // 1. Move Horizontal
      position.x += delta.x;
      _checkHorizontalCollision(delta.x);
      
      // 2. Move Vertical
      position.y += delta.y;
      _checkVerticalCollision(delta.y);
      
      if (isDeviceSmartphoneInput) touchDelta.setZero();
    }
  }

  void _checkHorizontalCollision(double dx) {
    // Gunakan Rect untuk deteksi instan tanpa menunggu update hitbox Flame
    final playerRect = toRect();
    for (final block in gameRef.world.children.query<CollisionBlock>()) {
      if (playerRect.overlaps(block.toRect())) {
        if (dx > 0) {
          // Menabrak ke kanan -> Tempelkan ke sisi kiri blok
          position.x = block.x - (width / 2);
        } else if (dx < 0) {
          // Menabrak ke kiri -> Tempelkan ke sisi kanan blok
          position.x = block.x + block.width + (width / 2);
        }
        if (!isDeviceSmartphoneInput) velocity?.x = 0;
      }
    }
  }

  void _checkVerticalCollision(double dy) {
    final playerRect = toRect();
    for (final block in gameRef.world.children.query<CollisionBlock>()) {
      if (playerRect.overlaps(block.toRect())) {
        if (dy > 0) {
          // Menabrak ke bawah -> Tempelkan ke sisi atas blok
          position.y = block.y - (height / 2);
        } else if (dy < 0) {
          // Menabrak ke atas -> Tempelkan ke sisi bawah blok
          position.y = block.y + block.height + (height / 2);
        }
        if (!isDeviceSmartphoneInput) velocity?.y = 0;
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
