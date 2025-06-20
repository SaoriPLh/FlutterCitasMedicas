
import 'package:http/http.dart' as http;
import 'package:practicas_flutter/data/models/login_request.dart';



class CustomHttpClient {

   //definimos la base url que usaremos para todo
   final String baseUrl = 'http://192.168.100.13:8080/auth';

    final http.Client _client = http.Client();

   Future<http.Response> get(String endpoint, {Map<String, String>? headers}) {
    return _client.get(Uri.parse(baseUrl + endpoint), headers: _mergeHeaders(headers));
  }

 Future<http.Response> post(String endpoint, {Map<String, String>? headers, Object? body}) {
  return _client.post(
    Uri.parse(baseUrl + endpoint),
    headers: _mergeHeaders(headers),
    body: body,
  );
}


  Map<String, String> _mergeHeaders(Map<String, String>? extraHeaders) {
    return {
      'Content-Type': 'application/json',
      ...?extraHeaders,
    };
  }

  void close() {
    _client.close();
  }




}
