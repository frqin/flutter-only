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
  /// LOGIN USER
  /// =========================
  Future<bool> loginOwner(String email, String password) async {
    try {
      final response = await _dio.post(
        '/api/users',
        data: {'user_email': email, 'user_password': password},
      );

      final data = response.data;

      if (data != null && data['status'] == true) {
        final prefs = await SharedPreferences.getInstance();

        // =========================
        // SIMPAN SESSION LOGIN
        // =========================
        await prefs.setBool('is_logged_in', true);
        await prefs.setString('user_email', email);

        // =========================
        // OPTIONAL: TOKEN AUTH
        // =========================
        // if (data['token'] != null) {
        //   await prefs.setString('auth_token', data['token']);
        // }

        print('✅ Login sukses');
        print('💾 Session disimpan di SharedPreferences');

        return true;
      } else {
        print('❌ Login gagal: ${data?['message']}');
        return false;
      }
    } catch (e) {
      print('❌ Error login: $e');
      return false;
    }
  }

  /// =========================
  /// CEK LOGIN (AUTO LOGIN)
  /// =========================
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  /// =========================
  /// LOGOUT (CLEAR SESSION)
  /// =========================
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    // ❌ HAPUS SESSION LOGIN
    await prefs.setBool('is_logged_in', false);
    await prefs.remove('user_email');

    // ❌ OPTIONAL: HAPUS AUTH & FCM
    await prefs.remove('auth_token');
    await prefs.remove('fcm_token');

    print('🚪 Logout sukses, session dihapus');
  }
}
