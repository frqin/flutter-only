import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "http://127.0.0.1:8000/api"; // Desktop/Web → localhost

  // =====================
  // LOGIN OWNER
  // =====================
  Future<dynamic> loginOwner(String email, String password) async {
    try {
      final url = Uri.parse("$baseUrl/auth/owner/login");

      final response = await http
          .post(
            url,
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
            body: jsonEncode({
              "email": email,
              "password": password,
              "device": "flutter-app",
            }),
          )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Simpan token
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("token", data['access_token']);
        return true; // <-- SUCCESS
      }

      // Kalau error dari Laravel
      return data["message"] ?? "Login gagal";
    } catch (e) {
      return "Koneksi error: $e";
    }
  }

  // =====================
  // GET PROFILE
  // =====================
  Future<Map<String, dynamic>> me() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        return {"error": "Token tidak ditemukan"};
      }

      final url = Uri.parse("$baseUrl/auth/me");

      final response = await http
          .get(
            url,
            headers: {
              "Authorization": "Bearer $token",
              "Accept": "application/json",
            },
          )
          .timeout(const Duration(seconds: 10));

      return jsonDecode(response.body);
    } catch (e) {
      return {"error": "Gagal mengambil profil: $e"};
    }
  }

  // =====================
  // LOGOUT
  // =====================
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token != null) {
        final url = Uri.parse("$baseUrl/auth/logout");

        await http
            .post(
              url,
              headers: {
                "Authorization": "Bearer $token",
                "Accept": "application/json",
              },
            )
            .timeout(const Duration(seconds: 10));
      }

      prefs.remove("token");
    } catch (e) {
      print("Error logout: $e");
    }
  }
}
