import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class TimeService {
  Future<void> saveTime(int puzzleSize, int timeInSeconds) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/times'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'puzzleSize': puzzleSize,
        'time': timeInSeconds,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al guardar el tiempo');
    }
  }

  Future<List<dynamic>> getTimes() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/times'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener tiempos');
    }
  }
}
