import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardService {
  final String baseUrl = "http://localhost:3000/api/dashboard";

  Future<Map<String, dynamic>> fetchDashboard(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Gagal fetch dashboard: ${response.body}");
    }
  }
}
