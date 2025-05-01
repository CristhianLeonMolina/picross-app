import 'package:flutter/material.dart';
import '../models/cell_state.dart';

class GridCell extends StatefulWidget {
  const GridCell({super.key});

  @override
  State<GridCell> createState() => _GridCellState();
}

class _GridCellState extends State<GridCell> {
  CellState _state = CellState.empty;

  void _toggleState() {
    setState(() {
      _state = CellState.values[(_state.index + 1) % CellState.values.length];
    });
  }

  @override
  Widget build(BuildContext context) {
    Color color;
    Widget content = const SizedBox.shrink();

    switch (_state) {
      case CellState.empty:
        color = Colors.white;
        break;
      case CellState.filled:
        color = Colors.black;
        break;
      case CellState.crossed:
        color = Colors.white;
        content = const Icon(Icons.close, color: Colors.red, size: 20);
        break;
    }

    return GestureDetector(
      onTap: _toggleState,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.grey),
        ),
        alignment: Alignment.center,
        child: content,
      ),
    );
  }
}
