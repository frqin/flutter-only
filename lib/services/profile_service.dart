import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  static const String _baseUrl = 'https://erp.pt-nikkatsu.com/api';
  static const String _apiKey = 'beacukai12345';

  // ================= GET PROFILE =================
  Future<Map<String, dynamic>> getProfileByNrp(String nrp) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/users/$nrp'),
      headers: {'API-KEY': _apiKey, 'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal ambil profile');
    }

    final decoded = jsonDecode(response.body);

    if (decoded is List && decoded.isNotEmpty) {
      return decoded[0];
    }

    throw Exception('Data profile kosong');
  }

  // ================= UPDATE PROFILE =================
  Future<void> updateProfileByNrp({
    required String nrp,
    required String name,
    required String email,
    String? password,
  }) async {
    final response = await http.post(
      // ⚠️ kalau backend kamu pakai PUT, ganti http.post → http.put
      Uri.parse('$_baseUrl/users/$nrp'),
      headers: {
        'API-KEY': _apiKey,
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'namaPegawai': name,
        'user_email': email,
        if (password != null && password.isNotEmpty) 'user_password': password,
      }),
    );

    debugPrint('UPDATE PROFILE RESPONSE: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Gagal update profile');
    }
  }
}
