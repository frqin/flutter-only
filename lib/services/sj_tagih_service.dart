import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ekspedisi/models/sjtagih.dart';

class SjTagihService {
  static const String _baseUrl = 'https://erp.pt-nikkatsu.com/api';
  static const String _apiKey = 'beacukai12345';

  // ================= GET ALL SJ TAGIH =================
  static Future<List<SjTagihModel>> getAll() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/sjt'),
      headers: {'API-KEY': _apiKey, 'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw ('Tidak ada yang perlu di setujui');
    }

    final decoded = jsonDecode(response.body);

    // API kamu return ARRAY
    if (decoded is List) {
      return decoded
          .map<SjTagihModel>((json) => SjTagihModel.fromJson(json))
          .toList();
    }

    throw Exception('Format data SJ Tagih tidak valid');
  }

  // ================= GET BY NO =================
  static Future<SjTagihModel> getByNo(String no) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/sjt/$no'),
      headers: {'API-KEY': _apiKey, 'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil detail SJ Tagih');
    }

    final decoded = jsonDecode(response.body);

    // Biasanya backend balikin array walau cuma 1 data
    if (decoded is List && decoded.isNotEmpty) {
      return SjTagihModel.fromJson(decoded[0]);
    }

    throw Exception('Data SJ Tagih tidak ditemukan');
  }

  // ================= SETUJUI SJ TAGIH =================
  static Future<bool> setujui(String no) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/sjt/$no'),
      headers: {
        'API-KEY': _apiKey,
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'Status': 'Disetujui'}),
    );

    return response.statusCode == 200;
  }
}
