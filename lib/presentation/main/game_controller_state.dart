import 'package:memory_game/presentation/main/grid_tile.dart';

class GameControllerState {
  final List<GridTile> tiles;

  const GameControllerState({this.tiles = const []});

  int get score => tiles.where((tile) => tile.isMatched).length ~/ 2;

  bool get isGameOver => tiles.every((tile) => tile.isMatched);

  bool get isGameStarted => tiles.isNotEmpty;

  int get flippedTilesCount => tiles.where((tile) => tile.isFlipped).length;


  //copy with
  GameControllerState copyWith({
    List<GridTile>? tiles,
  }) {
    return GameControllerState(
      tiles: tiles ?? this.tiles,
    );
  }
}
