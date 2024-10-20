import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:good_health/model/obat.dart';
import 'package:good_health/model/pesan_obat.dart';
import 'package:good_health/util/util.dart';
import 'package:logger/logger.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  CreatePageState createState() => CreatePageState();
}

class CreatePageState extends State<CreatePage> {
  TextEditingController alamatCont = TextEditingController();
  TextEditingController ketCont = TextEditingController();
  LatLng alamatLatLng = const LatLng(-7.274537183066055, 112.7938013614994);
  int totalBiaya = 0;

  List<Obat> obats = <Obat>[];
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  static late CameraPosition _currentPosition; // Location set is Kampus PENS

  // Create a logger instance
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    _currentPosition = CameraPosition(target: alamatLatLng, zoom: 14.4746);
    _addMarker(alamatLatLng);

    fetchObats().then((result) {
      setState(() {
        obats = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Pesanan'),
      ),
      bottomNavigationBar: ElevatedButton(onPressed: () => _isFormValid() ? _saveData() : null, child: Text('PESAN SEKARANG (${toRupiah(totalBiaya)})')),
      body: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
              Flexible(flex: 1, child: _map()),
              Flexible(
                flex: 1,
                child: ListView(
                  children: <Widget>[
                    _alamatText(),
                    const SizedBox(height: 10),
                    _ketText(),
                    const SizedBox(height: 10),
                    _obatCheckbox()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveData() async {
    String listPesanan = "";
    int totalBiaya = 0;
    obats.where((obat) => obat.isSelected).toList().forEach((obat) {
      listPesanan =
          "$listPesanan- ${obat.nama} (${obat.jumlah}) ${obat.satuan}\n";
      totalBiaya = totalBiaya + (obat.jumlah * int.parse(obat.harga));
    });
    PesanObat pesanObat = PesanObat(
        alamat: alamatCont.text,
        lat: alamatLatLng.latitude.toString(),
        lng: alamatLatLng.longitude.toString(),
        listPesanan: listPesanan,
        totalBiaya: totalBiaya.toString(),
        ket: ketCont.text, idPesanObat: '', idPasien: null, waktu: '');

    final response = await pesanObatCreate(pesanObat);
    if (response != null) {
      logger.i(response.body.toString());
      if (response.statusCode == 200) {
        var jsonResp = json.decode(response.body);
        if (mounted) {
          Navigator.pop(context, jsonResp['message']);
        }
      } else {
        logger.e('Status Code: ${response.statusCode}');
        logger.e(response.body.toString());
        if (mounted) {
          dialog(context, response.body.toString());
        }
      }
    }
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
      setState(() {
        alamatLatLng = position;
      });
    });
  }

  Widget _obatCheckbox() {
    return FutureBuilder(
        future: fetchObats(),
        builder: (context, snapshot) {
          Widget result;
          if (snapshot.hasData) {
            result = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: obats.map((obat) {
                return CheckboxListTile(
                    value: obat.isSelected,
                    title: Text(
                        "${obat.nama}/${obat.satuan} @ ${toRupiah(int.parse(obat.harga))}"),
                    controlAffinity: ListTileControlAffinity.leading,
                    secondary: Visibility(
                        visible: obat.isSelected,
                        child: SizedBox(
                          width: 60,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            initialValue:
                                obats[obats.indexOf(obat)].jumlah.toString(),
                            decoration: const InputDecoration(hintText: 'Jumlah'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Tidak boleh kosong';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                obats[obats.indexOf(obat)].jumlah =
                                    int.parse(value);
                              });
                              _hitungTotalBiaya();
                            },
                          ),
                        )),
                    onChanged: (bool? val) => setState(() {
                        obats[obats.indexOf(obat)].isSelected = val!;
                        if (!val) {
                          setState(() {
                            obats[obats.indexOf(obat)].jumlah = 1;
                          });
                        }
                        _hitungTotalBiaya();
                      }));
              }).toList(),
            );
          } else if (snapshot.hasError) {
            result = Center(child: Text("${snapshot.error}"));
          } else {
            result = const Center(child: CircularProgressIndicator());
          }

          return result;
        });
  }

  bool _isFormValid() {
    List<String> message = <String>[];
    if (alamatCont.text.isEmpty) {
      message.add("Alamat belum diisi");
    }

    if (obats.where((obat) => obat.isSelected).toList().isEmpty) {
      message.add("Obat belum dipilih");
    }

    if (message.isNotEmpty) {
      dialog(context, message.join(', '));
      return false;
    }

    return true;
  }

  void _hitungTotalBiaya() {
    totalBiaya = 0;
    List<Obat> obatsSelected = obats.where((obat) => obat.isSelected).toList();
    setState(() {
      for (var obat in obatsSelected) {
        totalBiaya = totalBiaya + (int.parse(obat.harga) * obat.jumlah);
      }
      logger.i('totalBiaya : $totalBiaya');
    });
  }

  Widget _alamatText() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: alamatCont,
      decoration:
          const InputDecoration(icon: Icon(Icons.store), hintText: 'Alamat Lengkap'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget _ketText() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: ketCont,
      decoration:
          const InputDecoration(icon: Icon(Icons.textsms), hintText: 'Keterangan'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Tidak boleh kosong';
        }
        return null;
      },
    );
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
}