import 'package:flutter/foundation.dart';

enum CellState { empty, filled, marked }

enum InteractionMode { fill, mark }

class GameState extends ChangeNotifier {
  final List<List<CellState>> _cellStates;
  InteractionMode _mode = InteractionMode.fill;

  GameState(int size)
      : _cellStates = List.generate(
            size, (_) => List.generate(size, (_) => CellState.empty));

  CellState getCellState(int row, int col) => _cellStates[row][col];

  InteractionMode get mode => _mode;

  void toggleCell(int row, int col) {
  // Si la celda ya está marcada o rellenada, no permitir cambios
  if (_cellStates[row][col] != CellState.empty) return;

  if (_mode == InteractionMode.fill) {
    _cellStates[row][col] = CellState.filled;
  } else {
    _cellStates[row][col] = CellState.marked;
  }
  notifyListeners();
}


  void toggleMode() {
    _mode = _mode == InteractionMode.fill ? InteractionMode.mark : InteractionMode.fill;
    notifyListeners();
  }
}
