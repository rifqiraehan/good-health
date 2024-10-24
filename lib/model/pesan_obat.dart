import 'dart:convert';
import 'package:good_health/util/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:good_health/util/session.dart';
import 'package:logger/logger.dart';
import 'pasien.dart';

class PesanObat {
  String idPesanObat,
      waktu,
      alamat,
      lat,
      lng,
      listPesanan,
      totalBiaya,
      ket;
  bool? isSelesai;

  Pasien? idPasien;

  PesanObat(
      {required this.idPesanObat,
      required this.idPasien,
      required this.waktu,
      required this.alamat,
      required this.lat,
      required this.lng,
      required this.listPesanan,
      required this.totalBiaya,
      required this.ket,
      this.isSelesai});

  factory PesanObat.fromJson(Map<String, dynamic> json) {
    return PesanObat(
        idPesanObat: json['id_pesan_obat'].toString(),
        idPasien: Pasien.fromJson(json['id_pasien']),
        waktu: json['waktu'],
        alamat: json['alamat'].toString(),
        lat: json['lat'].toString(),
        lng: json['lng'].toString(),
        listPesanan: json['list_pesanan'].toString(),
        totalBiaya: json['total_biaya'].toString(),
        ket: json['ket'] ?? "",
        isSelesai: (json['is_selesai'] == 1) ? true : false);
  }
}

List<PesanObat> pesanObatFromJson(jsonData) {
  List<PesanObat> result =
      List<PesanObat>.from(jsonData.map((item) => PesanObat.fromJson(item)));

  result.sort((a, b) => b.waktu.compareTo(a.waktu));

  return result;
}

// Create a logger instance
final logger = Logger();

// index
Future<List<PesanObat>> fetchPesanObats({isSelesai}) async {
  isSelesai = isSelesai ?? "";
  final prefs = await SharedPreferences.getInstance();
  String idPasien = prefs.getString(ID_PASIEN) ?? "";

  var uri = Uri.http(AppConfig.API_HOST, '/goodhealth/pesan_obat/index.php', {'id_pasien': idPasien, 'is_selesai': isSelesai});
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    var jsonResp = json.decode(response.body);
    return pesanObatFromJson(jsonResp);
  } else {
    logger.e('Failed load, status : ${response.statusCode}');
    throw Exception('Failed load, status : ${response.statusCode}');
  }
}

// create (POST)
Future<http.Response?> pesanObatCreate(PesanObat pesanObat) async {
  final prefs = await SharedPreferences.getInstance();
  try {
    var uri = Uri.http(AppConfig.API_HOST, '/goodhealth/pesan_obat/create.php');
    final response = await http.post(uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'id_pasien': prefs.getString(ID_PASIEN),
          'alamat': pesanObat.alamat,
          'lat': pesanObat.lat,
          'lng': pesanObat.lng,
          'list_pesanan': pesanObat.listPesanan,
          'total_biaya': pesanObat.totalBiaya,
          'ket': pesanObat.ket
        }));

    return response;
  } catch (e) {
    logger.e("Error: ${e.toString()}");
    return null;
  }
}

// delete (GET)
Future<String> deletePesanObat(id) async {
  var uri = Uri.http(AppConfig.API_HOST, '/goodhealth/pesan_obat/delete.php', {'id': id.toString()});
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    var jsonResp = json.decode(response.body);
    return jsonResp['message'];
  } else {
    logger.e('Failed load, status : ${response.statusCode}');
    return response.body.toString();
  }
}

// update (GET)
Future<String> updatePesanObat(id) async {
  var uri = Uri.http(AppConfig.API_HOST, '/goodhealth/pesan_obat/update.php', {'id': id.toString()});
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    var jsonResp = json.decode(response.body);
    return jsonResp['message'];
  } else {
    logger.e('Failed load, status : ${response.statusCode}');
    return response.body.toString();
  }
}