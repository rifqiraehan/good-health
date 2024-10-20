import 'dart:convert';
import 'package:good_health/util/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class User {
  final String username, password;
  final String idUser;
  final String idPasien;

  User({required this.username, required this.password, required this.idUser, required this.idPasien});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idUser: json['id_user'].toString(),
      username: json['username'],
      password: json['password'],
      idPasien: json['id_pasien'].toString(),
    );
  }
}

// Create a logger instance
final logger = Logger();

// login (POST)
Future<http.Response?> login(User user) async {
  try {
    var uri = Uri.http(AppConfig.API_HOST, '/goodhealth/login.php');
    final response = await http.post(
      uri,
      // headers: {"Content-Type": "application/json; charset=utf-8"},
      body: jsonEncode({
        'username': user.username,
        'password': user.password,
        'id_pasien': user.idPasien,
      }),
    );
    logger.i('Response status: ${response.statusCode}');
    logger.i('Response body: ${response.body}');
    return response;
  } catch (e) {
    logger.e("Error: ${e.toString()}");
    return null;
  }
}