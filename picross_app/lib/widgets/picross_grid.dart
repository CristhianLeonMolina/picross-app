import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../widgets/grid_cell.dart';
import '../utils/hints.dart';

class PicrossGrid extends StatelessWidget {
  final List<List<int>> solution;
  final GameState gameState;

  const PicrossGrid({
    super.key,
    required this.solution,
    required this.gameState,
  });

  @override
  Widget build(BuildContext context) {
    final rowHints = calculateRowHints(solution);
    final colHints = calculateColHints(solution);
    final size = solution.length;

    return Table(
      defaultColumnWidth: const FixedColumnWidth(40),
      children: List.generate(size + 1, (row) {
        return TableRow(
          children: List.generate(size + 1, (col) {
            //* Esquina vacía
            if (row == 0 && col == 0) {
              return const SizedBox(width: 40, height: 40);
            }

            //* Guía de columnas
            if (row == 0 && col > 0) {
              return Container(
                alignment: Alignment.center,
                height: 40,
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: OverflowBox(
                    maxHeight: 160,
                    alignment: Alignment.bottomCenter,
                    child: Consumer<GameState>(
                      builder: (context, gameState, _) {
                        final isCompleted = gameState.completedCols[col - 1];
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children:
                              colHints[col - 1].map((number) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2.0,
                                  ),
                                  child: Text(
                                    '$number',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      decoration:
                                          isCompleted
                                              ? TextDecoration.lineThrough
                                              : null,
                                    ),
                                  ),
                                );
                              }).toList(),
                        );
                      },
                    ),
                  ),
                ),
              );
            }

            //* Guía de filas
            if (col == 0 && row > 0) {
              return Container(
                alignment: Alignment.center,
                height: 40,
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: OverflowBox(
                    maxWidth: 180,
                    alignment: Alignment.centerRight,
                    child: Consumer<GameState>(
                      builder: (context, gameState, _) {
                        final isCompleted = gameState.completedRows[row - 1];
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children:
                              rowHints[row - 1].map((number) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 2.0,
                                  ),
                                  child: Text(
                                    '$number',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      decoration:
                                          isCompleted
                                              ? TextDecoration.lineThrough
                                              : null,
                                    ),
                                  ),
                                );
                              }).toList(),
                        );
                      },
                    ),
                  ),
                ),
              );
            }

            //* Celdas interactivas
            return GridCell(
              row: row - 1,
              col: col - 1,
              solution: solution,
              gameState: gameState,
            );
          }),
        );
      }),
    );
  }
}
