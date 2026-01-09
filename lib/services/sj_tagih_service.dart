import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ekspedisi/models/sjtagih.dart';

class SjTagihService {
  static const String baseUrl = 'https://erp.pt-nikkatsu.com/api/sjt';

  static const String apiKey = 'beacukai12345';

  // ===== GET 1 SURAT JALAN BERDASARKAN NO =====
  static Future<SjTagihModel> getByNo(String no) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$no'),
      headers: {'API-KEY': apiKey, 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      // backend kirim array
      return SjTagihModel.fromJson(decoded[0]);
    } else {
      throw Exception('Gagal mengambil SJ Tagihan');
    }
  }

  // ===== UPDATE STATUS → DISETUJUI =====
  static Future<bool> setujui(String no) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$no'),
      headers: {
        'API-KEY': apiKey,
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({"Status": "Disetujui"}),
    );

    return response.statusCode == 200;
  }
}
