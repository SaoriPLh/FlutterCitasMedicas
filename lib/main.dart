import 'package:flutter/material.dart';
import 'package:practicas_flutter/screen/Onboarging.dart';
import 'package:practicas_flutter/screen/crearCita_screen.dart';
import 'package:practicas_flutter/screen/ingresarDatosFinales.dart';
import 'package:practicas_flutter/screen/inicial_screen.dart';
import 'package:practicas_flutter/screen/login_screen.dart';
import 'package:practicas_flutter/screen/register_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
    fontFamily: 'Poppins', // <-  globalmente
  ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/home', // Ruta inicial
      routes: {
        '/home': (context) => OnboardingScreen(),
        '/login': (context) => LoginScreen(),
        '/inicial': (context) => InicialScreen(),
        '/register': (context)=> RegisterScreen(),
        '/crearCita':(context)=>CrearCitaScreen(),
         '/registroCompleto':(context)=>DatosFinales() // Ruta para HomeScreen
      },
    );
  }
}