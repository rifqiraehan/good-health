import 'package:flutter/material.dart';
import 'package:good_health/model/pesan_obat.dart';
import 'package:good_health/page/list_widget/pesan_obat_pegawai.dart';
import 'package:good_health/util/util.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  IndexPageState createState() => IndexPageState();
}

class IndexPageState extends State<IndexPage> {
  late Future<List<PesanObat>> pesanObats;

  @override
  void initState() {
    super.initState();
    _reloadData();
  }

  _reloadData() {
    setState(() {
      //pesanObats = fetchPesanObats(isSelesai: '0');
      pesanObats = fetchPesanObats(isSelesai: '0');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Index Pegawai'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: () => logOut(context))
        ],
      ),
      body: Center(
        child: FutureBuilder(
            future: pesanObats,
            builder: (context, snapshot) {
              Widget result;
              if (snapshot.hasError) {
                result = Text('${snapshot.error}');
              } else if (snapshot.hasData) {
                result = PesanObatPegawaiList(
                    parentAction: _reloadData, pesanObats: snapshot.data!);
              } else {
                result = const CircularProgressIndicator();
              }
              return result;
            }),
      ),
    );
  }
}
