import 'dart:async';
import 'homeView.dart';
import 'package:flutter/material.dart';
//import 'package:geocoding/geocoding.dart';
//import 'package:geocoding_platform_interface/geocoding_platform_interface.dart';
import 'package:google_geocoding/google_geocoding.dart';
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
  //Location? temp;
  List<Location>? location;
  double? geocode;
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
            target: LatLng(position.latitude, position.longitude), zoom: 12)));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("당근플러스 지도"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.gps_fixed),
        onPressed: () async {
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
          // Card(
          //   elevation: 2.5,
          //   child: ListTile(
          //     leading: Icon(Icons.search),
          //     title: Text("${geocode.toString()}"),

          //   ),
          // ),
        ],
      ),
    );
  }
}

List<Component> component = [Component("component", 'value')];
GoogleGeocoding googleGeocoding =
    GoogleGeocoding("AIzaSyCmhbnc8_ZQifGJEvCgQ0WmKdUWWfdw84M");
Set<Marker> markersList = {};
// Marker mark = Marker(
//     markerId: MarkerId('1'),
//     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
//     position: LatLng(37.5536387, 126.9653032));
List<Location>? list = [];

void getCoordinates() async {
  // List<Component> component = [Component("component", 'value')];
  var result;
  for (var i in dItems) {
    result = await googleGeocoding.geocoding.get('${i.location}', component);
    //print('${i.title}')
    list!.add(result!.results[0].geometry.location);
    //print('${list![0].geometry!.location!.lat}');
  }
  //list = result!.results;
  for (var j in list!) {
    print('${j.lat}, ${j.lng}');
  }
}

void setMarker(List<DaangnItem> dItems) async {
  if (dItems.isNotEmpty) {
    for (int i = 0; i < list!.length; i++) {
      markersList.add(Marker(
          markerId: MarkerId('id$i'),
          infoWindow: InfoWindow(
              title: '${dItems[i].title}', snippet: '${dItems[i].price}'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position: LatLng(list![i].lat!, list![i].lng!)));
    }
  }
}
