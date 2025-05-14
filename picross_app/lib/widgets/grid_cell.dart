import 'package:flutter/material.dart';
import '../models/game_state.dart';

class GridCell extends StatelessWidget {
  final int row;
  final int col;
  final GameState gameState;

  const GridCell({
    super.key,
    required this.row,
    required this.col,
    required this.gameState,
  });

  @override
  Widget build(BuildContext context) {
    final state = gameState.getCellState(row, col);

    Color color;
    switch (state) {
      case CellState.filled:
        color = Colors.black;
        break;
      case CellState.marked:
        color = Colors.red;
        break;
      default:
        color = Colors.white;
    }

    return GestureDetector(
      onTap: () {
        gameState.toggleCell(row, col);
      },
      child: Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.purple),
        ),
      ),
    );
  }
}
