import 'dart:convert';

import 'package:flutter/foundation.dart';

List<MarkersProcess> markersProcessFromJson(String str) => List<MarkersProcess>.from(json.decode(str).map((x) => MarkersProcess.fromJson(x)));

class MarkersProcess {
  String pointname;
  String lat;
  String lng;
  String polyline;
  double distance;

  MarkersProcess({
    @required this.pointname,
    @required this.lat,
    @required this.lng,
    @required this.polyline,
    @required this.distance,
  });

  factory MarkersProcess.fromJson(Map<String, dynamic> json) => MarkersProcess(
        pointname: json["pointname"],
        lat: json["lat"],
        lng: json["lng"],
        polyline: json["polyline"],
        distance: json["distance"].toDouble(),
      );
}
