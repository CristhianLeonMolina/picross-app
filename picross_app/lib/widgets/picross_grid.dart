import 'package:flutter/material.dart';
import 'grid_cell.dart';

class PicrossGrid extends StatelessWidget {
  final int rows;
  final int cols;

  const PicrossGrid({
    super.key,
    this.rows = 5,
    this.cols = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      children: List.generate(rows, (row) {
        return TableRow(
          children: List.generate(cols, (col) => const GridCell()),
        );
      }),
    );
  }
}
