import 'package:picross_app/screens/access_screen.dart';
import 'package:picross_app/screens/instructions_screen.dart';
import 'package:picross_app/screens/account_screen.dart';
import 'package:picross_app/screens/game_screen.dart';
import 'package:picross_app/services/user_service.dart';
import 'package:picross_app/providers/locale_provider.dart';
import 'package:picross_app/l10n/app_localizations.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

//import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io';

import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // //!----------------------------------------------------------
  // //!-------------------------DEBUG----------------------------
  // //!----------------------------------------------------------

  // //* Metodo para borrar los tiempos y la cuenta guardada
  // static Future<void> clearAllBestTimes() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final sizes = [5, 10, 15, 20];
  //   for (var s in sizes) {
  //     await prefs.remove('bestTime_$s');
  //   }

  //   final prefs2 = await SharedPreferences.getInstance();
  //   await prefs2.clear();
  // }

  // //!----------------------------------------------------------
  // //!----------------------------------------------------------
  // //!----------------------------------------------------------

  XFile? _profileImage;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = image;
      });

      // //! DEBUG
      // print('Imagen seleccionada: ${image.path}');
    }
  }

  void navigateToGame(BuildContext context, int size) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameScreen(size: size)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

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
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 40, 80, 160),
                      ),
                      child: Text(
                        loc.home_menu,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.language),
                      title: Text(loc.language_title),
                      trailing: Image.asset(
                        Localizations.localeOf(context).languageCode == 'es'
                            ? 'assets/icons/es.png'
                            : 'assets/icons/en.png',
                        width: 32,
                        height: 32,
                      ),
                      onTap: () {
                        final currentLocale = Localizations.localeOf(context);
                        final newLocale =
                            currentLocale.languageCode == 'es'
                                ? const Locale('en')
                                : const Locale('es');

                        context.read<LocaleProvider>().setLocale(newLocale);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.help_outline),
                      title: Text(loc.instructions_title),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const InstructionsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24.0,
                  horizontal: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      loc.credits_title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      loc.credits_body,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
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
          // //! Botón para borrar los tiempos y la cuenta guardada (DEBUG)
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.delete_forever),
          //     tooltip: loc.home_delete_best_times_tooltip,
          //     onPressed: () async {
          //       await clearAllBestTimes();
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         SnackBar(content: Text(loc.home_delete_best_times_message)),
          //       );
          //     },
          //   ),
          // ],
          // //!-----------------------------------------------------------
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
                            builder:
                                (context) =>
                                    loggedIn
                                        ? const AccountScreen()
                                        : const AccessScreen(),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            _profileImage != null
                                ? FileImage(File(_profileImage!.path))
                                : const AssetImage(
                                      'assets/icons/default_profile.png',
                                    )
                                    as ImageProvider,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      loc.your_profile,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Text(
                loc.home_select_level,
                style: const TextStyle(
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
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: Column(
                children: List.generate(
                  5,
                  (rowIndex) => Expanded(
                    child: Row(
                      children: List.generate(
                        5,
                        (colIndex) => Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
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