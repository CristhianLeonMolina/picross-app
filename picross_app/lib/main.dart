import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/solution.dart';
import 'models/game_state.dart';
import 'screens/game_screen.dart';
import 'widgets/picross_grid.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => GameState(defaultSolution.length),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Picross',
      home: const GameScreen(),
    );
  }
}