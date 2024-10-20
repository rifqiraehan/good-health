import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:good_health/model/pesan_obat.dart';
//import 'package:good_health/util/util.dart';

class PesanObatViewPage extends StatefulWidget {
  final PesanObat pesanObat;

  const PesanObatViewPage({super.key, required this.pesanObat});

  @override
  PesanObatViewPageState createState() => PesanObatViewPageState();
}

class PesanObatViewPageState extends State<PesanObatViewPage> {
  late LatLng alamatLatLng;

  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  static late CameraPosition _currentPosition; // Location set is Kampus PENS

  @override
  void initState() {
    super.initState();
    alamatLatLng = LatLng(
        double.parse(widget.pesanObat.lat), double.parse(widget.pesanObat.lng));
    _currentPosition = CameraPosition(target: alamatLatLng, zoom: 14.4746);
    _addMarker(alamatLatLng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Informasi Pesanan'),
        ),
        body: Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: <Widget>[
                Flexible(flex: 1, child: _map()),
                Flexible(
                  flex: 1,
                  child: ListView(
                    children: <Widget>[
                      DataTable(columns: const [
                        DataColumn(label: Text('Informasi')),
                        DataColumn(label: Text(''))
                      ], rows: [
                        DataRow(cells: [
                          const DataCell(Text('Nama Pemesan')),
                          DataCell(Text(widget.pesanObat.idPasien!.nama))
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('Telfon')),
                          DataCell(Text(widget.pesanObat.idPasien!.hp))
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('Alamat')),
                          DataCell(Text(widget.pesanObat.alamat))
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('Pesanan')),
                          DataCell(
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6, // Adjust the width as needed
                              child: Text(widget.pesanObat.listPesanan),
                            ),
                          ),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('Waktu')),
                          DataCell(Text(widget.pesanObat.waktu))
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('Catatan')),
                          DataCell(Text(widget.pesanObat.ket))
                        ]),
                      ])
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: ElevatedButton(
          onPressed: () async {
            final result = await updatePesanObat(widget.pesanObat.idPesanObat);
            if (!mounted) return;
            if (context.mounted) {
              Navigator.pop(context, result);
            }
          },
          child: const Text('Pesanan Selesai'),
        ));
  }

  Widget _map() {
    return SizedBox(
      height: 300,
      child: GoogleMap(
        markers: _markers,
        initialCameraPosition: _currentPosition,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        onTap: (LatLng latLng) => _addMarker(latLng),
      ),
    );
  }

  void _addMarker(LatLng position) async {
    final GoogleMapController controller = await _controller.future;
    setState(() {
      if (_markers.isNotEmpty) _markers.clear();
      _markers.add(Marker(
          markerId: const MarkerId("myPosition"),
          position: position,
          icon: BitmapDescriptor.defaultMarker));

      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: position, zoom: 18)));
    });
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<CameraPosition>(
        '_currentPosition', _currentPosition));
    properties.add(DiagnosticsProperty<CameraPosition>(
        '_currentPosition', _currentPosition));
    properties.add(DiagnosticsProperty<CameraPosition>(
        '_currentPosition', _currentPosition));
    properties.add(DiagnosticsProperty<CameraPosition>(
        '_currentPosition', _currentPosition));
  }
}