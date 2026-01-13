import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/invoice.dart';

class InvoiceService {
  static const String baseUrl = 'https://erp.pt-nikkatsu.com/api/invoice';
  static const String apiKey = 'beacukai12345';

  /// ===============================
  /// GET LIST
  /// ===============================
  static Future<List<Invoice>> getInvoices() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {'api-key': apiKey, 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Invoice.fromJson(e)).toList();
    } else {
      throw Exception('GET Invoice gagal (${response.statusCode})');
    }
  }

  /// ===============================
  /// GET DETAIL (🔥 SESUAI API LU)
  /// ===============================
  static Future<Invoice> getDetail(String no) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$no'),
      headers: {'api-key': apiKey, 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // 🔥 API BALIK ARRAY → AMBIL INDEX 0
      if (data is List && data.isNotEmpty) {
        return Invoice.fromJson(data.first);
      }

      // kalau ternyata object
      if (data is Map<String, dynamic>) {
        return Invoice.fromJson(data);
      }

      throw Exception('Data detail invoice kosong');
    } else {
      throw Exception('GET Detail Invoice gagal (${response.statusCode})');
    }
  }

  /// ===============================
  /// UPDATE STATUS → DISETUJUI
  /// ===============================
  static Future<bool> selesaikanInvoice(String no) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$no'),
      headers: {
        'api-key': apiKey,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({'status': 'Disetujui'}),
    );

    return response.statusCode == 200;
  }
}
