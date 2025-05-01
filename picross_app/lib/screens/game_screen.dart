import 'package:flutter/material.dart';
import '../widgets/picross_grid.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Picross')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            PicrossGrid(), // Tablero básico de 5x5
          ],
        ),
      ),
    );
  }
}