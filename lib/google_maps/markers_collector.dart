import 'dart:convert';

import 'package:flutter/foundation.dart';

class MarkersCollector {
  static Map<String, Map<String, String>> dataMap = {};
  static List<String> pointNameList = [];
  String fatName;
  String lat;
  String lng;

  MarkersCollector(this.fatName, this.lat, this.lng);

  void addMarkerToDataMap() {
    if (!dataMap.containsKey(fatName)) {
      final latlngMarker = {'lat': lat, 'lng': lng};
      dataMap[fatName] = latlngMarker;
      pointNameList.add(fatName);
    } else {
      debugPrint('Titik Yang Sama Tidak Diizinkan !!!');
    }
    debugPrint('testDataMap: ${dataMap.toString()} ');
  }

  static String markersCollectedToJson() {
    return jsonEncode(dataMap);
  }
}
