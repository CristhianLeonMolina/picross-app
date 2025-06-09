import 'package:picross_app/models/game_state.dart';
import 'package:picross_app/utils/solution.dart';
import 'package:picross_app/widgets/picross_grid.dart';
import 'package:picross_app/l10n/app_localizations.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  final int size;

  const GameScreen({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final solution = generateSolution(size);

    return ChangeNotifierProvider(
      create: (_) => GameState(size, solution, context),
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
    final loc = AppLocalizations.of(context)!;

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
          title: Text(loc.title, style: const TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: loc.restart_game_tooltip,
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
            final int size = solution.length;
            final double maxWidth = constraints.maxWidth - 40;
            final double boardWidth = (size + 1) * 40.0;

            double scaleFactor = 1.0;
            if (boardWidth > 0 && maxWidth > 0 && boardWidth > maxWidth) {
              scaleFactor = maxWidth / boardWidth;
            }

            return Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${loc.best_time}: ${gameState.bestTimeFormatted ?? loc.not_available}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Consumer<GameState>(
                      builder: (context, gameState, _) {
                        return Column(
                          children: [
                            const SizedBox(height: 40),
                            Visibility(
                              visible: gameState.message != null,
                              maintainSize: true,
                              maintainAnimation: true,
                              maintainState: true,
                              child: Text(
                                gameState.message ?? '',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 50,
                                ),
                              ),
                            ),
                            Text(
                              '${loc.current_time}: ${gameState.currentTimeFormatted}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Visibility(
                              visible: gameState.bestTimeFormatted != null,
                              maintainSize: true,
                              maintainAnimation: true,
                              maintainState: true,
                              child: Text(
                                '${loc.score_points}: ${gameState.points ?? 0}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 60),
                          ],
                        );
                      },
                    ),
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
                                  size == 5
                                      ? const Offset(20, 30)
                                      : const Offset(20, 40),
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
                ),
                Positioned(
                  top: 200,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Consumer<GameState>(
                      builder: (context, gameState, _) {
                        return ElevatedButton(
                          onPressed: () => gameState.toggleMode(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(loc.toggle_mode_button),
                              const SizedBox(width: 8),
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