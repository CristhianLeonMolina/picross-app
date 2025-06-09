import 'dart:math';

//* Genera una solución aleatoria de Picross de tamaño [size] x [size].
List<List<int>> generateSolution(int size) {
  if (size < 1) {
    size = 1;
  }
  final random = Random();
  return List.generate(size, (_) {
    return List.generate(size, (_) => random.nextBool() ? 1 : 0);
  });
}