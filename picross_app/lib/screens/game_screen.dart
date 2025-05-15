import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../widgets/picross_grid.dart';

class GameScreen extends StatelessWidget {
  final List<List<int>> solution;
  final GameState gameState;

  const GameScreen({
    super.key,
    required this.solution,
    required this.gameState,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Picross')),
      body: Center( // Centra todo el contenido
        child: Consumer<GameState>(
          builder: (context, gameState, _) {
            return Column(
              mainAxisSize: MainAxisSize.min, // solo ocupa lo necesario
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Botón de cambio de modo
                ElevatedButton(
                  onPressed: () => gameState.toggleMode(),
                  child: Text(
                    gameState.mode == InteractionMode.fill
                        ? '⬛'
                        : '❌',
                  ),
                ),
                const SizedBox(height: 12),

                // Tablero Picross centrado
                Transform.translate(
                  offset: const Offset(-20, 0),
                  child: Align(
                    alignment: Alignment.center,
                    child: PicrossGrid(
                      solution: solution,
                      gameState: gameState,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
