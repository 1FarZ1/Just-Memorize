import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/game_grid.dart';
import 'state/game_controller.dart';
import 'state/game_controller_state.dart';
import 'widgets/reset_button.dart';
import 'widgets/stats_header.dart';

class MainView extends ConsumerWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);

    ref.listen<GameControllerState>(
      gameControllerProvider,
      (prev, next) {
        if (next.isLost) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('You Lost!'),
                content: Text(
                    'Your score is ${next.score}/${next.tiles.length ~/ 2}'),
                actions: [
                  TextButton(
                    onPressed: () {
                      ref.read(gameControllerProvider.notifier).resetGame();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Play Again'),
                  ),
                ],
              );
            },
          );
        }

        if (next.isGameWon) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('You Won!'),
                content: Text(
                    'Your score is ${next.score}/${next.tiles.length ~/ 2}'),
                actions: [
                  TextButton(
                    onPressed: () {
                      ref.read(gameControllerProvider.notifier).resetGame();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Play Again'),
                  ),
                ],
              );
            },
          );
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Just Memorize! ',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        actions: const [
          ResetButton(),
        ],
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.tealAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [StatsHeader(), GameGrid(), SizedBox(height: 50)],
        ),
      ),
    );
  }
}
