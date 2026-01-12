import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sjumum.dart';

class SjUmumService {
  static const String baseUrl =
      'https://erp.pt-nikkatsu.com/api/sju';

  static Future<List<SjUmum>> fetchSJUmum(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Accept': 'application/json',
        'api-key': 'beacukai12345',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      if (decoded is List) {
        return decoded.map<SjUmum>((e) => SjUmum.fromJson(e)).toList();
      }

      if (decoded is Map && decoded['data'] != null) {
        return (decoded['data'] as List)
            .map<SjUmum>((e) => SjUmum.fromJson(e))
            .toList();
      }

      throw Exception('Format response API tidak dikenali');
    } else {
      throw Exception(
        'Gagal mengambil SJ Umum (${response.statusCode})',
      );
    }
  }
}
