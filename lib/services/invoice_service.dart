import 'dart:convert';
import 'package:http/http.dart' as http;

class InvoiceService {
  static const String baseUrl = 'http://localhost:3000/api/invoice';
  // ⚠️ pakai ini kalau Android Emulator
  // kalau HP fisik: ganti IP laptop

  static Future<List<Map<String, dynamic>>> getAllInvoices(String token) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('STATUS CODE: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      final List raw = jsonDecode(response.body);

      return raw.map<Map<String, dynamic>>((json) {
        return {
          "no": json["NO_INVOICE"] ?? "",
          "status": json["status"] ?? "",
          "kapal": json["SHIP"] ?? "",
          "deskripsi": json["DESCRIPTION"] ?? "",
          "from": json["ASAL"] ?? "",
          "to": json["TUJUAN"] ?? "",
          "total": _parseInt(json["BIAYA"]),
        };
      }).toList();
    } else {
      throw Exception('Gagal load invoice');
    }
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String && value.isNotEmpty) {
      return int.tryParse(value.replaceAll('.', '')) ?? 0;
    }
    return 0;
  }
}
