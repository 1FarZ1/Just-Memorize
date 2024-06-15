import 'package:flutter/material.dart';

import '../widgets/grid_tile.dart';

class GameControllerState {
  final List<AppGridTile<IconData>> tiles;
  final int guessCount;

  const GameControllerState({this.tiles = const [], this.guessCount = 20});

  int get score => tiles.where((tile) => tile.isMatched).length ~/ 2;

  bool get isGameWon => tiles.every((tile) => tile.isMatched);

  bool get isGameStarted => tiles.isNotEmpty;

  int get flippedTilesCount => tiles.where((tile) => tile.isFlipped).length;

  bool get isLost => guessCount == 0;

  GameControllerState copyWith(
      {List<AppGridTile<IconData>>? tiles, int? guessCount}) {
    return GameControllerState(
      tiles: tiles ?? this.tiles,
      guessCount: guessCount ?? this.guessCount,
    );
  }
}
