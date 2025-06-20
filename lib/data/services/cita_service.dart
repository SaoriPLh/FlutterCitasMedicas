import 'dart:convert';
import 'package:practicas_flutter/data/http/CitaRepository.dart';
import 'package:practicas_flutter/data/models/CitaRequest.dart';
import 'package:practicas_flutter/data/models/CitaResponseDTO.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CitaService {
  final CitaRepository citaRepository;

  CitaService(this.citaRepository);

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<CitaResponse>> getCitasDelUsuario() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token no encontrado');
    }

    final response = await citaRepository.getCitasDelUsuario(token);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => CitaResponse.fromJson(json)).toList();
    } else {
      print('Error al obtener citas: ${response.statusCode}');
      throw Exception('Error al obtener citas');
    }
  }

  Future<bool> actualizarEstadoCita(int idCita, String estado) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token no encontrado');
    }

    final response = await citaRepository.actualizarEstadoCita(idCita, estado,token);

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error al actualizar estado de cita: ${response.statusCode}');
      print('Respuesta del servidor: ${response.body}');
      return false;
    }
  }

  Future<bool> crearCita(CitaRequest request) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token no disponible');
    }

    final response = await citaRepository.crearCita(request, token);

    return response.statusCode == 200;
  }
}
