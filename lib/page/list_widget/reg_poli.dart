import 'package:flutter/material.dart';
import 'package:good_health/model/reg_poli.dart';
import 'package:good_health/util/util.dart';

class RegisPoliList extends StatefulWidget {
  final List<RegisPoli> regisPolis;
  const RegisPoliList({super.key, required this.regisPolis});

  @override
  RegisPoliListState createState() => RegisPoliListState();
}

class RegisPoliListState extends State<RegisPoliList> {
  @override
  Widget build(BuildContext context) {
    return (widget.regisPolis.isNotEmpty)
        ? ListView.builder(
            itemCount:
                (widget.regisPolis == null ? 0 : widget.regisPolis.length),
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
                        leading: const Icon(Icons.assignment),
                        isThreeLine: true,
                        title: Text(widget.regisPolis[i].idDokter.nama),
                        subtitle: Text(widget.regisPolis[i].tglBooking),
                        trailing: Text(
                          widget.regisPolis[i].poli,
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ),
                      OverflowBar(
                        children: <Widget>[
                          TextButton(
                              onPressed: () async {
                                final result = await deleteRegisPoli(
                                    widget.regisPolis[i].idRegisPoli);
                                if (!mounted) return;
                                setState(() {
                                  widget.regisPolis.removeAt(i);
                                });
                                if (context.mounted) {
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
                              child: const Text('HAPUS'))
                        ],
                      )
                    ],
                  ),
                ),
              );
            })
        : const Text('Tidak ada riwayat registrasi');
  }
}