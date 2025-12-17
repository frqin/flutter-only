import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static const String baseUrl = 'http://localhost:3000/api';

  // ambil token (hasil login)
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// GET /api/profile
  static Future<Map<String, dynamic>> getProfile() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );

    return jsonDecode(response.body);
  }

  /// PUT /api/profile
  static Future<bool> updateProfile({
    required String name,
    required String email,
  }) async {
    final token = await _getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': name, 'email': email}),
    );

    return response.statusCode == 200;
  }

  /// POST /api/profile/photo
  static Future<bool> uploadPhoto(File photo) async {
    final token = await _getToken();

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/profile/photo'),
    );

    request.headers['Authorization'] = 'Bearer $token';

    request.files.add(await http.MultipartFile.fromPath('photo', photo.path));

    final response = await request.send();
    return response.statusCode == 200;
  }

  /// PUT /api/profile/password
  static Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final token = await _getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/profile/password'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      }),
    );

    return response.statusCode == 200;
  }
}
