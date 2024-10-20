import 'dart:io';

class AppConfig {
  static String get API_HOST {
    if (Platform.isAndroid || Platform.isIOS) {
      return "192.0.0.0.1"; // Change this to your local IPv4 address
    } else {
      return "localhost";
    }
  }
}