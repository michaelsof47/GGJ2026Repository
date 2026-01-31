
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:ggj2026repository/arena/arena_game.dart';
import 'package:ggj2026repository/arena/arena_player.dart';

enum EnemyState { walk }

class ArenaEnemy extends SpriteAnimationGroupComponent<EnemyState>
    with HasGameRef<ArenaGame>, CollisionCallbacks {

  Vector2? moveRange;
  var speed;

  Vector2? startPosition;
  double direction = 1;
  Vector2? velocity;
  
  ArenaEnemy({
    required Vector2 position,
    required Vector2 size,
    required this.moveRange,
    this.speed = 100,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    startPosition = position.clone();
    velocity = Vector2.zero();

    final walkSheet = await Future.wait(
      List.generate(35, (i) => Sprite.load("enemy_walk/00${i.toString().padLeft(2,'0')}.png"))
    );

    animations = {
      EnemyState.walk: SpriteAnimation.spriteList(walkSheet, stepTime: 0.1)
    };

    current = EnemyState.walk;

    add(RectangleHitbox(
      size: size,
      position: Vector2(size.x / 2 - 15, size.y / 2 - 15),
    ));   
  }

  @override
  void update(double dt) {
    super.update(dt);

    if(moveRange!.y > 0) {
      if((position.y - startPosition!.y).abs() >= moveRange!.y) {
        direction *= -1;
      }
      velocity?.y = direction * speed;
    }

    position += velocity! * dt;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is ArenaPlayer) {
      print('Enemy hit Player! Game Over');
      // Reset posisi player ke posisi aman (bisa ditaruh di level_start atau Vector2(100, 400))
      other.position = Vector2(100, 400); 
    }
  }
}