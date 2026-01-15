import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dio/dio.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // 🔥 Endpoint backend SIMPAN FCM TOKEN
  static const String _apiUrl = 'https://erp.pt-nikkatsu.com/api/token';

  // 🔥 API KEY dari backend
  static const String _apiKey = 'beacukai12345';

  /// =========================
  /// PANGGIL SEKALI SAJA
  /// (Setelah login / dashboard)
  /// =========================
  static Future<void> init() async {
    try {
      // 1️⃣ Minta izin notifikasi
      await _messaging.requestPermission(alert: true, badge: true, sound: true);

      // 2️⃣ Ambil token pertama kali
      final String? token = await _messaging.getToken();
      print('📱 FCM TOKEN AWAL: $token');

      if (token != null && token.isNotEmpty) {
        await _sendTokenToBackend(token);
      }

      // 3️⃣ LISTEN JIKA TOKEN BERUBAH (WAJIB)
      _messaging.onTokenRefresh.listen((newToken) async {
        print('🔁 FCM TOKEN BERUBAH: $newToken');
        await _sendTokenToBackend(newToken);
      });

      // 4️⃣ LISTENER NOTIF
      listenForeground();
      listenOpenedApp();
      listenTerminated();
    } catch (e) {
      print('❌ Error init notification: $e');
    }
  }

  /// =========================
  /// KIRIM TOKEN KE BACKEND
  /// =========================
  static Future<void> _sendTokenToBackend(String fcmToken) async {
    final dio = Dio();

    try {
      final response = await dio.put(
        _apiUrl,
        data: {"fcm_token": fcmToken},
        options: Options(
          headers: {"API-KEY": _apiKey, "Content-Type": "application/json"},
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ FCM token berhasil disimpan');
      } else {
        print('⚠️ Backend tolak token');
        print('STATUS: ${response.statusCode}');
        print('DATA: ${response.data}');
      }
    } on DioException catch (e) {
      print('❌ Dio Error');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
    } catch (e) {
      print('❌ Error lain: $e');
    }
  }

  /// =========================
  /// NOTIF MASUK SAAT APP TERBUKA
  /// =========================
  static void listenForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('🔔 NOTIF FOREGROUND');
      print('TITLE: ${message.notification?.title}');
      print('BODY : ${message.notification?.body}');
      print('DATA : ${message.data}');
    });
  }

  /// =========================
  /// NOTIF DIKLIK DARI BACKGROUND
  /// =========================
  static void listenOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('📲 NOTIF DIKLIK (BACKGROUND)');
      print('DATA: ${message.data}');
    });
  }

  /// =========================
  /// NOTIF DIKLIK SAAT APP MATI
  /// =========================
  static Future<void> listenTerminated() async {
    final message = await _messaging.getInitialMessage();
    if (message != null) {
      print('🚀 APP DIBUKA DARI NOTIF (TERMINATED)');
      print('DATA: ${message.data}');
    }
  }
}
