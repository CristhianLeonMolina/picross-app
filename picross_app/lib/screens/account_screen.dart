import 'package:picross_app/screens/home_screen.dart';
import 'package:picross_app/screens/access_screen.dart';
import 'package:picross_app/services/api_service.dart';
import 'package:picross_app/services/user_service.dart';
import 'package:picross_app/l10n/app_localizations.dart';

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';

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
    if (token == null) return;

    final String baseUrl = ApiConfig.baseUrl;
    final loc = AppLocalizations.of(context)!;

    final response = await http.get(
      Uri.parse('$baseUrl/users/accountDetails'),
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
    } else if (response.statusCode == 400) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.token_bearer_required)));
    } else if (response.statusCode == 401) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.token_invalid_or_exired)));
    } else if (response.statusCode == 404) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.user_not_found)));
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
      
      // //! DEBUG
      // print('Imagen seleccionada: ${image.path}');
    }
  }

  Future<void> save() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final token = await UserService.getToken();
    final baseUrl = ApiConfig.baseUrl;

    final loc = AppLocalizations.of(context)!;

    if (token == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.no_session)));
      return;
    }

    final url = Uri.parse('$baseUrl/users/changeDetails');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': username, 'email': email}),
    );

    final resBody = jsonDecode(response.body);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);

    final userResponse = await http.get(
      Uri.parse('$baseUrl/users/accountDetails'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    // //!----------DEBUG----------
    // print('Status: ${response.statusCode}');
    // print('Headers: ${response.headers}');
    // print('Body: ${response.body}');
    // //!-------------------------

    if (userResponse.statusCode == 200) {
      final userData = jsonDecode(userResponse.body);
      if (userData['success'] == true) {
        final datos = userData['datos'];
        final username = datos['username'] ?? '';

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);

        if (response.statusCode == 200 && resBody['success'] == true) {
          await UserService.initUserSession(
            token: token,
            username: username,
          );

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(loc.edit_success)));
        } else {
          final msg = resBody['message'] ?? loc.edit_error;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${loc.update_error}: $msg')),
          );
        }
        
      }
    }
  }

  void changePass() {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();

    final loc = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(loc.change_password),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: oldPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: loc.current_password),
                ),
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: loc.new_password),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(loc.cancel),
              ),
              ElevatedButton(
                onPressed: () async {
                  final oldPass = oldPasswordController.text.trim();
                  final newPass = newPasswordController.text.trim();

                  if (oldPass.isEmpty || newPass.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(loc.fill_both_fields)),
                    );
                    return;
                  }

                  final token = await UserService.getToken();
                  final baseUrl = ApiConfig.baseUrl;

                  if (token == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(loc.no_active_session)),
                    );
                    return;
                  }

                  final url = Uri.parse('$baseUrl/users/changePassword');
                  final response = await http.post(
                    url,
                    headers: {
                      'Content-Type': 'application/json',
                      'Authorization': 'Bearer $token',
                    },
                    body: jsonEncode({
                      'oldPassword': oldPass,
                      'password': newPass,
                    }),
                  );

                  Navigator.pop(context);

                  if (response.statusCode == 200) {
                    final res = jsonDecode(response.body);
                    if (res['success'] == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(loc.password_updated)),
                      );
                    } else {
                      final msg = res['message'] ?? loc.password_change_error;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${loc.update_error}: $msg')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(loc.password_change_fail)),
                    );
                  }
                },
                child: Text(loc.change),
              ),
            ],
          ),
    );
  }

  Future<void> logout() async {
    UserService.logout();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.logout_success)),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AccessScreen()),
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            loc.account_title,
            style: const TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
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
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: loc.username,
                  filled: true,
                  fillColor: Colors.white,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: loc.email,
                  filled: true,
                  fillColor: Colors.white,
                  border: const OutlineInputBorder(),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(loc.save),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(loc.change_password),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(loc.logout),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}