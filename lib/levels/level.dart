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
    add(Player());

    return super.onLoad();
  }
}