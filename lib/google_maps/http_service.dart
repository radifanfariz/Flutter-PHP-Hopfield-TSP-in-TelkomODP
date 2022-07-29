import 'package:http/http.dart' as http;

class HttpService {
  static final baseUrl = "http://192.168.100.40/hopfield_tsp/";
  static Future<http.Response> getRequest({reqJson}) async {
    http.Response response;
    try {
      final url = Uri.parse(baseUrl + "hopfieldtspApi.php");
      response = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: reqJson);
    } on Exception catch (e) {
      throw e;
    }
    return response;
  }

  static Future<http.Response> getRequestFat({String limit}) async {
    http.Response response;
    try {
      final url = Uri.parse(baseUrl + "markersApiMedan.php");
      response = await http.get(url);
    } on Exception catch (e) {
      throw e;
    }
    return response;
  }
}
