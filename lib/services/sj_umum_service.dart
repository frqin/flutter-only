import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sjumum.dart';

class SjUmumService {
  static const String baseUrl = 'https://erp.pt-nikkatsu.com/api/sju';
  static const Map<String, String> headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'api-key': 'beacukai12345',
  };

  /// Ambil semua SJ Umum
  static Future<List<SjUmum>> fetchSJUmum(String token) async {
    final response = await http.get(Uri.parse(baseUrl), headers: headers);

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
      throw Exception('Gagal mengambil SJ Umum (${response.statusCode})');
    }
  }

  /// Setujui SJ Umum (update field Status jadi Disetujui)
  static Future<bool> setujui(String no) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$no'), // endpoint PUT
        headers: headers,
        body: json.encode({'Status': 'Disetujui'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Error setujui SJ: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception setujui SJ: $e');
      return false;
    }
  }
}
