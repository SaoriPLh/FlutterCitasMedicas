import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:practicas_flutter/models/CitaRequest.dart';
import 'package:practicas_flutter/models/CitaResponseDTO.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CitaService{
  //definimos la url base 
  final String baseUrl = 'http://192.168.100.13:8080/citas';

  //empezamos con los metodos por ejemplo recuperar las citas de un doctor para eso lo primero q haremos sera enviar una solicitud get 

  //pero antes primero debemos obtener el token de autenticacion que tenemos guardado en shared preferences  
  //y antes d eso debemos crear un metodo para obtener el token de shared preferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }



  //metodo para obtener las citas del usuario logueado

 Future<List<CitaResponse>> getCitasDelUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token no encontrado');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/usuario/citas'), // tu endpoint tipo /citas/mias
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Decodificamos la respuesta JSON
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => CitaResponse.fromJson(json)).toList();
    } else {
      print('Error al obtener citas: ${response.statusCode}');
      throw Exception('Error al obtener citas');
    }
  }

  //metodo para actualizar el estado de una cita 
  Future<bool>actualizarEstadoCita(int idCita, String estado) async{

    //el id de la cita lo podemos obtener de la lista de citas que tenemos en el metodo anterior
    //obtenemos el token de autenticacion
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('Token no encontrado');
    }

     final url = Uri.parse('$baseUrl/actualizarEstado?id=$idCita&nuevoEstado=$estado');

    final response = await http.post(url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
     
    );

    if (response.statusCode == 200) {
      return true; // Actualización exitosa
    } else {
      
       print('Error al actualizar estado de cita: ${response.statusCode}');
  print('Respuesta del servidor: ${response.body}');
  return false;
      return false; // Error en la actualización
    }
  }

  Future<bool> crearCita(CitaRequest request) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Token no disponible');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/reservar'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(request.toJson()),
    );

    return response.statusCode == 200;
  }
}