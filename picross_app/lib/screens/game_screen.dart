import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../widgets/picross_grid.dart';

class GameScreen extends StatelessWidget {
  final List<List<int>> solution;

  const GameScreen({super.key, required this.solution});

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context); // ✅ Usamos el Provider aquí
    //final int size = solution.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Picross')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Calcula la escala para que el tablero quepa en la pantalla
          final int size = solution.length;
          final double maxWidth = constraints.maxWidth - 40;
          final double boardWidth = (size + 1) * 40.0;

          double scaleFactor = 1.0;
          if (boardWidth > 0 && maxWidth > 0 && boardWidth > maxWidth) {
            scaleFactor = maxWidth / boardWidth;
          }

          // print('size: $size');
          // print('maxWidth: $maxWidth');
          // print('boardWidth: $boardWidth');
          // print('scaleFactor: $scaleFactor');

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Botón de modo (sin cambios)
              Consumer<GameState>(
                builder: (context, gameState, _) {
                  return ElevatedButton(
                    onPressed: () => gameState.toggleMode(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: gameState.mode == InteractionMode.fill
                                ? Colors.purple
                                : Colors.grey,
                            border: Border.all(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Tablero interactivo con escala por defecto
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: boardWidth * scaleFactor,
                    height: boardWidth * scaleFactor,
                    child: InteractiveViewer(
                      boundaryMargin: const EdgeInsets.all(20),
                      minScale: 0.5,
                      maxScale: 3.0,
                      constrained: false,
                      child: Transform.translate(
                        offset: size==5 ? const Offset(-20, 0) : Offset.zero, // Mueve 20px a la izquierda
                        child: Transform.scale(
                          scale: scaleFactor,
                          alignment: Alignment.topLeft,
                          child: PicrossGrid(
                            solution: solution,
                            gameState: gameState,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}