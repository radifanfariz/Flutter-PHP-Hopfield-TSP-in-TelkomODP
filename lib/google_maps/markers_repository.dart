import 'dart:io';

import 'package:hopfield_tsp_app/google_maps/http_service.dart';
import 'package:hopfield_tsp_app/google_maps/markers_process.dart';

class MarkersRepository {
  Future<List<MarkersProcess>> getMarkersData({String query}) async {
    try {
      final response = await HttpService.getRequest(reqJson: query);

      if (response.statusCode == 200) {
        final result = markersProcessFromJson(response.body);
        return result;
      } else {
        // return null;
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
