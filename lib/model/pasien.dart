import 'dart:convert';
import 'package:good_health/util/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class Pasien {
  final String idPasien, nama, hp, email;

  Pasien({required this.idPasien, required this.nama, required this.hp, required this.email});

  factory Pasien.fromJson(Map<String, dynamic> json) {
    return Pasien(
      idPasien: json['id_pasien'].toString(),
      nama: json['nama'],
      hp: json['hp'],
      email: json['email'],
    );
  }
}

List<Pasien> pasienFromJson(jsonData) {
  List<Pasien> result = List<Pasien>.from(jsonData.map((item) => Pasien.fromJson(item)));
  return result;
}

// Create a logger instance
final logger = Logger();

// register pasien (POST)
Future<http.Response?> pasienCreate(Pasien pasien) async {
  try {
    final response = await http.post(
      Uri.http(AppConfig.API_HOST, '/goodhealth/pasien/create.php'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'nama': pasien.nama,
        'hp': pasien.hp,
        'email': pasien.email,
      }),
    );

    return response;
  } catch (e) {
    logger.e("Error: ${e.toString()}");
    return null;
  }
}