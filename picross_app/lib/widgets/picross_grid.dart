import 'package:flutter/material.dart';
import 'grid_cell.dart';
import '../utils/hints.dart';
import '../models/game_state.dart';

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
    final size = solution.length;

    return Table(
      defaultColumnWidth: const FixedColumnWidth(40),
      children: List.generate(size + 1, (row) {
        return TableRow(
          children: List.generate(size + 1, (col) {
            if (row == 0 && col == 0) {
              return const SizedBox(width: 40, height: 40);
            }

            if (row == 0 && col > 0) {
              return SizedBox(
                width: 40,
                height: 40,
                child: OverflowBox(
                  maxHeight: 80,
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    calculateColHints(solution)[col - 1].join('\n'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              );
            }

            if (col == 0 && row > 0) {
              return SizedBox(
                width: 40,
                height: 40,
                child: OverflowBox(
                  maxWidth: 100,
                  alignment: Alignment.centerRight,
                  child: Text(
                    calculateRowHints(solution)[row - 1].join(' '),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              );
            }

            // ✅ Aquí pasamos el gameState
            return GridCell(
              row: row - 1,
              col: col - 1,
              gameState: gameState,
            );
          }),
        );
      }),
    );
  }
}
