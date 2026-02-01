import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:ggj2026repository/arena/arena_game.dart';

enum PlayerState { idle, walk_down, walk_top, walk_left, walk_right, dead }

class ArenaPlayer extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameRef<ArenaGame>, KeyboardHandler, CollisionCallbacks {
  Vector2? velocity;
  bool isDeviceSmartphoneInput = false;
  int horizontalDirection = 0;
  int verticalDirection = 0;
  
  ArenaPlayer({super.position})
      : super(
          size: Vector2(64, 64), // UBAH DI SINI untuk merubah besar gambar karakter
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    velocity = Vector2.zero();
    isDeviceSmartphoneInput = false;
    // Gunakan clone() agar benar-benar menyalin nilai posisi awal
    previousPosition = position.clone();

    final idleSheet = await Future.wait(
      List.generate(47, (i) => Sprite.load("character_idle/00${i.toString().padLeft(2,'0')}.png"))
    );

    final walkDownSheet = await Future.wait(
      List.generate(35, (i) => Sprite.load("character_walk/00${i.toString().padLeft(2,'0')}.png"))
    );

    final walkTopSheet = await Future.wait(
      List.generate(35, (i) => Sprite.load("character_walk_top/00${i.toString().padLeft(2,'0')}.png"))
    );

    final walkLeftSheet = await Future.wait(
      List.generate(35, (i) => Sprite.load("character_walk_left/00${i.toString().padLeft(2,'0')}.png"))
    );

    final walkRightSheet = await Future.wait(
      List.generate(35, (i) => Sprite.load("character_walk_right/00${i.toString().padLeft(2,'0')}.png"))
    );

    animations = {
      PlayerState.idle: SpriteAnimation.spriteList(idleSheet, stepTime: 0.1),
      PlayerState.walk_down: SpriteAnimation.spriteList(walkDownSheet, stepTime: 0.1),
      PlayerState.walk_top: SpriteAnimation.spriteList(walkTopSheet, stepTime: 0.1),
      PlayerState.walk_left: SpriteAnimation.spriteList(walkLeftSheet, stepTime: 0.1),
      PlayerState.walk_right: SpriteAnimation.spriteList(walkRightSheet, stepTime: 0.1),
    };

    current = PlayerState.idle;
    
    // Hitbox disesuaikan untuk ukuran 64x64
    add(RectangleHitbox(
      size: Vector2(30, 45), 
      position: Vector2(size.x / 2 - 15, size.y / 2 - 22.5),
    ));
  }

  Vector2 previousPosition = Vector2.zero();
  Vector2 touchDelta = Vector2.zero();

  void moveByTouchDelta(double dx, double dy) {
    isDeviceSmartphoneInput = true;
    const double sensitivity = 1.5; // Naikkan angka ini jika ingin lebih lincah
    touchDelta.add(Vector2(dx * sensitivity, dy * sensitivity));
  }

  // Helper untuk mendapatkan koordinat kotak badan (Hitbox) secara nyata
  Rect get _hitboxRect => Rect.fromCenter(
    center: position.toOffset(),
    width: 30, // Harus sama dengan ukuran hitbox di onLoad
    height: 45,
  );

  @override
  void update(double dt) {
    previousPosition.setFrom(position);
    super.update(dt);

    Vector2 delta = Vector2.zero();
    if (isDeviceSmartphoneInput) {
      if (!touchDelta.isZero()) {
        delta.setFrom(touchDelta);
      }
    } else {
      if (velocity != null && !velocity!.isZero()) {
        delta = velocity! * dt;
      }
    }

    if (!delta.isZero()) {
      // 1. Tentukan status animasi berdasarkan arah dominan
      if (delta.y < 0) {
        current = PlayerState.walk_top;
      } else if (delta.y > 0) {
        current = PlayerState.walk_down;
      } else if (delta.x < 0) {
        current = PlayerState.walk_left;
      } else if (delta.x > 0) {
        current = PlayerState.walk_right;
      }

      // Pastikan skala selalu normal (1) karena kita sudah menggunakan sprite terpisah untuk kiri/kanan
      scale.x = 1;

      // 1. Gerak Horizontal & Cek Tabrakan
      if (delta.x != 0) {
        position.x += delta.x;
        _checkHorizontalCollision(delta.x);
      }
      
      // 2. Gerak Vertical & Cek Tabrakan
      if (delta.y != 0) {
        position.y += delta.y;
        _checkVerticalCollision(delta.y);
      }
      
      if (isDeviceSmartphoneInput) touchDelta.setZero();
    } else {
      current = PlayerState.idle;
    }
  }

  void _checkHorizontalCollision(double dx) {
    // Gunakan _hitboxRect agar deteksinya presisi ke badan saja
    for (final block in gameRef.world.children.query<CollisionBlock>()) {
      if (_hitboxRect.overlaps(block.toRect())) {
        if (dx > 0) {
          // Menabrak dinding kanan -> berhenti tepat di tepi kiri dinding
          position.x = block.x - 15; // 15 adalah setengah lebar hitbox (30/2)
        } else if (dx < 0) {
          // Menabrak dinding kiri -> berhenti tepat di tepi kanan dinding
          position.x = block.x + block.width + 15;
        }
        if (!isDeviceSmartphoneInput) velocity?.x = 0;
      }
    }
  }

  void _checkVerticalCollision(double dy) {
    for (final block in gameRef.world.children.query<CollisionBlock>()) {
      if (_hitboxRect.overlaps(block.toRect())) {
        if (dy > 0) {
          // Menabrak bawah -> berhenti di tepi atas dinding
          position.y = block.y - 22.5; // 22.5 adalah setengah tinggi hitbox (45/2)
        } else if (dy < 0) {
          // Menabrak atas -> berhenti di tepi bawah dinding
          position.y = block.y + block.height + 22.5;
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
