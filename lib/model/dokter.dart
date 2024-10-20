import 'dart:convert';
import 'package:good_health/util/config/config.dart';
import 'package:http/http.dart' as http;

class Dokter {
  final String idDokter, nama, hp;

  Dokter({required this.idDokter, required this.nama, required this.hp});

  factory Dokter.fromJson(Map<String, dynamic> json) {
    return Dokter(
        idDokter: json['id_dokter'].toString(),
        nama: json['nama'],
        hp: json['hp']);
  }
}

List<Dokter> dokterFromJson(jsonData) {
  List<Dokter> result =
      List<Dokter>.from(jsonData.map((item) => Dokter.fromJson(item)));

  return result;
}

// index
Future<List<Dokter>> fetchDokters() async {
  var uri = Uri.http(AppConfig.API_HOST, '/goodhealth/dokter/index.php');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    var jsonResp = json.decode(response.body);
    return dokterFromJson(jsonResp);
  } else {
    //throw Exception('Failed load $route, status : ${response.statusCode}');
    throw Exception('Failed load, status : ${response.statusCode}');
  }
}
