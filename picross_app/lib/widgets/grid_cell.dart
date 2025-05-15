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
    final shouldBeFilled = solution[row][col] == 1;

    final isWrongFilled = state == CellState.filled && !shouldBeFilled;
    final isWrongMarked = state == CellState.marked && shouldBeFilled;

    Color? backgroundColor;
    Widget? content;

    if (state == CellState.filled) {
      if (isWrongFilled) {
        backgroundColor = Colors.grey; // Fondo negro si relleno mal
        content = const Text(
          'X',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        );
      } else {
        backgroundColor = Colors.purple;
      }
    } else if (state == CellState.marked) {
      if (isWrongMarked) {
        backgroundColor = Colors.purple; // Fondo gris si marcado mal
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

    return GestureDetector(
      onTap: () {
        gameState.toggleCell(row, col);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: Colors.black),
        ),
        alignment: Alignment.center,
        child: content,
      ),
    );
  }
}
