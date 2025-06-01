import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../utils/solution.dart';
import '../widgets/picross_grid.dart';

class GameScreen extends StatelessWidget {
  final int size;

  const GameScreen({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final solution = generateSolution(size);

    return ChangeNotifierProvider(
      create: (_) => GameState(size, solution),
      child: _GameScreenContent(solution: solution),
    );
  }
}

class _GameScreenContent extends StatelessWidget {
  final List<List<int>> solution;

  const _GameScreenContent({required this.solution});

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromRGBO(30, 60, 120, 0.9),
            Color.fromRGBO(50, 90, 160, 0.9),
            Color.fromRGBO(85, 20, 140, 0.9),
            Color.fromRGBO(120, 40, 180, 0.9),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            'Picross',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
            actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Reiniciar partida',
              onPressed: () {
                final size = gameState.size;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => GameScreen(size: size)),
                );
              },
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            //* Calcula la escala para que el tablero quepa en la pantalla
            final int size = solution.length;
            final double maxWidth = constraints.maxWidth - 40;
            final double boardWidth = (size + 1) * 40.0;

            double scaleFactor = 1.0;
            if (boardWidth > 0 && maxWidth > 0 && boardWidth > maxWidth) {
              scaleFactor = maxWidth / boardWidth;
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //* Botón de modo rellenar o marcar
                Consumer<GameState>(
                  builder: (context, gameState, _) {
                    return Column(
                      children: [
                        if (gameState.message != null) Text(gameState.message!),
                        Text(
                          'Tiempo actual: ${gameState.currentTimeFormatted}',
                          style: TextStyle(color: Colors.white),
                        ),
                        if (gameState.bestTimeFormatted != null)
                          Text(
                            'Mejor tiempo: ${gameState.bestTimeFormatted}',
                            style: TextStyle(color: Colors.white),
                            ),
                      ],
                    );
                  },
                ),

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
                              color:
                                  gameState.mode == InteractionMode.fill
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

                //* Tablero
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: (boardWidth * scaleFactor) + 80,
                      height: (boardWidth * scaleFactor) + 200,
                      child: InteractiveViewer(
                        boundaryMargin: const EdgeInsets.all(20),
                        minScale: 0.5,
                        maxScale: 3.0,
                        constrained: false,
                        child: Transform.translate(
                          offset:
                              size == 5 ? const Offset(20, 30) : Offset(20, 40),
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
      ),
    );
  }
}
