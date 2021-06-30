import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:google_maps_flutter_web/google_maps_flutter_web.dart' as web;

class MapPage extends StatefulWidget {
  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  double latitude = 37.5536387;
  double longitude = 126.9653032;
  String? geocode;
  Set<Marker> markersList = {};
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? mapController;
  CameraPosition camposition = CameraPosition(
    target: LatLng(37.5536387, 126.9653032),
    zoom: 8,
  );

  @override
  void initState() {
    setPosition();
    super.initState();
  }

  void setPosition() async {
    Position position = await Geolocator.getCurrentPosition();
    // placemark = await placemarkFromCoordinates(position.latitude, position.longitude);
    // geocode = '${placemark[0].administrativeArea.toString()} ${placemark[0].locality.toString()} ${placemark[0].thoroughfare.toString()}';
    await mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 16)));
    setState(() {
      geocode = geocode;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("당근플러스 지도"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.gps_fixed),
        onPressed: () {
          setPosition();
          setState(() {
            geocode = geocode;
          });
        },
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            zoomControlsEnabled: false,
            //myLocationButtonEnabled: false,
            //myLocationEnabled: true,
            initialCameraPosition: camposition,
            markers: markersList,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              _controller.complete(controller);
            },
          ),
        ],
      ),
    );
  }
}
