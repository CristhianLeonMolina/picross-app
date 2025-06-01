import 'package:shared_preferences/shared_preferences.dart';

class UserService {

  static Future<void> initUserSession({
    required String token,
    required int userId,
    required String username,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setInt('userId', userId);
    await prefs.setString('username', username);
  }

  /// Verifica si hay un token guardado => hay sesión iniciada
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }

  /// Devuelve el nombre de usuario actual, o null si no está guardado
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  /// Devuelve el ID del usuario actual, o null si no está guardado
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.get('userId');
    if (value is int) return value;
    return int.parse(value.toString());
  }

  /// Devuelve el token JWT actual, o null si no está guardado
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// Cierra sesión eliminando los datos guardados
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    await prefs.remove('username');
  }
}
