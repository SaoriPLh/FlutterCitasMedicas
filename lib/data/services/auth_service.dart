import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:practicas_flutter/data/models/RegisterGoogle.dart';
import 'package:practicas_flutter/data/models/UsuarioResponse.dart';
import 'package:practicas_flutter/data/models/register_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../models/login_request.dart';
import 'package:flutter/services.dart';


/// Servicio de autenticación para manejar las solicitudes relacionadas con el login.
class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
    'email',
    'https://www.googleapis.com/auth/userinfo.profile',
  ],
  serverClientId: '543444956020-0iuqm441m2q0biusgqc7jeiaa0ic20p8.apps.googleusercontent.com',
  );
  
  String? emailAutenticado; // Variable para almacenar el email autenticado
  /// URL base de la API.
  final String baseUrl = 'http://192.168.100.13:8080/auth';

  // Método para enviar el token al backend para validación.
  Future<void> sendTokenToBackend(String idToken, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/validate-token-register'), // URL del endpoint en tu backend
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id_token': idToken}), // Enviar el id_token al backend
      );

      if (response.statusCode == 200) {
        print('Token validado exitosamente');

        final data = jsonDecode(response.body);
        final token = data['token'];
        final prefs = await SharedPreferences.getInstance(); // aca se obtiene la instancia de SharedPreferences 
        await prefs.setString('token', token); // aca se guarda el token en SharedPreferences con la clave 'token'
  

  
        // Si la validación fue exitosa, navega a otra página
        Navigator.pushReplacementNamed(context, '/inicial'); // Cambia '/home' por la ruta que desees


      } else {
        print('Error al validar el token');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al validar el token')),
        );
      }
    } catch (error) {
      print('Error al enviar el token al backend: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión con el servidor')),
      );
    }
  }

  // Método para registrar el usuario con Google
  Future<void> sendTokenToBackendRegister(String idToken, String? email, BuildContext context) async {
    try {
      final response = await http.post( //objeto de tipo http response que continee headers body y status code
        Uri.parse('$baseUrl/validate-token-register'), // URL del endpoint en tu backend
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id_token': idToken}), // Enviar el id_token al backend
      );

      if (response.statusCode == 200) {
        print('Token validado exitosamente');

        final data = jsonDecode(response.body);
        final token = data['token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        // Si la validación fue exitosa, navega a otra página
     Navigator.pushReplacementNamed(
            context,
            '/registroCompleto',
            arguments: email, 
    );

      } else {
        print('Error al validar el token');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al validar el token')),
        );
      }
    } catch (error) {
      print('Error al enviar el token al backend: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión con el servidor')),
      );
    }
  }

  // Método para iniciar sesión con Google
// Método para iniciar sesión con Google
Future<void> SignInGoogle(BuildContext context) async {
  print('👉 [Google Sign-In] Iniciando proceso de autenticación...');
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    print(' [Google Sign-In] Usuario seleccionado: $googleUser');

    if (googleUser == null) {
      print(' [Google Sign-In] El usuario canceló el inicio de sesión o no seleccionó cuenta.');
      return;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    print(' [Google Sign-In] Autenticación obtenida.');

    final idToken = googleAuth.idToken;

    if (idToken != null) {
      print('✅ [Google Sign-In] ID Token obtenido: $idToken');
      await sendTokenToBackend(idToken, context);
    } else {
      print(' [Google Sign-In] No se obtuvo el ID Token.');
    }
  } catch (error) {
    print(' [Google Sign-In] Error al iniciar sesión con Google: $error');
    if (error is PlatformException) {
      print(' Código del error: ${error.code}');
      print(' Detalles del error: ${error.details}');
    }
  }
}

// Método para registrar un nuevo usuario con Google
Future<void> registerWithGoogle(BuildContext context) async {
  
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  

    if (googleUser == null) {

      return;
    }

  if (googleUser != null) {
    emailAutenticado = googleUser.email; 
  }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
   

    final idToken = googleAuth.idToken;

    if (idToken != null) {
      print('✅ [Google Register] ID Token: $idToken');
      await sendTokenToBackendRegister(idToken, emailAutenticado,context);
    } else {
      print(' [Google Register] No se obtuvo el ID Token.');
    }
  } catch (error) {
    print(' [Google Register] Error al registrar con Google: $error');
    print(' Detalles del error: ${error.toString()}');
    if (error is PlatformException) {
      print(' Código del error: ${error.code}');
      print(' Detalles del error: ${error.details}');
    }
  }
}


  // Método para completar el registro del usuario
  Future<void> completeRegistration(RegistergoogleRequest registerGoogle, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/llenarDatosRegisterPostGoogle'), // Endpoint en tu backend
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(registerGoogle.toJson()), // Enviar los datos de registro al backend
      );

      if (response.statusCode == 200) {
        print('Registro completado con éxito');

        // Si el registro fue exitoso, navega a la pantalla inicial
        Navigator.pushReplacementNamed(context, '/inicial'); // Cambia '/home' por la ruta que desees
      } else {
        print('Error al completar el registro');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al completar el registro')),
        );
      }
    } catch (error) {
      print('Error al enviar los datos de registro: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión con el servidor')),
      );
    }
  }

  // Método para iniciar sesión.
  Future<String?> login(LoginRequest request) async {
    final url = Uri.parse('$baseUrl/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()), // Convertimos el objeto a JSON.
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      return null; // Login exitoso.
    } else {  
      final data = jsonDecode(response.body);
      print('Error: ${response.statusCode}');
      return data['mensajeError'] ?? 'Error desconocido'; // Login fallido.
    }
  }

  // Método para registrar un nuevo usuario
  Future<String?> register(RegisterRequest request) async {
    final url = Uri.parse('$baseUrl/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()), // Convertimos el objeto a JSON.
    );

    if (response.statusCode == 200) {
      return null; // Registro exitoso.
    } else {
      final data = jsonDecode(response.body);
      print('Error: ${response.statusCode}');
      return data['mensajeError'] ?? 'Error al registrar usuario'; // Registro fallido.
    }
  }

  // Método para obtener los datos del usuario logueado
  Future<Usuarioresponse?> getUsuarioActual() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      final url = Uri.parse('$baseUrl/me');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        return Usuarioresponse.fromJson(jsonDecode(response.body));
      } else {
        print('Error al obtener usuario: ${response.statusCode}');
        return null;
      }
    } else {
      print('Token no encontrado');
      return null;
    }
  }
}
