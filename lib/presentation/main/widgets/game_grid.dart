import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memory_game/presentation/main/state/game_controller.dart';
import 'package:memory_game/presentation/main/state/game_controller_state.dart';
import 'package:memory_game/presentation/main/widgets/card_widget.dart';

class GameGrid extends ConsumerWidget {
  const GameGrid({
    super.key,
  });


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameControllerProvider);
    return ConstrainedBox(
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
                ref.read(gameControllerProvider.notifier).flipTile(index);
              },
            );
          },
        ),
      ),
    );
  }
}
