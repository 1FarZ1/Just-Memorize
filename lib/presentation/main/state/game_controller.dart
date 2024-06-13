import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'game_controller_state.dart';
import '../widgets/grid_tile.dart';

final gameControllerProvider =
    StateNotifierProvider<GameController, GameControllerState>((ref) {
  return GameController();
});

final tiles = [
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
];

class GameController extends StateNotifier<GameControllerState> {
  GameController() : super(const GameControllerState()) {
    startGame();
  }

  List<String> _prepareTiles() {
    final List<String> allTiles = [...tiles, ...tiles];
    allTiles.shuffle();
    return allTiles;
  }

  void startGame() {
    final List<String> allTiles = _prepareTiles();
    state = state.copyWith(
      guessCount: 0,
      tiles: allTiles
          .asMap()
          .entries
          .map((entry) => GridTile(entry.key, entry.value))
          .toList(),
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

    state = state.copyWith(
      tiles: state.tiles.map((tile) {
        if (tile.id == index) {
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
      state = state.copyWith(
        guessCount: state.guessCount,
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
        state = state.copyWith(
          guessCount: state.guessCount + 1,
          tiles: state.tiles.map((tile) {
            if (tile.id == state.tiles[sourceIndex].id ||
                tile.id == state.tiles[targetIndex].id) {
              return GridTile(tile.id, tile.text, isFlipped: false);
            }
            return tile;
          }).toList(),
        );
      });
    }
  }

  void resetGame() {
    startGame();
  }
}
