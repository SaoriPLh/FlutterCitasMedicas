import 'package:flutter/material.dart';
import 'package:practicas_flutter/presentation/screen/auth/login_screen.dart';
import 'package:practicas_flutter/presentation/screen/auth/register_screen.dart';
import 'package:practicas_flutter/presentation/screen/crearCita_screen.dart';

import 'package:practicas_flutter/presentation/screen/home/inicial_screen.dart';
import 'package:practicas_flutter/presentation/screen/onboarding/Onboarging.dart';
import 'package:practicas_flutter/presentation/screen/onboarding/final_intro_page.dart';

//es una clase  donde tendremos variables estaticas donde podemos  acceder a sus atributos que sean las url de las pantallas mediante ellas

class AppRoutes {


static const String login = '/login';
  static const String register = '/register';
  static const String inicial = '/inicial';
  static const String crearCita = '/crearCita';
  static const String registroCompleto = '/registroCompleto';
  static const String home = '/home';


static Map<String, WidgetBuilder> routes = {
    login: (context) =>  LoginScreen(),
    register: (context) =>  RegisterScreen(),
    inicial: (context) =>  InicialScreen(),
    crearCita: (context) => const CrearCitaScreen(),
    registroCompleto: (context) => const FinalIntroPage(),
    home: (context) =>  OnboardingScreen(),
  };


}