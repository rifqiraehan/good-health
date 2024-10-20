import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:good_health/page/login.dart';
import 'package:good_health/page/modul_pasien/index.dart' as index_pasien;
import 'package:good_health/page/modul_pegawai/index.dart' as index_pegawai;
import 'package:good_health/util/session.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          iconTheme: IconThemeData(
            color: Colors.white, //
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: FutureBuilder(
        future: _loadSession(),
        builder: (context, snapshot) {
          late final SharedPreferences prefs = snapshot.data;
          late Widget result;
          if (snapshot.connectionState == ConnectionState.waiting) {
            result = const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (prefs.getBool(IS_LOGIN) ?? false) {
                if (prefs.getString(JENIS_LOGIN) ==
                    jenisLogin.PASIEN.toString()) {
                  result = const index_pasien.IndexPage();
                } else {
                  result = const index_pegawai.IndexPage();
                }
              } else {
                result = const LoginPage();
              }
            } else {
              return const Center(child: Text('Error..'));
            }
          }
          return result;
        },
      ),
    );
  }

  Future _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs;
  }
}