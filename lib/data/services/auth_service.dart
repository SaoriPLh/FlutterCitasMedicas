import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:practicas_flutter/core/app_routes.dart';
import 'package:practicas_flutter/data/http/AuthRepository.dart';
import 'package:practicas_flutter/data/models/RegisterGoogle.dart';
import 'package:practicas_flutter/data/models/UsuarioResponse.dart';
import 'package:practicas_flutter/data/models/register_request.dart';
import 'package:practicas_flutter/data/models/login_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'https://www.googleapis.com/auth/userinfo.profile'],
    serverClientId: '543444956020-0iuqm441m2q0biusgqc7jeiaa0ic20p8.apps.googleusercontent.com',
  );

  final AuthRepository authRepository;
  String? emailAutenticado;

  AuthService(this.authRepository);

 
  Future<String?> login(LoginRequest request) async {
    final Response response = await authRepository.login(request);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      return null;
    } else {
      final data = jsonDecode(response.body);
      return data['mensajeError'] ?? 'Error al iniciar sesión';
    }
  }

 
  Future<String?> register(RegisterRequest request) async {
    final response = await authRepository.register(request);
    if (response.statusCode == 200) {
      return null;
    } else {
      final data = jsonDecode(response.body);
      return data['mensajeError'] ?? 'Error al registrar';
    }
  }


  Future<Usuarioresponse?> getUsuarioActual() async {
    final response = await authRepository.getUsuarioActual();
    if (response.statusCode == 200) {
      return Usuarioresponse.fromJson(jsonDecode(response.body));
    } else {
      print('Error al obtener usuario: ${response.statusCode}');
      return null;
    }
  }


  Future<void> completeRegistration(RegistergoogleRequest request, BuildContext context) async {
    final response = await authRepository.completeGoogleRegistration(request);
    if (response.statusCode == 200) {
      Navigator.pushReplacementNamed(context, AppRoutes.inicial);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al completar el registro')),
      );
    }
  }

  // 🔐 Login con Google
  Future<void> signInGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken != null) {
        await sendTokenToBackend(idToken, context);
      } else {
        print('No se obtuvo el ID Token');
      }
    } catch (error) {
      print('Error Google Sign-In: $error');
      if (error is PlatformException) {
        print('Código: ${error.code}');
        print('Detalles: ${error.details}');
      }
    }
  }

  // 📝 Registro con Google
  Future<void> registerWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      emailAutenticado = googleUser.email;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken != null) {
        await sendTokenToBackendRegister(idToken, emailAutenticado, context);
      }
    } catch (error) {
      print('Error Google Register: $error');
    }
  }

  // 🔄 Validar token con backend (Google Login)
  Future<void> sendTokenToBackend(String idToken, BuildContext context) async {
    final response = await authRepository.validateGoogleToken(idToken);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      Navigator.pushReplacementNamed(context, '/inicial');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al validar el token')),
      );
    }
  }

  // 🔄 Validar token con backend (Google Register)
  Future<void> sendTokenToBackendRegister(String idToken, String? email, BuildContext context) async {
    final response = await authRepository.validateGoogleToken(idToken);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      Navigator.pushReplacementNamed(context, '/registroCompleto', arguments: email);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al validar el token')),
      );
    }
  }

  // 🔓 Cerrar sesión (opcional)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await _googleSignIn.signOut();
    print("Sesión cerrada");
  }
}
