import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:practicas_flutter/data/models/DoctorDTO.dart';
import 'package:practicas_flutter/data/models/UsuarioResponse.dart';
import 'package:practicas_flutter/data/models/register_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/login_request.dart';

class DoctorService {
  final String baseUrl = 'http://192.168.100.13:8080/doctores';

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<DoctorDatosDTO>> obtenerDoctoresPorEspecialidad(String especialidad) async {
    final token = await getToken();

    if (token == null) {
      throw Exception('Token no encontrado');
    }

    final url = Uri.parse('$baseUrl/porEspecialidad?especialidad=$especialidad'); //recuerda que aca es asi ya q espera un requestparam okey ?

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('>>> Respuesta del backend: ${response.body}');

      final data = json.decode(response.body); //recuperamos la informacion q nos pasan y la guardamos en una lista dinamica 
      if(data is List){
         return data.map((x) => DoctorDatosDTO.fromJson(x)).toList(); //recorremos la data y la vamos convirtiendo a una lista de doctorDatosDTO 
      }else {
    throw Exception('La respuesta no es una lista de doctores');
  }
     
    } else {
      throw Exception('Error al obtener doctores: ${response.statusCode}');
    }
  }
}