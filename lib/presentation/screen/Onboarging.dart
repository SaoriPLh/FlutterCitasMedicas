import 'package:flutter/material.dart';
import 'package:practicas_flutter/screen/OnboardingPage.dart';
import 'package:practicas_flutter/screen/final_intro_page.dart';
import 'package:practicas_flutter/screen/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>{
//creamos el controlador para el pageview que nos sirve para cambiar de pagina
final  PageController _pageController = PageController();

//creamos un current index para saber en que pagina estamos
int _currentIndex = 0;

//creamos una lista de widgets para las pantallas de onboarding
final List<Widget> _screens = [
   Onboardingpage(
      imagePath: "assets/pngwing.com.png",
      title: 'Bienvenido',
      description: 'Descubre nuevas funciones en nuestra app.',
    ),
    Onboardingpage(
        imagePath: "assets/doctora.png",
        title: 'Ahorra tiempo',
        description: 'Agenda tus citas medicas de manera rapida y sencilla.',
      ),
    FinalIntroPage()
];
      
         @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color.fromARGB(255, 14, 16, 33),
    body: Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _screens.length,
                onPageChanged: (int index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (_, index) => _screens[index],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _screens.length,
                (index) => buildDot(index, context),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),

        // Botón "Saltar" flotante (arriba a la derecha)
        if (_currentIndex < _screens.length - 1)
          Positioned(
            top: 50,
            right: 24,
            child: TextButton(
              onPressed: () {
                _pageController.jumpToPage(_screens.length - 1);
              },
              child: const Text(
                "Saltar",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
  
    //metodo para crear los puntos de la parte inferior de la pantalla
    Widget buildDot(int index, BuildContext context) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        height: 10,
        width: _currentIndex == index ? 25 : 10,
        decoration: BoxDecoration(
          color: _currentIndex == index ? Colors.white : Colors.grey,
          borderRadius: BorderRadius.circular(12),
        ),
      );
    }


}