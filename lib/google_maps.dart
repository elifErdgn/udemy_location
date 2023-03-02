import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// google cloud platformdan hesap açmak zorunlu
///
/// api key almak zorunlu
///

class GoogleMapKullanma extends StatefulWidget {
  const GoogleMapKullanma({Key? key}) : super(key: key);

  @override
  State<GoogleMapKullanma> createState() => _GoogleMapKullanmaState();
}

class _GoogleMapKullanmaState extends State<GoogleMapKullanma> {
  Completer<GoogleMapController> haritaKontrol = Completer();

  late BitmapDescriptor konumIcon;

  List<Marker> isaretler = <Marker>[];

  iconOlustur(context) {
    ImageConfiguration configuration = createLocalImageConfiguration(context);
    BitmapDescriptor.fromAssetImage(configuration, "assets/").then((icon) {
      konumIcon = icon;
    });
  }

  var baslangicKonum =
      CameraPosition(target: LatLng(38.7412482, 38.7412482), zoom: 4);

  Future<void> konumaGit() async {
    final GoogleMapController controller = await haritaKontrol.future;

    var gidilecekIsaret = Marker(
        icon: konumIcon,
        markerId: MarkerId("Id"),
        position: LatLng(38.7412482, 38.7412482),
        infoWindow: InfoWindow(
          title: "Istanbul",
          snippet: "Evim",
        ));

    setState(() {
      isaretler.add(gidilecekIsaret);
    });

    var gidilecekKonum =
        CameraPosition(target: LatLng(41.0012482, 38.5432243), zoom: 8);

    controller.animateCamera(CameraUpdate.newCameraPosition(gidilecekKonum));
  }

  @override
  Widget build(BuildContext context) {
    iconOlustur(context);
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: 400,
              height: 300,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: baslangicKonum,
                markers: Set<Marker>.of(isaretler),
                onMapCreated: (GoogleMapController controller) {
                  haritaKontrol.complete(controller);
                },
              ),
            ),
            TextButton(
                onPressed: () {
                  konumaGit();
                },
                child: Center(
                  child: Text("Konuma Git"),
                ))
          ],
        ),
      ),
    );
  }
}
