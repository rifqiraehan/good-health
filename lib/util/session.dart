import 'package:shared_preferences/shared_preferences.dart';
import 'package:good_health/model/pasien.dart';

const IS_LOGIN = 'IS_LOGIN';
const JENIS_LOGIN = 'JENIS_LOGIN';
const ID_PASIEN = 'ID_PASIEN';
const NAMA = 'NAMA';
const HP = 'HP';
const EMAIL = 'EMAIL';

enum jenisLogin { PASIEN, PEGAWAI }

Future createPasienSession(Pasien pasien) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool(IS_LOGIN, true);
  prefs.setString(ID_PASIEN, pasien.idPasien);
  prefs.setString(NAMA, pasien.nama);
  prefs.setString(HP, pasien.hp);
  prefs.setString(EMAIL, pasien.email);
  prefs.setString(JENIS_LOGIN, jenisLogin.PASIEN.toString());
  return true;
}

Future createPasienSessionx(String id, String nama, String hp, String email) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool(IS_LOGIN, true);
  prefs.setString(ID_PASIEN, id);
  prefs.setString(NAMA, nama);
  prefs.setString(HP, hp);
  prefs.setString(EMAIL, email);
  prefs.setString(JENIS_LOGIN, jenisLogin.PASIEN.toString());
  return true;
}

Future createPegawaiSession(String username) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool(IS_LOGIN, true);
  prefs.setString(NAMA, username);
  prefs.setString(JENIS_LOGIN, jenisLogin.PEGAWAI.toString());
  return true;
}

Future clearSession() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.clear();
  return true;
}
