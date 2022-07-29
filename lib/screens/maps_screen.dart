import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hopfield_tsp_app/google_maps/custom_components/custom_marker.dart';
import 'package:hopfield_tsp_app/google_maps/maps_style/map_styles.dart';
import 'package:hopfield_tsp_app/google_maps/markers_collector.dart';
import 'package:hopfield_tsp_app/google_maps/markers_repository.dart';

class MapsScreen extends StatefulWidget {
  MapsScreen({Key key}) : super(key: key);

  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(3.5952, 98.6722),
    zoom: 11.5,
  );

  GoogleMapController _googleMapController;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  double distance = 0;
  var checkedDataHasProcessed;
  // Set<String> test = {"z"}; // test variable
  // MarkersProcess _markersData;

  @override
  void initState() {
    super.initState();
    new Future.delayed(new Duration(seconds: 2), () {
      checkedDataHasProcessed = getMarkers();
    });
  }

  @override
  void dispose() {
    _googleMapController.dispose();
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
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      initialCameraPosition: _initialCameraPosition,
                      onMapCreated: (controller) {
                        _googleMapController = controller;
                        _googleMapController
                            .setMapStyle(MapStyles.mapStylesRetro);
                      },
                      markers: (markers != null) ? markers : {},
                      polylines: (polylines != null) ? polylines : {},
                    ),
                    if (distance != null)
                      Positioned(
                        top: 20.0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6.0,
                            horizontal: 12.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.yellowAccent,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 2),
                                blurRadius: 6.0,
                              )
                            ],
                          ),
                          child: Text(
                            'Jarak: ${distance} km',
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.black,
                  onPressed: () => {
                    setState(() {
                      getMarkers();
                    })
                  },
                  child: const Icon(Icons.refresh_sharp),
                ),
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

  Future<dynamic> getMarkers() async {
    final markersCollectedJson = MarkersCollector.markersCollectedToJson();
    debugPrint('testMarkersCollected: ${markersCollectedJson} ');
    final processedMarkers =
        await MarkersRepository().getMarkersData(query: markersCollectedJson);
    int i = 0;
    distance = 0;
    // for (var item in processedMarkers) {
    //   debugPrint('testFunction: ${item.lat} ');
    // }
    for (var item in processedMarkers) {
      // test.add(item.polyline);
      BitmapDescriptor bitmapDescriptor =
          await CustomMarker().createCustomMarkerBitmap("${i}", context);
      setState(() {
        markers.add(Marker(
            markerId: MarkerId(item.pointname),
            infoWindow: InfoWindow(title: item.pointname),
            icon: (item.pointname.contains("Current Location") || item.pointname.contains("Origin") || item.pointname.contains("PT.XYZ"))
                ? BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue)
                : BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
            position: LatLng(double.parse(item.lat), double.parse(item.lng))));
        polylines.add(Polyline(
            polylineId: PolylineId(item.pointname),
            color: Colors.black,
            width: 5,
            points: item != null
                ? PolylinePoints()
                    .decodePolyline(item.polyline)
                    .map((e) => LatLng(e.latitude, e.longitude))
                    .toList()
                : []));
        distance += item.distance;
      });
      i++;
    }
    return processedMarkers;
    // debugPrint('testMarkersCollected: ${markersCollectedJson} ');
  }
}
