import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://erp.pt-nikkatsu.com',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'API-KEY': 'beacukai12345',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  /// =========================
  /// LOGIN USER (FINAL)
  /// =========================
  Future<Map<String, dynamic>?> loginOwner(
    String email,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        '/api/users',
        data: {'user_email': email, 'user_password': password},
      );

      final data = response.data;

      if (data != null && data['status'] == true) {
        final prefs = await SharedPreferences.getInstance();

        await prefs.setBool('is_logged_in', true);
        await prefs.setString('user_email', email);

        // 🔥 SIMPAN NRP (INI KUNCI SEMUANYA)
        if (data['nrp'] != null) {
          await prefs.setString('nrp', data['nrp']);
        }

        print('✅ Login sukses');
        return data; // ⬅️ BALIK DATA USER
      }

      print('❌ Login gagal');
      return null;
    } catch (e) {
      print('❌ Error login: $e');
      return null;
    }
  }

  /// =========================
  /// LOGOUT
  /// =========================
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
