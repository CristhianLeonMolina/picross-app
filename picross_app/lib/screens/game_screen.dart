import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../widgets/picross_grid.dart';
import '../utils/solution.dart'; // Asegúrate de importar la solución

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Picross')),
      body: Center(
        child: Consumer<GameState>(
          builder: (context, gameState, _) {
            return PicrossGrid(
              solution: defaultSolution,
              gameState: gameState,
            );
          },
        )
      ),
      floatingActionButton: Consumer<GameState>(
        builder: (context, gameState, _) {
          return FloatingActionButton(
            onPressed: () => gameState.toggleMode(),
            child: Icon(
              gameState.mode == InteractionMode.fill
                  ? Icons.brush
                  : Icons.close,
            ),
          );
        },
      ),
    );
  }
}
