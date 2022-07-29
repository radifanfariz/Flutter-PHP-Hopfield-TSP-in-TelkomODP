import 'dart:io';

import 'package:hopfield_tsp_app/google_maps/fat_markers_process.dart';

import 'http_service.dart';

class FatMarkersRepository{
  Future<List<FatMarkersProcess>> getFatMarkersData({String query}) async {
    try {
      final response = await HttpService.getRequestFat();

      if (response.statusCode == 200) {
        final result = fatMarkersFromJson(response.body);
        return result;
      } else {
        return null;
      }
    } on SocketException catch (e) {
      throw e;
    } on HttpException catch (e) {
      throw e;
    } on FormatException catch (e) {
      throw e;
    }
  }
}