import 'package:flutter_riverpod/flutter_riverpod.dart';

final gameControllerProvider =
    StateNotifierProvider<GameController, GameControllerState>((ref) {
  return GameController();
});

final tiles = [
  const GridTile(1, 'A'),
  const GridTile(2, 'B'),
  const GridTile(3, 'C'),
  const GridTile(4, 'D'),
  const GridTile(5, 'E'),
  const GridTile(6, 'F'),
  const GridTile(7, 'G'),
  const GridTile(8, 'H'),
  const GridTile(9, 'A'),
  const GridTile(10, 'B'),
  const GridTile(11, 'C'),
  const GridTile(12, 'D'),
  const GridTile(13, 'E'),
  const GridTile(14, 'F'),
  const GridTile(15, 'G'),
  const GridTile(16, 'H'),
];

class GameController extends StateNotifier<GameControllerState> {
  GameController() : super(const GameControllerState()) {
    startGame();
  }

  void startGame() {
    state = GameControllerState(
      tiles: List.generate(tiles.length, (index) {
        return GridTile(tiles[index].id - 1, tiles[index].text);
      }),
    );
  }

  void flipTile(int index) async {
    _logTiles();

    if (state.tiles[index].isMatched) {
      return;
    }

    if (state.tiles[index].isFlipped) {
      return;
    }

    if (state.flippedTilesCount == 2) {
      return;
    }

    state = GameControllerState(
      tiles: state.tiles.map((tile) {
        if (tile.id == state.tiles[index].id) {
          return GridTile(tile.id, tile.text, isFlipped: true);
        }
        return tile;
      }).toList(),
    );
    if (state.flippedTilesCount == 2) {
      final flippedTiles = state.tiles.where((tile) => tile.isFlipped).toList();

      _verifyisMatch(flippedTiles[0].id, flippedTiles[1].id);
    }
  }

  void _logTiles() {
    print('Tiles: ${state.tiles.map((tile) => tile.id).toList()}');
  }

  void _verifyisMatch(int sourceIndex, int targetIndex) {
    print(
        'Verifying match: ${state.tiles[sourceIndex].text} == ${state.tiles[targetIndex].text}');
    if (state.tiles[sourceIndex].text == state.tiles[targetIndex].text) {
      state = GameControllerState(
        tiles: state.tiles.map((tile) {
          if (tile.id == state.tiles[sourceIndex].id ||
              tile.id == state.tiles[targetIndex].id) {
            return GridTile(tile.id, tile.text, isMatched: true);
          }
          return tile;
        }).toList(),
      );
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        state = GameControllerState(
          tiles: state.tiles.map((tile) {
            if (tile.isFlipped) {
              return GridTile(tile.id, tile.text, isFlipped: false);
            }
            return tile;
          }).toList(),
        );
      });
    }
  }

  void resetGame() {
    state = const GameControllerState();
    startGame();
  }
}

class GameControllerState {
  final List<GridTile> tiles;

  const GameControllerState({this.tiles = const []});

  int get score => tiles.where((tile) => tile.isMatched).length ~/ 2;

  bool get isGameOver => tiles.every((tile) => tile.isMatched);

  bool get isGameStarted => tiles.isNotEmpty;

  int get flippedTilesCount => tiles.where((tile) => tile.isFlipped).length;
}

class GridTile {
  final int id;
  final String text;
  final bool isFlipped;
  final bool isMatched;
  const GridTile(this.id, this.text,
      {this.isFlipped = false, this.isMatched = false});

  bool get isHidden => !isFlipped && !isMatched;
}
