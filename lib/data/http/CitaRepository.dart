import 'dart:convert';
import 'package:practicas_flutter/data/http/http_client.dart';
import 'package:practicas_flutter/data/models/CitaRequest.dart';
import 'package:http/http.dart' as http;

class CitaRepository {
  final CustomHttpClient _client;
  final String baseUrl = '/citas';

  CitaRepository(this._client);

  Future<http.Response> getCitasDelUsuario(String token) {
    return _client.get(
      '$baseUrl/usuario/citas',
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.Response> actualizarEstadoCita(int idCita, String estado, String token) {
    final endpoint = '$baseUrl/actualizarEstado?id=$idCita&nuevoEstado=$estado';
    return _client.post(
      endpoint,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.Response> crearCita(CitaRequest request, String token) {
    return _client.post(
      '$baseUrl/reservar',
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request.toJson()),
    );
  }
}
