import 'package:flutter/material.dart';
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
            // Esquina vacía
            if (row == 0 && col == 0) {
              return const SizedBox(width: 40, height: 40);
            }

            // Guía de columnas (pueden salir hacia arriba)
            if (row == 0 && col > 0) {
              return Container(
                alignment: Alignment.bottomCenter,
                height: 40,
                color: Colors.transparent,
                child: OverflowBox(
                  maxHeight: 80,
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    colHints[col - 1].join('\n'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              );
            }

            // Guía de filas (pueden salir hacia la izquierda)
            if (col == 0 && row > 0) {
              return Container(
                alignment: Alignment.center,
                height: 40,
                color: Colors.transparent,
                child: OverflowBox(
                  maxWidth: 100,
                  alignment: Alignment.center,
                  child: Text(
                    rowHints[row - 1].join(' '),
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              );
            }

            // Celda interactiva
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
