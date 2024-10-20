import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:good_health/model/user.dart';
import 'package:good_health/page/modul_pasien/index.dart' as index_pasien;
import 'package:good_health/page/modul_pasien/signup.dart';
import 'package:good_health/page/modul_pegawai/index.dart' as index_pegawai;
import 'package:good_health/util/session.dart';
import 'package:good_health/util/util.dart';
import 'dart:developer' as developer;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool _isHovering = false;

  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameCont = TextEditingController();
  TextEditingController passCont = TextEditingController();

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
              controller: usernameCont,
              decoration: InputDecoration(
                icon: const Icon(Icons.person),
                hintText: 'Username',
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
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
              controller: passCont,
              obscureText: true,
              decoration: InputDecoration(
                icon: const Icon(Icons.vpn_key),
                hintText: 'Password',
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
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
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _login, child: const Text('Login')),
            const SizedBox(height: 20),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => setState(() => _isHovering = true),
              onExit: (_) => setState(() => _isHovering = false),
              child: GestureDetector(
                onTap: () async {
                  final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage()));

                  if (result != null && mounted) {
                    dialog(context, result);
                  }
                },
                child: Text(
                  'Anda belum punya akun?\nRegistrasi pasien baru',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: _isHovering ? Colors.green : Colors.black),
                ),
              ),
            ),
          ],
        ));
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await login(User(
            username: usernameCont.text,
            password: passCont.text,
            idUser: '',
            idPasien: '1'));

        if (response != null) {
          developer.log('Response status: ${response.statusCode}');
          developer.log('Response body: ${response.body}');
          if (response.body.isNotEmpty) {
            var jsonResp = json.decode(response.body);

            if (response.statusCode == 200) {
              developer.log(jsonResp['user']['username']);

              if (jsonResp['user']['id_pasien'] != null) {
                await createPasienSessionx(
                    jsonResp['user']['id_pasien']['id_pasien'].toString(),
                    jsonResp['user']['id_pasien']['nama'],
                    jsonResp['user']['id_pasien']['hp'],
                    jsonResp['user']['id_pasien']['email']);

                if (mounted) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const index_pasien.IndexPage()));
                }
              } else {
                await createPegawaiSession(jsonResp['user']['username']);
                if (mounted) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const index_pegawai.IndexPage()));
                }
                /* if (mounted) {
                  dialog(context, jsonResp['user']['username']);
                } */
              }
            } else if (response.statusCode == 401) {
              if (mounted) {
                dialog(context, jsonResp['message']);
              }
            } else {
              if (mounted) {
                dialog(context, response.body.toString());
              }
            }
          } else {
            if (mounted) {
              dialog(context, 'Error: Empty response from server.');
            }
          }
        } else {
          if (mounted) {
            dialog(context, 'No response from server');
          }
        }
      } catch (e) {
        developer.log('Error: $e');
        if (mounted) {
          dialog(context, e.toString());
        }
      }
    }
  }
}
