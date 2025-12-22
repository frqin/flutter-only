import 'dart:io';

class ApiConfig {
  static String get baseUrl {
    if (Platform.isAndroid) {
      // Android Emulator
      return "http://10.0.2.2:3000/api";
    } else {
      // Web / Desktop / Laptop
      return "http://localhost:3000/api";
    }
  }
}
