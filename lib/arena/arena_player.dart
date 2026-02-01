import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:ggj2026repository/arena/arena_game.dart';
import 'package:ggj2026repository/arena/arena_enemy.dart';

enum PlayerState { idle, walk_down, walk_top, walk_left, walk_right, dead }

class ArenaPlayer extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameRef<ArenaGame>, KeyboardHandler, CollisionCallbacks {
  Vector2? velocity;
  bool isDeviceSmartphoneInput = false;
  bool isDead = false; // Flag status mati
  int horizontalDirection = 0;
  int verticalDirection = 0;
  Vector2 previousPosition = Vector2.zero();
  Vector2 touchDelta = Vector2.zero();

  ArenaPlayer({super.position})
      : super(
          size: Vector2(64, 64),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    velocity = Vector2.zero();
    previousPosition = position.clone();

    // Memuat semua animasi
    animations = {
      PlayerState.idle: await _loadAnimation("character_idle", 47),
      PlayerState.walk_down: await _loadAnimation("character_walk", 35),
      PlayerState.walk_top: await _loadAnimation("character_walk_top", 35),
      PlayerState.walk_left: await _loadAnimation("character_walk_left", 35),
      PlayerState.walk_right: await _loadAnimation("character_walk_right", 35),
      // Animasi mati: loop diset false agar berhenti di frame terakhir terkapar
      PlayerState.dead: await _loadAnimation("character_dead", 30, loop: false),
    };

    current = PlayerState.idle;

    // Hitbox karakter
    add(RectangleHitbox(
      size: Vector2(30, 45),
      position: Vector2(size.x / 2 - 15, size.y / 2 - 22.5),
    ));
  }

  // Fungsi pembantu untuk memuat frame animasi
  Future<SpriteAnimation> _loadAnimation(String folder, int frames,
      {bool loop = true}) async {
    final spriteList = await Future.wait(List.generate(
      frames,
      (i) => Sprite.load("$folder/00${i.toString().padLeft(2, '0')}.png"),
    ));
    return SpriteAnimation.spriteList(spriteList, stepTime: 0.1, loop: loop);
  }

  @override
  void update(double dt) {
    if (isDead) return; // Mengunci posisi karakter saat memutar animasi mati

    previousPosition.setFrom(position);
    super.update(dt);

    Vector2 delta = Vector2.zero();
    if (isDeviceSmartphoneInput) {
      if (!touchDelta.isZero()) delta.setFrom(touchDelta);
    } else {
      if (velocity != null && !velocity!.isZero()) delta = velocity! * dt;
    }

    if (!delta.isZero()) {
      _updateAnimationState(delta);

      position.x += delta.x;
      _checkWallCollision(delta.x, true);

      position.y += delta.y;
      _checkWallCollision(delta.y, false);

      if (isDeviceSmartphoneInput) touchDelta.setZero();
    } else {
      current = PlayerState.idle;
    }
  }

  void _updateAnimationState(Vector2 delta) {
    if (delta.y < 0)
      current = PlayerState.walk_top;
    else if (delta.y > 0)
      current = PlayerState.walk_down;
    else if (delta.x < 0)
      current = PlayerState.walk_left;
    else if (delta.x > 0) current = PlayerState.walk_right;
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    // Jika kena musuh dan belum dalam status mati
    if (other is ArenaEnemy && !isDead) {
      die();
    }
  }

  void die() {
    if (isDead) return; // Kunci agar fungsi ini tidak dipanggil berkali-kali

    isDead = true;
    current =
        PlayerState.dead; // Jalankan animasi mati tepat di koordinat $position

    // Hentikan semua gerakan agar tidak meluncur saat mati
    velocity?.setZero();
    touchDelta.setZero();

    print("Mati di lokasi $position. Menunggu animasi...");

    // JEDA: Beri waktu pemain melihat karakter mati di tempat
    // Sesuaikan 3000ms (3 detik) dengan panjang animasi matimu
    Future.delayed(const Duration(milliseconds: 3000), () {
      // Cek dulu, jangan-jangan sudah restart manual lewat tombol
      if (isDead) {
        respawn();
      }
    });
  }

  void respawn() {
    // Baru pindah posisi ke spawn setelah animasi mati selesai
    position = Vector2(100, 600);
    current = PlayerState.idle;
    isDead = false; // Buka kunci kontrol
    velocity?.setZero();
    print("Respawn selesai, kembali ke titik awal.");
  }

  // --- LOGIKA TABRAKAN TEMBOK ---
  Rect get _hitboxRect => Rect.fromCenter(
        center: position.toOffset(),
        width: 30,
        height: 45,
      );

  void _checkWallCollision(double d, bool isHorizontal) {
    for (final block in gameRef.world.children.query<CollisionBlock>()) {
      if (_hitboxRect.overlaps(block.toRect())) {
        if (isHorizontal) {
          position.x = d > 0 ? block.x - 15 : block.x + block.width + 15;
        } else {
          position.y = d > 0 ? block.y - 22.5 : block.y + block.height + 22.5;
        }
      }
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keyPressed) {
    if (isDead) return false;

    velocity?.setZero();
    isDeviceSmartphoneInput = false;
    const double speed = 150;
    if (keyPressed.contains(LogicalKeyboardKey.keyW)) velocity?.y -= speed;
    if (keyPressed.contains(LogicalKeyboardKey.keyS)) velocity?.y += speed;
    if (keyPressed.contains(LogicalKeyboardKey.keyA)) velocity?.x -= speed;
    if (keyPressed.contains(LogicalKeyboardKey.keyD)) velocity?.x += speed;
    return true;
  }

  void moveByTouchDelta(double dx, double dy) {
    if (isDead) return;
    isDeviceSmartphoneInput = true;
    const double sensitivity = 1.5;
    touchDelta.add(Vector2(dx * sensitivity, dy * sensitivity));
  }
}
