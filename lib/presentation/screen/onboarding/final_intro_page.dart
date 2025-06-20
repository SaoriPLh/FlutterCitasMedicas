import 'package:flutter/material.dart';
import 'package:practicas_flutter/core/app_routes.dart';

class FinalIntroPage extends StatelessWidget {
  const FinalIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Espacio para logo o imagen
            Container(
              height: 180,
              width: double.infinity,
              child: Image.asset(
                'assets/doctora.png', // Cambia por tu imagen
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 32),

            Text(
              "¡Bienvenido a MedCare!",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              "Tu salud en buenas manos. Inicia sesión o crea una cuenta para continuar.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Botón principal
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.login);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Iniciar sesión"),
              ),
            ),

            const SizedBox(height: 16),

            // Botón secundario
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.register);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue[800],
                  side: BorderSide(color: Colors.blue[800]!),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Registrarse"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
