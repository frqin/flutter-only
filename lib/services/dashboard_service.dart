import 'dart:convert';
import 'package:http/http.dart' as http;

// Model data approval
class ApprovalItem {
  final int id;
  final String title;
  final String date;

  ApprovalItem({required this.id, required this.title, required this.date});

  factory ApprovalItem.fromJson(Map<String, dynamic> json) {
    return ApprovalItem(
      id: json['id'],
      title: json['title'],
      date: json['date'],
    );
  }
}

class DashboardService {
  // Ganti dengan URL backend kamu
  static const String baseUrl = "https://your-backend-url.com/api";

  // Ambil daftar item approval
  static Future<List<ApprovalItem>> getApprovalList() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/approvals'));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<ApprovalItem> items = body
            .map((item) => ApprovalItem.fromJson(item))
            .toList();
        return items;
      } else {
        throw Exception('Failed to load approval list');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
