import 'package:picross_app/services/api_service.dart';
import 'package:picross_app/services/user_service.dart';
import 'package:picross_app/screens/account_screen.dart';
import 'package:picross_app/screens/home_screen.dart';
import 'package:picross_app/l10n/app_localizations.dart';

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class AccessScreen extends StatefulWidget {
  const AccessScreen({super.key});

  @override
  State<AccessScreen> createState() => _AccessScreenState();
}

class _AccessScreenState extends State<AccessScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String _baseUrl = ApiConfig.baseUrl;

  Future<void> register() async {
    final loc = AppLocalizations.of(context)!;
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.error_fill_fields)));
      return;
    }

    final url = Uri.parse('$_baseUrl/users/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 201 && responseData['success'] == true) {
      final token = responseData['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      final detailsResponse = await http.get(
        Uri.parse('$_baseUrl/users/accountDetails'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (detailsResponse.statusCode == 200) {
        final userData = jsonDecode(detailsResponse.body);
        if (userData['success'] == true) {
          final datos = userData['datos'];
          final username = datos['username'] ?? '';

          await UserService.initUserSession(
            token: token,
            username: username,
          );

          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AccountScreen()),
          );
          return;
        }
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.error_user_data)));
    } else if (response.statusCode == 409) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.error_email_in_use)));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.error_register)));
    }
  }

  Future<void> _login() async {
    final loc = AppLocalizations.of(context)!;
    final url = Uri.parse('$_baseUrl/users/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      if (token == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(loc.token_bearer_required)));
        return;
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      final userResponse = await http.get(
        Uri.parse('$_baseUrl/users/accountDetails'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (userResponse.statusCode == 200) {
        final userData = jsonDecode(userResponse.body);
        if (userData['success'] == true) {
          final datos = userData['datos'];
          final userId = '${datos['id'] ?? ''}';
          final username = datos['username'] ?? '';

          await prefs.setString('username', username);
          await prefs.setString('userId', userId);

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(loc.login_success)));

          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AccountScreen()),
          );
          return;
        }
      }
    } else if (response.statusCode == 404) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.login_wrong_credentials)));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${loc.server_error}: ${response.statusCode}')),
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
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: loc.email,
                  filled: true,
                  fillColor: Colors.white,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: loc.password,
                  filled: true,
                  fillColor: Colors.white,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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
                      onPressed: register,
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
                      child: Text(loc.register_button),
                    ),
                  ),
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
                      onPressed: _login,
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
                      child: Text(loc.login_button),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}