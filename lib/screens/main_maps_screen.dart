import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hopfield_tsp_app/google_maps/custom_components/custom_info_window.dart';
import 'package:hopfield_tsp_app/google_maps/fat_markers_repository.dart';
import 'package:hopfield_tsp_app/google_maps/maps_style/map_styles.dart';
import 'package:hopfield_tsp_app/google_maps/markers_collector.dart';

class MainMapsScreen extends StatefulWidget {
  MainMapsScreen({Key key}) : super(key: key);

  @override
  _MainMapsScreenState createState() => _MainMapsScreenState();
}

class _MainMapsScreenState extends State<MainMapsScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(3.5952, 98.6722),
    zoom: 11.5,
  );

  GoogleMapController _googleMapController;
  Set<Marker> markers = {};
  Set<Circle> circles = Set.from([
    Circle(
      circleId: CircleId("Current Location"),
      center: LatLng(3.784303, 3.784303),
      radius: 4000,
    )
  ]);
  Position _currentPosition;
  var checkedDataHasProcessed;
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  // Set<String> test = {"z"}; // test variable

  @override
  void initState() {
    super.initState();
    getMarkerCurrentLocation();
    getMarker("PT.XYZ", LatLng(3.5929306988756213, 98.67724238156745),
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet));
    new Future.delayed(new Duration(seconds: 2), () {
      checkedDataHasProcessed = getMarkersFat();
    });
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    //  _customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: checkedDataHasProcessed,
        builder: (context, data) {
          if (data.hasData) {
            return SafeArea(
              child: Scaffold(
                // appBar: AppBar(
                //   title: Text("Test 1"),
                //   backgroundColor: Colors.blue,
                // ),
                body: Stack(
                  alignment: Alignment.center,
                  children: [
                    GoogleMap(
                        zoomGesturesEnabled: true,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        zoomControlsEnabled: true,
                        circles: circles,
                        initialCameraPosition: _initialCameraPosition,
                        onMapCreated: (controller) {
                          _googleMapController = controller;
                          _googleMapController
                              .setMapStyle(MapStyles.mapStylesRetro);
                          _customInfoWindowController.googleMapController =
                              controller;
                        },
                        markers: (markers != null) ? markers : {},

                        /// tap and camera move for customInfoWindow
                        onTap: (position) {
                          _customInfoWindowController.hideInfoWindow();
                        },
                        onCameraMove: (position) {
                          _customInfoWindowController.onCameraMove();
                        },
                        onLongPress: (latLng) {
                          getMarker(
                              "Origin",
                              latLng,
                              BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueYellow));
                        }),
                    if (MarkersCollector.pointNameList.isNotEmpty)
                      bottomSheet(),
                    CustomInfoWindow(
                      controller: _customInfoWindowController,
                      height: 100,
                      width: 200,
                      offset: 50,
                    ),
                  ],
                ),
                // floatingActionButton: FloatingActionButton(
                //   backgroundColor: Theme.of(context).primaryColor,
                //   foregroundColor: Colors.black,
                //   onPressed: () => {getCurrentLocation()},
                //   child: const Icon(Icons.center_focus_strong_sharp)
                // ),
                // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
              ),
            );
          } else {
            return Scaffold(
                backgroundColor: Colors.grey[800],
                body: Center(
                  child: SpinKitWave(
                      color: Colors.white, type: SpinKitWaveType.start),
                ));
          }
        });
  }

  void getMarker(String markerName, LatLng latLng, icon) {
    setState(() {
      markers.add(
        Marker(
            markerId: MarkerId(markerName),
            icon: icon,
            position: latLng,
            onTap: () {
              customInfoWindow(
                markerName,
                latLng,
              );
            }),
      );
    });
  }

  void getMarkerCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        String currentLocationName = "Current Location";
        LatLng latLng =
            LatLng(_currentPosition.latitude, _currentPosition.longitude);
        markers.add(
          Marker(
              markerId: MarkerId(currentLocationName),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure),
              position: latLng,
              onTap: () {
                customInfoWindow(
                  currentLocationName,
                  latLng,
                );
              }),
        );
        MarkersCollector(
                currentLocationName,
                _currentPosition.latitude.toString(),
                _currentPosition.longitude.toString())
            .addMarkerToDataMap();
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future<dynamic> getMarkersFat() async {
    final processedFatMarkers =
        await FatMarkersRepository().getFatMarkersData();

    setState(() {
      for (var item in processedFatMarkers) {
        LatLng latLng =
            LatLng(double.parse(item.latitude), double.parse(item.longitude));
        markers.add(Marker(
          markerId: MarkerId(item.fatName),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position: latLng,
          onTap: () {
            customInfoWindow(
              item.fatName,
              latLng,
            );
          },
        ));
      }
    });
    return processedFatMarkers;
  }

  Widget bottomSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.13,
      maxChildSize: 0.9,
      builder: (BuildContext context, ScrollController scrolController) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: ListView.builder(
                itemCount: MarkersCollector.pointNameList.length,
                controller: scrolController,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Icon(Icons.add_location_sharp),
                    title: Text(MarkersCollector.pointNameList[index]),
                    trailing: IconButton(
                      icon: new Icon(Icons.remove_circle_outline_sharp),
                      highlightColor: Colors.red,
                      onPressed: () {
                        setState(() {
                          MarkersCollector.dataMap
                              .remove(MarkersCollector.pointNameList[index]);
                          MarkersCollector.pointNameList.removeAt(index);
                        });
                      },
                    ),
                  );
                }),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        );
      },
    );
  }

  dynamic customInfoWindow(
    String pointName,
    LatLng latLng,
  ) {
    return _customInfoWindowController.addInfoWindow(
      Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 8.0),
                child: Wrap(
                  children: [
                    Center(
                      child: Text(
                        pointName,
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                MarkersCollector(
                                        pointName,
                                        latLng.latitude.toString(),
                                        latLng.longitude.toString())
                                    .addMarkerToDataMap();
                              });
                            },
                            style: TextButton.styleFrom(
                              primary: Colors.black,
                              onSurface: Colors.white,
                              backgroundColor: Colors.green,
                              shape: const BeveledRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            child: Text("Add")),
                      ),
                    )
                  ],
                ),
              ),
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Triangle.isosceles(
            edge: Edge.BOTTOM,
            child: Container(
              color: Colors.black,
              width: 20.0,
              height: 10.0,
            ),
          ),
        ],
      ),
      latLng,
    );
  }

  // void markerObject(Marker marker) {
  //   // marker.copyWith().toJson();
  //   debugPrint('testFunction: ${marker.copyWith().toJson()} ');
  // }
}
