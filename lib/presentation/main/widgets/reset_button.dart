import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memory_game/presentation/main/state/game_controller.dart';

class ResetButton extends ConsumerWidget {
  const ResetButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.refresh, color: Colors.white, size: 32),
      onPressed: () {
        ref.read(gameControllerProvider.notifier).resetGame();
      },
    );
  }
}
