import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sjtagih.dart';

class SjTagihService {
  static const String baseUrl = "http://localhost:3000/api/sjtagih";

  static Future<List<SuratJalan>> fetchSJTagih(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => SuratJalan.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil SJ Tagih");
    }
  }
}
