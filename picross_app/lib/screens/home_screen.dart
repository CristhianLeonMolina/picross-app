import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void navigateToGame(BuildContext context, int size) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameScreen(size: size)),
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromRGBO(30, 60, 120, 0.9),
            Color.fromRGBO(50, 90, 160, 0.9),
            Color.fromRGBO(85, 20, 140, 0.9),
            Color.fromRGBO(120, 40, 180, 0.9),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/icon/picross-logo.png',
                      width: 80,
                      height: 80,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const Text(
                'Select game',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGameSizeButton(context, 5),
                  const SizedBox(width: 20),
                  _buildGameSizeButton(context, 10),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGameSizeButton(context, 15),
                  const SizedBox(width: 20),
                  _buildGameSizeButton(context, 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameSizeButton(BuildContext context, int size) {
    return GestureDetector(
      onTap: () => navigateToGame(context, size),
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                children: List.generate(size == 5 ? 5 : 4, (rowIndex) => Expanded(
                  child: Row(
                    children: List.generate(size == 5 ? 5 : 4, (colIndex) => Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300, width: 0.5),
                        ),
                      ),
                    )),
                  ),
                )),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${size}x$size',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
