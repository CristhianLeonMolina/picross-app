import 'package:flutter/material.dart';
import 'account_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/user_service.dart';
import 'game_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'access_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? _profileImage;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = image;
      });
      debugPrint('Imagen seleccionada: ${image.path}');
    }
  }

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

    final prefs2 = await SharedPreferences.getInstance();
    await prefs2.clear();
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
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 40, 80, 160),
                ),
                child: Text(
                  'Menú',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Idioma'),
                onTap: () {
                  Navigator.pop(context);
                  // Navegar a pantalla de idioma
                },
              ),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Instrucciones'),
                onTap: () {
                  Navigator.pop(context);
                  // Navegar a pantalla de instrucciones
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Créditos'),
                onTap: () {
                  Navigator.pop(context);
                  // Navegar a pantalla de créditos
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final loggedIn = await UserService.isLoggedIn();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                loggedIn ? const AccountScreen() : const AccessScreen(),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _profileImage != null
                            ? FileImage(File(_profileImage!.path))
                            : const AssetImage('assets/icon/default_profile.png') as ImageProvider,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Tu perfil',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const Text(
                'Selecciona el nivel',
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
              color: Colors.black,
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
                children: List.generate(5, (rowIndex) => Expanded(
                  child: Row(
                    children: List.generate(5, (colIndex) => Expanded(
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