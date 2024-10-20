import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:good_health/util/session.dart';

class HomeContent extends StatefulWidget {
  static String title = 'Home Pasien';

  const HomeContent({super.key});

  @override
  HomeContentState createState() => HomeContentState();
}

class HomeContentState extends State<HomeContent> {
  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString(NAMA) ?? 'User';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          text: 'Selamat Datang,\n',
          style: const TextStyle(fontSize: 25),
          children: <TextSpan>[
            TextSpan(
              text: _username,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            const TextSpan(
              text: '\nDi Aplikasi GOOD HEALTH',
              style: TextStyle(fontSize: 25),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}