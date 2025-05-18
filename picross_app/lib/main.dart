import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Ajusta el path según tu estructura

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Picross App',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const HomeScreen(), // Aquí llamamos a la pantalla de inicio
    );
  }
}
