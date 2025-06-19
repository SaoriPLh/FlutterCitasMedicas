//aca haremos la plantilla para la pantalla de onboarding

import 'package:flutter/material.dart';

class Onboardingpage  extends StatelessWidget{
  //creamos los elementos que vamos a necesitar para la pantalla de onboarding

  final String imagePath;
  final String title;
  final String description;

  const Onboardingpage({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //ahora creamos la estructura de la pantalla de onboarding
    return Padding(padding: const EdgeInsets.all(40.0),
    child: Column(children: [
      Image.asset(imagePath, width: 200, height: 200,),
      SizedBox(height: 40,),
      Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),),
      SizedBox(height: 40,),
      Text(description, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 255, 255, 255)),),
    ],)
    
    );

  }


}