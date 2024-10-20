import 'package:flutter/material.dart';
import 'package:good_health/model/pesan_obat.dart';
import 'package:good_health/page/list_widget/pesan_obat.dart';
import 'package:good_health/page/modul_pasien/pesan_obat/create.dart'
    as PesanObatCreate;
import 'package:good_health/util/util.dart';

class PesanObatContent extends StatefulWidget {
  static String title = "Pesan Obat";

  const PesanObatContent({super.key});

  @override
  PesanObatContentState createState() => PesanObatContentState();
}

class PesanObatContentState extends State<PesanObatContent> {
  late Future<List<PesanObat>> pesanObats;

  @override
  void initState() {
    super.initState();
    pesanObats = fetchPesanObats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const PesanObatCreate.CreatePage()));

          if (result != null && mounted) {
            setState(() {
              pesanObats = fetchPesanObats();
            });
            if (mounted) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  dialog(context, result);
                }
              });
            }
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Center(
        child: FutureBuilder(
            future: pesanObats,
            builder: (context, snapshot) {
              Widget result;
              if (snapshot.hasError) {
                result = Text('${snapshot.error}');
              } else if (snapshot.hasData) {
                result = PesanObatList(pesanObats: snapshot.data!);
              } else {
                result = const CircularProgressIndicator();
              }
              return result;
            }),
      ),
    );
  }
}
