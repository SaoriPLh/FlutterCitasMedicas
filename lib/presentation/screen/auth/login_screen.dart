import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:practicas_flutter/data/http/AuthRepository.dart';
import 'package:practicas_flutter/data/http/http_client.dart';
import 'package:practicas_flutter/data/models/login_request.dart';
import 'package:practicas_flutter/data/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool showPassword = false;
  final authService = AuthService(
  AuthRepository(CustomHttpClient()),
);

  

  void iniciarSesion() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final loginRequest = LoginRequest(email: email, password: password);
   
    
    final response = await authService.login(loginRequest);

    if (response==null) {
      Navigator.pushReplacementNamed(context, '/inicial');
    } else if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, completa todos los campos')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email o contraseña incorrectos')),
      );
    }
  }

  InputDecoration buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey[100],
    body: SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/doctora.png', height: 130),
          const SizedBox(height: 20),
          FadeInDown(
            duration: Duration(milliseconds: 800),
            child: Text(
              "Iniciar Sesión",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
          ),
          const SizedBox(height: 8),
          FadeInDown(
            duration: Duration(milliseconds: 1000),
            child: Text(
              "Bienvenido de nuevo",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 40),
          FadeInUp(
            duration: Duration(milliseconds: 1200),
            child: TextField(
              controller: _emailController,
              decoration: buildInputDecoration('Correo electrónico', Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 20),
          FadeInUp(
            duration: Duration(milliseconds: 1300),
            child: TextField(
              controller: _passwordController,
              obscureText: !showPassword,
              decoration: InputDecoration(
                hintText: 'Contraseña',
                prefixIcon: Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => showPassword = !showPassword),
                ),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          FadeInUp(
            duration: Duration(milliseconds: 1500),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: iniciarSesion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Entrar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          FadeInUp(
            duration: Duration(milliseconds: 1600),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
        await authService.signInGoogle(context); // Llamamos a la función asincrónica correctamente
      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Iniciar sesión con Google',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}