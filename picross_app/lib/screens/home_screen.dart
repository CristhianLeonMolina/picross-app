import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_screen.dart';
import '../utils/solution.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void navigateToGame(BuildContext context, int size) {
    final solution = generateSolution(size);

    print(solution);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(size: size),
      ),
    );
  }

  static Future<void> clearAllBestTimes() async {
    final prefs = await SharedPreferences.getInstance();
    final sizes = [5, 10, 15, 20];
    for (var s in sizes) {
      await prefs.remove('bestTime_$s');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Elegir Tamaño del Tablero'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Borrar mejores tiempos',
            onPressed: () async {
              await clearAllBestTimes();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Todos los mejores tiempos eliminados'),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var size in [5, 10, 15, 20])
              size == 5
                  ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => navigateToGame(context, size),
                      child: Text('  Partida $size x $size  '),
                    ),
                  )
                  : Padding(
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
