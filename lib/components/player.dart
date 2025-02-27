import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/components/collision_block.dart';
import 'package:flutter_application_1/components/player_hitbox.dart';
import 'package:flutter_application_1/components/utils.dart';
import 'package:flutter_application_1/pixel_adventure.dart';

enum PlayerState {idle, running, jumping, falling}

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler {

  String character;
  Player({position, this.character = 'Ninja Frog'}) : super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  final double stepTime = 0.05;

  final double _gravity = 9.8;
  final double _jumpForce = 460;
  final double _terminalVelocity = 300;
  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  bool hasJumped = false;
  List<CollisionBlock> CollisionBlocks = [];
  PlayerHitbox hitbox = PlayerHitbox(
    offsetY: 10,
    offsetX: 4,
    width: 14,
    height: 28,
  );


  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    debugMode = true;
    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
    ));
    return super.onLoad();
  }

  @override
  void update(double dt) {
  _updatePlayerState();
  _updatePlayerMovement(dt);
  _checkHorizontalCollisions();
  _applyGravity(dt);
  _checkVerticalCollision();
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;

    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
      keysPressed.contains(LogicalKeyboardKey.arrowLeft);

    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
      keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    hasJumped = keysPressed.contains(LogicalKeyboardKey.space);

    return super.onKeyEvent(event, keysPressed);
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('Idle', 11);
    runningAnimation = _spriteAnimation('Run', 12);
    jumpingAnimation = _spriteAnimation('Jump', 1);
    fallingAnimation = _spriteAnimation('Fall', 1);

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation
    };

    //Set current animation
    current = PlayerState.running;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(game.images.fromCache('Main Characters/$character/$state (32x32).png'),
    SpriteAnimationData.sequenced(
      amount: amount,
      stepTime: stepTime,
      textureSize: Vector2.all(32)
      )
    );
  }

    void _updatePlayerState() {

    PlayerState playerState = PlayerState.idle;

    if(velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0 ) {
      flipHorizontallyAroundCenter();
    }

    if(velocity.x > 0 || velocity.x < 0) playerState = PlayerState.running;

    if(velocity.y > 0) playerState = PlayerState.falling;

    if(velocity.y < 0) playerState = PlayerState.jumping;

    current = playerState;
  }

  void _updatePlayerMovement(double dt) {

    if(hasJumped && isOnGround) _playerJump(dt);

    //if(velocity.y > _gravity) isOnGround = false;

    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _playerJump(double dt) {
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasJumped = false;
  }

  void _checkHorizontalCollisions() {
    for(final block in CollisionBlocks) {
      if(!block.isPlatform) {
        if(checkCollision(this, block)) {
          if(velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - hitbox.offsetX - hitbox.width;
            break;
          }
          if(velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + hitbox.width + hitbox.offsetX;
            break;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollision() {
    for(final block in CollisionBlocks) {
      if(block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height- hitbox.offsetY;
            isOnGround = true;
            break;
          }
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
          }
        }
      }
    }
  }
}