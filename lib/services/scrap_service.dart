import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ekspedisi/models/scrap.dart';

class ScrapService {
  static const String baseUrl = 'https://erp.pt-nikkatsu.com/api/sjs';

  static const Map<String, String> headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'api-key': 'beacukai12345',
  };

  /// Ambil semua data Scrap
  static Future<List<ScrapModel>> fetchScrap() async {
    final response = await http.get(Uri.parse(baseUrl), headers: headers);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      /// Case 1: response langsung berupa List
      if (decoded is List) {
        return decoded.map<ScrapModel>((e) => ScrapModel.fromJson(e)).toList();
      }

      /// Case 2: response dibungkus key "data"
      if (decoded is Map && decoded['data'] != null) {
        return (decoded['data'] as List)
            .map<ScrapModel>((e) => ScrapModel.fromJson(e))
            .toList();
      }

      throw Exception('Format response API Scrap tidak dikenali');
    } else {
      throw Exception('Gagal mengambil data Scrap (${response.statusCode})');
    }
  }

  /// Setujui Scrap (update Status jadi Disetujui)
  static Future<bool> setujui(String no) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$no'),
        headers: headers,
        body: json.encode({'Status': 'Disetujui'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Error setujui Scrap: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception setujui Scrap: $e');
      return false;
    }
  }
}
