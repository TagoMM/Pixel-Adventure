import 'dart:async';

import 'package:flame/components.dart';

class Player extends SpriteAnimationGroupComponent {
  late final SpriteAnimation idleAnimation;


  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }

  void _loadAllAnimations() {
    idleAnimation = SpriteAnimation.fromFrameData(image, data)
  }
}