import 'grid_tile.dart';

class GameControllerState {
  final List<GridTile> tiles;
  final int guessCount;

  const GameControllerState({this.tiles = const [], this.guessCount = 0});

  int get score => tiles.where((tile) => tile.isMatched).length ~/ 2;

  bool get isGameWon => tiles.every((tile) => tile.isMatched);

  bool get isGameStarted => tiles.isNotEmpty;

  int get flippedTilesCount => tiles.where((tile) => tile.isFlipped).length;

  bool get isLost => guessCount == 10;

  GameControllerState copyWith({List<GridTile>? tiles, int? guessCount}) {
    return GameControllerState(
      tiles: tiles ?? this.tiles,
      guessCount: guessCount ?? this.guessCount,
    );
  }
}
