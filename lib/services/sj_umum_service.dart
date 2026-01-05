import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sjumum.dart';

class SjUmumService {
  static const String baseUrl = "http://localhost:3000/api/sjumum";

  static Future<List<SjUmum>> fetchSJUmum(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => SjUmum.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil SJ Umum");
    }
  }
}
