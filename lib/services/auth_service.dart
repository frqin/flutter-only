import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://erp.pt-nikkatsu.com',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'API-KEY': 'beacukai12345',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  Future<dynamic> loginOwner(String email, String password) async {
    try {
      final response = await _dio.post(
        '/api/users',
        data: {'user_email': email, 'user_password': password},
      );

      final data = response.data;

      if (data['status'] == true) {
        // LOGIN BERHASIL
        return true;
      } else {
        // LOGIN GAGAL DARI BACKEND
        return data['message'] ?? 'Login gagal';
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data['message'] ?? 'Terjadi kesalahan';
      }
      return 'Tidak dapat terhubung ke server';
    } catch (e) {
      return 'Error tidak diketahui';
    }
  }
}
