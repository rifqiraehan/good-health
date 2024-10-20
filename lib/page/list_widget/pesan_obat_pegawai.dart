import 'package:flutter/material.dart';
import 'package:good_health/model/pesan_obat.dart';
import 'package:good_health/page/modul_pegawai/pesan_obat_view.dart';
import 'package:good_health/util/util.dart';

class PesanObatPegawaiList extends StatefulWidget {
  final List<PesanObat> pesanObats;
  final Function parentAction;
  const PesanObatPegawaiList({super.key, required this.parentAction, required this.pesanObats});

  @override
  PesanObatPegawaiListState createState() => PesanObatPegawaiListState();
}

class PesanObatPegawaiListState extends State<PesanObatPegawaiList> {
  @override
  Widget build(BuildContext context) {
    return (widget.pesanObats.isNotEmpty)
        ? ListView.builder(
            itemCount:
                // ignore: unnecessary_null_comparison
                (widget.pesanObats == null ? 0 : widget.pesanObats.length),
            itemBuilder: (context, i) {
              return GestureDetector(
                onTap: null,
                child: Card(
                  color: Colors.white,
                  shadowColor: const Color.fromRGBO(235, 235, 235, 1).withOpacity(1.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(color: Color.fromRGBO(235, 235, 235, 1), width: 1.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.local_hospital),
                        isThreeLine: true,
                        title: Text("${widget.pesanObats[i].idPasien?.nama}"),
                        subtitle: Text(
                            "${widget.pesanObats[i].listPesanan} \n${widget.pesanObats[i].alamat} \n${widget.pesanObats[i].ket}"),
                        trailing: Text(toRupiah(
                            int.parse(widget.pesanObats[i].totalBiaya)),
                            style: const TextStyle(fontSize: 14.0),
                            ),
                      ),
                      OverflowBar(
                        children: <Widget>[
                          TextButton(
                              onPressed: () async {
                                final result = await Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) =>
                                            PesanObatViewPage(
                                                pesanObat:
                                                    widget.pesanObats[i])));
                                if (result != null && mounted) {
                                  setState(() {
                                    widget.parentAction();
                                    dialog(context, result);
                                  });
                                }
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.green, // Set the text color to green
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold, // Set the font weight to bold
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 20.0), // Add padding
                              ),
                              child: const Text('LOKASI')),
                        ],
                      )
                    ],
                  ),
                ),
              );
            })
        : const Text('Tidak ada riwayat pesanan');
  }
}