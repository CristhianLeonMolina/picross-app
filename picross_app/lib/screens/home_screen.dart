import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_screen.dart';
import '../models/game_state.dart';
import '../utils/solution.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void navigateToGame(BuildContext context, int size) {
  final solution = generateSolution(size);
  final gameState = GameState(size);

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ChangeNotifierProvider.value(
        value: gameState,
        child: GameScreen(
          solution: solution,
          gameState: gameState,
        ),
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Elegir Tamaño del Tablero')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var size in [5, 10, 15, 20])
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => navigateToGame(context, size),
                  child: Text('Partida $size x $size'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
