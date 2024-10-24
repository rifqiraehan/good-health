import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_health/model/pasien.dart';
import 'package:good_health/page/login.dart';
import 'package:good_health/util/util.dart';
import 'package:logger/logger.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isHovering = false;
  TextEditingController namaCont = TextEditingController();
  TextEditingController hpCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();

  // Create a logger instance
  final logger = Logger();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.green,
        body: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('GOOD HEALTH',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 25),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: _formWidget(),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _formWidget() {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: namaCont,
              decoration: InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Nama Lengkap',
                iconColor: WidgetStateColor.resolveWith((states) =>
                    states.contains(WidgetState.focused)
                        ? Colors.green
                        : Colors.grey),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Tidak boleh kosong';
                }
                return null;
              },
            ),
            TextFormField(
              controller: hpCont,
              decoration: InputDecoration(
                icon: const Icon(Icons.phone_android),
                hintText: 'Nomor HP',
                iconColor: WidgetStateColor.resolveWith((states) =>
                    states.contains(WidgetState.focused)
                        ? Colors.green
                        : Colors.grey),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Tidak boleh kosong';
                }
                return null;
              },
              onFieldSubmitted: (value) => _submitForm(),
            ),
            TextFormField(
              controller: emailCont,
              decoration: InputDecoration(
                icon: const Icon(Icons.alternate_email),
                hintText: 'Email',
                iconColor: WidgetStateColor.resolveWith((states) =>
                    states.contains(WidgetState.focused)
                        ? Colors.green
                        : Colors.grey),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Tidak boleh kosong';
                }
                return null;
              },
              onFieldSubmitted: (value) => _submitForm(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: prosesRegistrasi, child: const Text('Register')),
            const SizedBox(height: 20),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => setState(() => _isHovering = true),
              onExit: (_) => setState(() => _isHovering = false),
              child: GestureDetector(
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                ),
                child: Text(
                  'Anda sudah punya akun? Login',
                  style: TextStyle(
                      color: _isHovering ? Colors.green : Colors.black),
                ),
              ),
            ),
          ],
        ));
  }

   void _submitForm() {
    if (_formKey.currentState!.validate()) {
      prosesRegistrasi();
    }
  }

  void prosesRegistrasi() async {
    if (_formKey.currentState!.validate()) {
      final response = await pasienCreate(Pasien(
          nama: namaCont.text,
          hp: hpCont.text,
          email: emailCont.text,
          idPasien: ''));

      if (response != null) {
        logger.i(response.body.toString());
        if (response.statusCode == 200) {
          var jsonResp = json.decode(response.body);
          if (mounted) {
            Navigator.pop(context, jsonResp['message']);
          }
        } else {
          if (mounted) {
            dialog(context, response.body.toString());
          }
        }
      }
    }
  }
}
