import 'dart:convert';


import 'package:practicas_flutter/data/http/http_client.dart';
import 'package:practicas_flutter/data/models/RegisterGoogle.dart';
import 'package:practicas_flutter/data/models/login_request.dart';
import 'package:http/http.dart' as http;
import 'package:practicas_flutter/data/models/register_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  //nuestro cliente para hacer las solicitudes
  final CustomHttpClient _client;

  //aca falta declarar la ruta base para concatenarla con cada metodo

  final String baseUrl = '/auth';

  AuthRepository(this._client);

  Future<http.Response> login(LoginRequest request) {
    return _client.post(
      "$baseUrl/login",
      body: jsonEncode(request.toJson()),
    );
  }

  Future<http.Response> register(RegisterRequest request ){

    return _client.post("$baseUrl/register",body: jsonEncode(request.toJson())); //aca primero nuestro objeto lo pasamos como mapString y luego este en JSON con  jsonEncode
  }

  Future<http.Response> validateGoogleToken(String idToken) {
  return _client.post(
    "$baseUrl/validate-token-register",
    body: jsonEncode({"id_token": idToken}),
  );
}

 // asegúrate de importar

Future<http.Response> completeGoogleRegistration(RegistergoogleRequest request) {
  return _client.post(
    "$baseUrl/llenarDatosRegisterPostGoogle",
    body: jsonEncode(request.toJson()),
  );
}
Future<String?> validateGoogleLoginToken(String idToken) async {
  final response = await _client.post(
    "$baseUrl/validate-token-register",
    body: jsonEncode({"id_token": idToken}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final token = data['token'];

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);

    return null; // OK
  } else {
    final data = jsonDecode(response.body);
    return data['mensajeError'] ?? 'Error al validar el token';
  }
}

Future<http.Response> getUsuarioActual() async {
  //asincrono porque vamos a hacer algo con ese resultado de await
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token == null) {
    throw Exception("Token no encontrado");
  }

  return _client.get(
    "$baseUrl/me",
    headers: {
      'Authorization': 'Bearer $token',
    },
  );
}




}
