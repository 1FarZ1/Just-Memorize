import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/card_widget.dart';
import 'state/game_controller.dart';
import 'state/game_controller_state.dart';

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
        title: const Text('Memory Game'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(gameControllerProvider.notifier).resetGame();
            },
          ),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Guess count
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white,
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Guesses Left: ${10 - gameState.guessCount}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Score
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white,
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Score: ${gameState.score}/${gameState.tiles.length ~/ 2}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 380),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: gameState.tiles.length,
                  itemBuilder: (context, index) {
                    return CardWidget(
                      child: gameState.tiles[index].child,
                      canShow: !gameState.tiles[index].isHidden,
                      onTap: () {
                        ref
                            .read(gameControllerProvider.notifier)
                            .flipTile(index);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

