import 'dart:convert';

List<FatMarkersProcess> fatMarkersFromJson(String str) =>
    List<FatMarkersProcess>.from(
        json.decode(str).map((x) => FatMarkersProcess.fromJson(x)));

class FatMarkersProcess {
  FatMarkersProcess({
    this.fatName,
    this.latitude,
    this.longitude,
  });

  String fatName;
  String latitude;
  String longitude;

  factory FatMarkersProcess.fromJson(Map<String, dynamic> json) =>
      FatMarkersProcess(
        fatName: json["fat_name"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );
}
