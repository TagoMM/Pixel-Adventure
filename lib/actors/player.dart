import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter_application_1/pixel_adventure.dart';

enum PlayerState {idle, running}

class Player extends SpriteAnimationGroupComponent with HasGameRef<PixelAdventure>{
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  final double stepTime = 0.05;


  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }

  void _loadAllAnimations() {
    idleAnimation = SpriteAnimation.fromFrameData(game.images.fromCache('Main Characters/Ninja Frog/Idle (32x32).png'),
    SpriteAnimationData.sequenced(
      amount: 11,
      stepTime: stepTime,
      textureSize: Vector2.all(32)
      )
    );

    runningAnimation = _spriteAnimation();

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation
    };

    //Set current animation
    current = PlayerState.running;
  }

  SpriteAnimation _spriteAnimation(String character) {
    return SpriteAnimation.fromFrameData(game.images.fromCache('Main Characters/Ninja Frog/Run (32x32).png'),
    SpriteAnimationData.sequenced(
      amount: 12,
      stepTime: stepTime,
      textureSize: Vector2.all(32)
      )
    );
  }
}