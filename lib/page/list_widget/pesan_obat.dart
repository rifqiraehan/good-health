import 'package:flutter/material.dart';
import 'package:good_health/model/pesan_obat.dart';
import 'package:good_health/util/util.dart';

class PesanObatList extends StatefulWidget {
  final List<PesanObat> pesanObats;
  const PesanObatList({super.key, required this.pesanObats});

  @override
  PesanObatListState createState() => PesanObatListState();
}

class PesanObatListState extends State<PesanObatList> {
  @override
  Widget build(BuildContext context) {
    return (widget.pesanObats.isNotEmpty)
        ? ListView.builder(
            itemCount: widget.pesanObats.length,
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
                        subtitle: Text(
                        "${widget.pesanObats[i].listPesanan} \n${widget.pesanObats[i].alamat} \n${widget.pesanObats[i].ket}"),
                        trailing: Text(
                          (widget.pesanObats[i].isSelesai ?? false) ? 'Selesai' : 'Belum selesai',
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ),
                      OverflowBar(
                        children: <Widget>[
                          Visibility(
                            child: TextButton(
                                onPressed: () async {
                                  final result = await deletePesanObat(
                                      widget.pesanObats[i].idPesanObat);

                                  // Check if the widget is still mounted
                                  if (!mounted) return;

                                  setState(() {
                                    widget.pesanObats.removeAt(i);
                                  });

                                  // Only call dialog if the widget is still mounted
                                  if (mounted) {
                                    dialog(context, result);
                                  }
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                                ),
                                child: const Text('HAPUS')),
                          )
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