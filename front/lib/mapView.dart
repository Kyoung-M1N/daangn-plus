import 'dart:async';
import 'homeView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:html' as html;

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? mapController;
  CameraPosition camposition = CameraPosition(
    target: LatLng(37.5536387, 126.9653032),
    zoom: 8,
  );
  Set<Marker> markersList = {};
  List<DaangnItem> markerResource = [];
  double latitude = 37.5536387;
  double longitude = 126.9653032;
  bool zoom = true;
  bool scroll = true;
  bool loading = false;

  Future<void> setInfoResource(double lat, double lng) async {
    for (var i in dItems) {
      if (lat == i.latitude && lng == i.longitude) {
        markerResource.add(i);
      }
    }
    loading = true;
  }

  void openDraw() {
    scaffoldKey.currentState!.openDrawer();
    setState(() {
      zoom = false;
      scroll = false;
    });
  }

  void openPhoneInfo(context, markerResource) {
    setState(() {
      zoom = false;
      scroll = false;
    });
    showCupertinoModalPopup(
        barrierDismissible: false,
        barrierColor: Colors.white.withAlpha(0),
        context: context,
        builder: (_) => Container(
            height: MediaQuery.of(context).size.height / 5 * 2,
            width: MediaQuery.of(context).size.width,
            color: Color.fromARGB(255, 255, 255, 255),
            child: Column(children: [
              Expanded(
                  child: Container(
                child: loading
                    ? ListView(children: [
                        Builder(builder: (context) {
                          List<Widget> result = [];
                          for (var item in markerResource) {
                            result.add(Card(
                              child: ListTile(
                                title: Text('${item.title}'),
                                subtitle: Text('${item.price}'),
                                trailing: CupertinoButton(
                                  color: item.status == "instock"
                                      ? Colors.orange
                                      : Colors.grey.shade300,
                                  padding: EdgeInsets.all(0),
                                  onPressed: () => html.window.open(
                                      "https://www.daangn.com/articles/" +
                                          item.article.toString(),
                                      "_blank"),
                                  child: Text(
                                    "보러\n가기",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                            ));
                          }
                          return Column(children: [
                            TextButton(
                              style: ButtonStyle(),
                              onPressed: () {},
                              child: Text(
                                '현재 위치 : ${markerResource[0].location}',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                            ),
                            Column(
                              children: result,
                            )
                          ]);
                        })
                      ])
                    : Container(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 10,
                          valueColor: AlwaysStoppedAnimation(
                            Colors.grey.shade400,
                          ),
                        ),
                      ),
              )),
              Container(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      zoom = true;
                      scroll = true;
                    });
                    loading = false;
                    Navigator.pop(context);
                    markerResource.clear();
                  },
                  child: Text('닫기'),
                ),
              ),
              SizedBox(height: 20)
            ])));
  }

  void showMyPosition() async {
    Position position = await Geolocator.getCurrentPosition();
    await mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 11)));
  }

  void moveCamera(double latitude, double longitude) async {
    await mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitude, longitude), zoom: 11)));
  }

  void setMarker(List<DaangnItem> dItems) async {
    if (dItems.isNotEmpty) {
      for (int i = 0; i < dItems.length; i++) {
        markersList.add(Marker(
            markerId: MarkerId('${dItems[i].article}'),
            consumeTapEvents: true,
            onTap: () async {
              markerResource.clear();
              moveCamera(dItems[i].latitude, dItems[i].longitude);
              await setInfoResource(dItems[i].latitude, dItems[i].longitude);
              if (MediaQuery.of(context).size.width >= 900) {
                openDraw();
              } else {
                openPhoneInfo(context, markerResource);
              }
            },
            infoWindow: InfoWindow(title: '${dItems[i].location}'),
            //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
            //icon: BitmapDescriptor.defaultMarkerWithHue(300),
            position: LatLng(dItems[i].latitude, dItems[i].longitude)));
      }
    }
  }

  @override
  void initState() {
    markersList.clear();
    setMarker(dItems);
    showMyPosition();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            "당근플러스 지도",
            style: TextStyle(
                color: Colors.deepPurple, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.deepPurple,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      drawerScrimColor: Colors.white.withAlpha(0),
      drawerEnableOpenDragGesture: false,
      drawer: Drawer(
          child: Column(
        children: [
          ListTile(
            trailing: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    zoom = true;
                    scroll = true;
                  });

                  loading = false;
                  markerResource.clear();
                },
                icon: Icon(Icons.arrow_back)),
          ),
          Expanded(
              child: Container(
            child: loading
                ? ListView(children: [
                    Builder(builder: (context) {
                      List<Widget> result = [];
                      for (var item in markerResource) {
                        result.add(Card(
                          child: ListTile(
                            title: Text('${item.title}'),
                            subtitle: Text('${item.price}'),
                            trailing: CupertinoButton(
                              color: item.status == "instock"
                                  ? Colors.orange
                                  : Colors.grey.shade300,
                              padding: EdgeInsets.all(0),
                              onPressed: () => html.window.open(
                                  "https://www.daangn.com/articles/" +
                                      item.article.toString(),
                                  "_blank"),
                              child: Text(
                                "보러\n가기",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ));
                      }
                      return Column(children: [
                        Text(
                          '현재 위치 : ${markerResource[0].location}',
                          style: TextStyle(fontSize: 15),
                        ),
                        Column(
                          children: result,
                        )
                      ]);
                    })
                  ])
                : Container(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 10,
                      valueColor: AlwaysStoppedAnimation(
                        Colors.grey.shade400,
                      ),
                    ),
                  ),
          )),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(
          Icons.gps_fixed,
          color: Colors.deepPurple,
        ),
        onPressed: () {
          showMyPosition();
        },
      ),
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            scrollGesturesEnabled: scroll,
            zoomGesturesEnabled: zoom,
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

List<Component> component = [Component("component", 'value')];
GoogleGeocoding googleGeocoding =
    GoogleGeocoding("API_KEY");

void getCoordinates() async {
  print(dItems.length);
  for (int i = 0; i < dItems.length; i++) {
    geoCoding(i);
  }
}

Future<GeocodingResponse?> geoCoding(int i) async {
  var result =
      await googleGeocoding.geocoding.get('${dItems[i].location}', component);
  dItems[i].latitude = await result!.results![0].geometry!.location!.lat!;
  dItems[i].longitude = await result.results![0].geometry!.location!.lng!;
  // print('$i\t${result!.results![0].geometry!.location!.lat}\t${result.results![0].geometry!.location!.lng}');
  //return result;
  print(
      '$i\t${dItems[i].article}\t${dItems[i].location}\t\t${dItems[i].latitude}\t${dItems[i].longitude}');
}
