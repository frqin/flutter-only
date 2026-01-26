import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // API BACKEND
  static const String _apiUrl = 'https://erp.pt-nikkatsu.com/api/token';
  static const String _apiKey = 'beacukai12345';

  /// =========================
  /// PANGGIL SETELAH LOGIN
  /// =========================
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final isLogin = prefs.getBool('is_logged_in') ?? false;

    if (!isLogin) {
      print('ℹ️ User belum login, skip notification init');
      return;
    }

    // 🔔 Permission
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    // 📱 Ambil FCM token
    final token = await _messaging.getToken();
    print('📱 FCM TOKEN: $token');

    if (token != null && token.isNotEmpty) {
      await _saveAndSendToken(token);
    }

    // 🔁 Token refresh
    _messaging.onTokenRefresh.listen((newToken) async {
      print('🔄 FCM TOKEN UPDATED: $newToken');
      await _saveAndSendToken(newToken);
    });

    listenForeground();
    listenOpenedApp();
    listenTerminated();
  }

  /// SIMPAN LOKAL + KIRIM BACKEND

  static Future<void> _saveAndSendToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', token);
    print('💾 FCM token disimpan di SharedPreferences');

    await _sendTokenToBackend(token);
  }

  /// AMBIL INFO DEVICE

  static Future<Map<String, String>> _getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;
      return {
        'device_id': android.id,
        'device_type': 'android',
        'device_model': android.model,
      };
    }

    if (Platform.isIOS) {
      final ios = await deviceInfo.iosInfo;
      return {
        'device_id': ios.identifierForVendor ?? 'unknown',
        'device_type': 'ios',
        'device_model': ios.utsname.machine,
      };
    }

    return {
      'device_id': 'unknown',
      'device_type': 'unknown',
      'device_model': 'unknown',
    };
  }

  /// KIRIM TOKEN (BY DEVICE)

  static Future<void> _sendTokenToBackend(String token) async {
    try {
      final dio = Dio();
      final device = await _getDeviceInfo();

      final response = await dio.put(
        _apiUrl,
        data: {
          'token': token,
          'device_id': device['device_id'],
          'device_type': device['device_type'],
          'device_model': device['device_model'],
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType, // 🔥 INI PENTING
          headers: {'API-KEY': _apiKey, 'Accept': 'application/json'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ FCM token berhasil dikirim (by device)');
      } else {
        print('⚠️ Backend menolak token (${response.statusCode})');
        print('Response: ${response.data}');
      }
    } catch (e) {
      print('❌ Gagal kirim FCM token: $e');
    }
  }

  /// =========================
  /// FOREGROUND
  /// =========================
  static void listenForeground() {
    FirebaseMessaging.onMessage.listen((message) {
      print('🔔 NOTIF FOREGROUND');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
      print('Data: ${message.data}');
    });
  }

  /// =========================
  /// BACKGROUND
  /// =========================
  static void listenOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('📲 NOTIF DIKLIK');
      print('Data: ${message.data}');
    });
  }

  /// =========================
  /// TERMINATED
  /// =========================
  static Future<void> listenTerminated() async {
    final message = await _messaging.getInitialMessage();
    if (message != null) {
      print('🚀 APP DIBUKA DARI NOTIF');
      print('Data: ${message.data}');
    }
  }
}
