import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter_application_1/components/collision_block.dart';
import 'package:flutter_application_1/components/player.dart';

class Level extends World {

  final String levelName;
  final Player player;
  Level({required this.levelName, required this.player});
  late TiledComponent level;
  List<CollisionBlock> CollisionBlocks = [];

  @override
  FutureOr<void> onLoad()  async{

    level = await TiledComponent.load("$levelName.tmx", Vector2.all(16));

    add(level);

    final spawnPointLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    if (spawnPointLayer != null) {
      for(final spawnPoint in spawnPointLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
            break;
          default:
        }
      }
    }

    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if(collisionsLayer != null) {
      for(final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: true,
            );
            CollisionBlocks.add(platform);
            add(platform);
            break;
          default:
          final block = CollisionBlock(
            position: Vector2(collision.x, collision.y),
            size: Vector2(collision.width, collision.height),
          );
          CollisionBlocks.add(block);
          add(block);
        }
      }
    }
    player.CollisionBlocks = CollisionBlocks;

    return super.onLoad();
  }
}