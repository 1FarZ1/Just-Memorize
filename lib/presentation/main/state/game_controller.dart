import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'game_controller_state.dart';
import '../widgets/grid_tile.dart';

final gameControllerProvider =
    StateNotifierProvider<GameController, GameControllerState>((ref) {
  return GameController();
});

final List<IconData> tiles = [
  Icons.toys,
  Icons.cake,
  Icons.child_care,
  Icons.pets,
  Icons.school,
  Icons.sports_soccer,
  Icons.star,
  Icons.beach_access,
];

class GameController extends StateNotifier<GameControllerState> {
  GameController() : super(const GameControllerState()) {
    startGame();
  }

  List<IconData> _prepareTiles() {
    final List<IconData> allTiles = [...tiles, ...tiles];
    allTiles.shuffle();
    return allTiles;
  }

  void startGame() {
    final List<IconData> allTiles = _prepareTiles();
    state = state.copyWith(
      guessCount: 0,
      tiles: allTiles
          .asMap()
          .entries
          .map((entry) => AppGridTile<IconData>(entry.key, entry.value))
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
          return AppGridTile<IconData>(tile.id, tile.child, isFlipped: true);
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
    if (state.tiles[sourceIndex].child == state.tiles[targetIndex].child) {
      state = state.copyWith(
        guessCount: state.guessCount,
        tiles: state.tiles.map((tile) {
          if (tile.id == state.tiles[sourceIndex].id ||
              tile.id == state.tiles[targetIndex].id) {
            return AppGridTile<IconData>(tile.id, tile.child, isMatched: true);
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
              return AppGridTile<IconData>(tile.id, tile.child,
                  isFlipped: false);
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
