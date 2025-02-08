import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter_application_1/actors/player.dart';

class Level extends World {

  late TiledComponent level;

  @override
  FutureOr<void> onLoad()  async{

    level = await TiledComponent.load("level_01.tmx", Vector2.all(16));

    add(level);

    final spawnPointLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    if (spawnPointLayer != null) {
      for(final spawnPoint in spawnPointLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            final player = Player(
              character: 'Mask Dude',
              position: Vector2(spawnPoint.x, spawnPoint.y)
            );
            add(player);
            break;
          default:
        }
      }
    } else {
      print('Spawnpoints layer not found');
    }
    return super.onLoad();
  }
}