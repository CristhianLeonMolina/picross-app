List<List<int>> calculateRowHints(List<List<int>> matrix) {
  return matrix.map((row) {
    final hints = <int>[];
    int count = 0;

    for (final cell in row) {
      if (cell == 1) {
        count++;
      } else if (count > 0) {
        hints.add(count);
        count = 0;
      }
    }

    if (count > 0) {
      hints.add(count);
    }

    return hints.isEmpty ? [0] : hints;
  }).toList();
}

List<List<int>> calculateColHints(List<List<int>> matrix) {
  final cols = matrix[0].length;
  final rows = matrix.length;
  final hints = <List<int>>[];

  for (int col = 0; col < cols; col++) {
    final colHints = <int>[];
    int count = 0;

    for (int row = 0; row < rows; row++) {
      if (matrix[row][col] == 1) {
        count++;
      } else if (count > 0) {
        colHints.add(count);
        count = 0;
      }
    }

    if (count > 0) {
      colHints.add(count);
    }

    hints.add(colHints.isEmpty ? [0] : colHints);
  }

  return hints;
}
