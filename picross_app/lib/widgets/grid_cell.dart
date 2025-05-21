import 'package:flutter/material.dart';
import '../models/game_state.dart';

class GridCell extends StatelessWidget {
  final int row;
  final int col;
  final List<List<int>> solution;
  final GameState gameState;

  const GridCell({
    super.key,
    required this.row,
    required this.col,
    required this.solution,
    required this.gameState,
  });

  @override
  Widget build(BuildContext context) {
    final state = gameState.getCellState(row, col);

    final isWrongFilled = gameState.isWrongFilled(row, col, solution);
    final isWrongMarked = gameState.isWrongMarked(row, col, solution);

    Color? backgroundColor;
    Widget? content;

    if (state == CellState.filled) {
      if (isWrongFilled) {
        backgroundColor = Colors.grey;
        content = const Text(
          'X',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        );
      } else {
        backgroundColor = Colors.purple;
      }
    } else if (state == CellState.marked) {
      if (isWrongMarked) {
        backgroundColor = Colors.purple;
        content = const Text(
          'X',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        );
      } else {
        backgroundColor = Colors.grey;
      }
    } else {
      backgroundColor = Colors.white;
    }

    final isLastRow = row == solution.length - 1;
    final isLastCol = col == solution.length - 1;

    final border = Border(
      top: BorderSide(color: Colors.black, width: row % 5 == 0 ? 2.5 : 0.5),
      left: BorderSide(color: Colors.black, width: col % 5 == 0 ? 2.5 : 0.5),
      right: BorderSide(color: Colors.black, width: (isLastCol) ? 2.5 : 0.5),
      bottom: BorderSide(color: Colors.black, width: (isLastRow) ? 2.5 : 0.5),
    );

    return GestureDetector(
      onTap: () {
        gameState.toggleCell(row, col);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: backgroundColor, border: border),
        alignment: Alignment.center,
        child: content,
      ),
    );
  }
}
