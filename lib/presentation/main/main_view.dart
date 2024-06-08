import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'card_widget.dart';
import 'game_controller.dart';
import 'game_controller_state.dart';

class MainView extends ConsumerWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);

    ref.listen<GameControllerState>(
      gameControllerProvider,
      (prev, next) {
        if (next.isGameOver) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('You Won ! '),
                content: Text(
                    'Your score is ${next.score}/${next.tiles.length ~/ 2}'),
                actions: [
                  TextButton(
                    onPressed: () {
                      ref.read(gameControllerProvider.notifier).startGame();
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
              ref.read(gameControllerProvider.notifier).startGame();
            },
          ),
        ],
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //score
            const SizedBox(height: 20),
            Text(
              '${gameState.score}/${gameState.tiles.length ~/ 2}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 300,
              width: 300,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
              ),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemCount: gameState.tiles.length,
                itemBuilder: (context, index) {
                  return CardWidget(
                    text: gameState.tiles[index].text,
                    canShow: !gameState.tiles[index].isHidden,
                    onTap: () {
                      ref.read(gameControllerProvider.notifier).flipTile(index);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
