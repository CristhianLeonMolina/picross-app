import 'package:flutter/material.dart';

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
      border: TableBorder.all(color: Colors.grey),
      children: List.generate(rows, (row) {
        return TableRow(
          children: List.generate(cols, (col) {
            return GestureDetector(
              onTap: () {
                // Acción al tocar celda (más adelante)
              },
              child: Container(
                height: 40,
                width: 40,
                color: Colors.white,
                alignment: Alignment.center,
                child: Text(''), // Aquí irá la X o el relleno
              ),
            );
          }),
        );
      }),
    );
  }
}