import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:picross_app/services/api_service.dart';
import '../services/user_service.dart';
import 'access_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  XFile? _profileImage;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final token = await UserService.getToken();
    if (token == null) return; // no token, no hacemos nada

    final String baseUrl = ApiConfig.baseUrl;

    final response = await http.get(
      Uri.parse('$baseUrl/users/accountDetails'), // cambia a tu URL real
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        final datos = data['datos'];
        setState(() {
          _usernameController.text = datos['username'] ?? '';
          _emailController.text = datos['email'] ?? '';
        });
      }
    } else {
      //! manejar error (token inválido, etc)
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

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

  Future<void> save() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final token = await UserService.getToken();
    final baseUrl = ApiConfig.baseUrl;

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No hay sesión iniciada.')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/users/changeDetails'), // reemplaza con tu URL real
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': username,
        'email': email,
      }),
    );

    final resBody = jsonDecode(response.body);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);

    // Hacer petición para obtener datos de usuario
    final userResponse = await http.get(
      Uri.parse('$baseUrl/users/accountDetails'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Status: ${response.statusCode}');
    print('Headers: ${response.headers}');
    print('Body: ${response.body}');

    if (userResponse.statusCode == 200) {
      final userData = jsonDecode(userResponse.body);
      if (userData['success'] == true) {
        final datos = userData['datos'];

        // Extraer y validar los datos
        final username = datos['username'] ?? '';
        final userId = datos['id']; // Suponiendo que es un int

        if (userId is int) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('username', username);
          await prefs.setInt('userId', userId);

          if (response.statusCode == 200 && resBody['success'] == true) {
            await UserService.initUserSession(
              token: token,
              userId: userId,
              username: username,
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Datos actualizados correctamente.')),
            );
          } else {
            final msg = resBody['message'] ?? 'Error al guardar los datos';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $msg')),
            );
          }
        }
      }
    }
  }


  void changePass() {
    // Lógica para cambiar contraseña
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funcionalidad no implementada')),
    );
  }

  Future<void> logout() async {
    UserService.logout();

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sesión cerrada')),
    );

    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AccessScreen()),
    );
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            'Cuenta',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context); //* Esto vuelve a la pantalla anterior
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: pickImage,
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
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de usuario',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromRGBO(100, 150, 240, 0.9),
                      Color.fromRGBO(130, 160, 200, 0.9),
                      Color.fromRGBO(230, 150, 250, 0.9),
                      Color.fromRGBO(200, 130, 230, 0.9),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: save,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Guardar'),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromRGBO(100, 150, 240, 0.9),
                      Color.fromRGBO(130, 160, 200, 0.9),
                      Color.fromRGBO(230, 150, 250, 0.9),
                      Color.fromRGBO(200, 130, 230, 0.9),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: changePass,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Cambiar contraseña'),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromRGBO(100, 150, 240, 0.9),
                      Color.fromRGBO(130, 160, 200, 0.9),
                      Color.fromRGBO(230, 150, 250, 0.9),
                      Color.fromRGBO(200, 130, 230, 0.9),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: logout,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Cerrar sesión'),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}