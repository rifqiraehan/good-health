import 'package:flutter/material.dart';
import 'package:good_health/model/reg_poli.dart';
import 'package:good_health/page/list_widget/reg_poli.dart';
import 'package:good_health/page/modul_pasien/reg_poli/create.dart'
    as RegisPoliCreate;
import 'package:good_health/util/util.dart';

class RegisPoliContent extends StatefulWidget {
  static String title = "Registrasi Poli";

  const RegisPoliContent({super.key});

  @override
  RegisPoliContentState createState() => RegisPoliContentState();
}

class RegisPoliContentState extends State<RegisPoliContent> {
  late Future<List<RegisPoli>> regisPolis;

  @override
  void initState() {
    super.initState();
    regisPolis = fetchRegisPolis();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const RegisPoliCreate.CreatePage()));

          // Only perform actions if the widget is still mounted
          if (result != null && mounted) {
            setState(() {
              regisPolis = fetchRegisPolis();
            });

            if (mounted) {
              dialog(context, result); // Ensure context is safe to use
            }
          }
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      body: Center(
        child: FutureBuilder(
            future: regisPolis,
            builder: (context, snapshot) {
              Widget result;
              if (snapshot.hasError) {
                result = Text('${snapshot.error}');
              } else if (snapshot.hasData) {
                result = RegisPoliList(regisPolis: snapshot.data!);
              } else {
                result = const CircularProgressIndicator();
              }
              return result;
            }),
      ),
    );
  }
}
