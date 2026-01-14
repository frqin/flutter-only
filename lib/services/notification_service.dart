import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static final _messaging = FirebaseMessaging.instance;

  /// Panggil SEKALI (setelah login / dashboard)
  static Future<void> init() async {
    await _messaging.requestPermission();

    final token = await _messaging.getToken();
    print('FCM TOKEN: $token');
    // TODO: kirim token ke server / simpan kalau perlu
  }

  /// Listener saat app dibuka (foreground)
  static void listen() {
    FirebaseMessaging.onMessage.listen((message) {
      print('Notif: ${message.notification?.title}');
    });
  }
}
