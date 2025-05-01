import 'package:flutter/material.dart';

enum CellState { empty, filled, marked }

class GameState extends ChangeNotifier {
  final List<List<CellState>> board;

  GameState(int size)
      : board = List.generate(size, (_) => List.filled(size, CellState.empty));

  void toggleCell(int row, int col) {
    if (board[row][col] == CellState.empty) {
      board[row][col] = CellState.filled;
    } else if (board[row][col] == CellState.filled) {
      board[row][col] = CellState.marked;
    } else {
      board[row][col] = CellState.empty;
    }
    notifyListeners();
  }

  CellState getCellState(int row, int col) => board[row][col];
}