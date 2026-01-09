import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/scrap_model.dart';

class ScrapService {
  static const String baseUrl = "http://localhost:3000/api/scrap";

  static Future<List<ScrapModel>> fetchScrap(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => ScrapModel.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil Scrap data");
    }
  }

  static Future<void> create(String token, Map<String, String> payload) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: json.encode(payload),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception("Gagal menambahkan Scrap data");
    }
  }

  static Future<void> update(
    String token,
    int id,
    Map<String, String> payload,
  ) async {
    final url = "$baseUrl/$id";

    final response = await http.put(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: json.encode(payload),
    );

    if (response.statusCode != 200) {
      throw Exception("Gagal update Scrap data");
    }
  }
}
