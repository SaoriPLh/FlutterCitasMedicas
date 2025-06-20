//pantalla que le aparecera al usuario despues de registrarse con su gmail donde este sera un ingreso de sus demas datos 

import 'package:flutter/material.dart';
import 'package:practicas_flutter/data/http/AuthRepository.dart';
import 'package:practicas_flutter/data/http/http_client.dart';
import 'package:practicas_flutter/data/models/RegisterGoogle.dart';
import 'package:practicas_flutter/data/models/register_request.dart';
import 'package:practicas_flutter/data/services/auth_service.dart';

class DatosFinales extends StatefulWidget {

  @override
  _DatosFinalesState createState() => _DatosFinalesState();
  
  }

  class _DatosFinalesState extends State<DatosFinales>{
     final _formKey = GlobalKey<FormState>();
  bool showPassword = false; // Variable para mostrar/ocultar la contraseña
final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _especialidadController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
    String _selectedRol = "paciente";
  

final authService = AuthService(
  AuthRepository(CustomHttpClient()),
);
 // Instancia del servicio de autenticación
  late String email;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        email = ModalRoute.of(context)!.settings.arguments as String;
      });
    });
  }
  //metodo register donde guardaremos los datos que el usuario ingrese en la pantalla de registro al dto 
Future<void> _register() async {
    if (_formKey.currentState!.validate()) {  // aca validamos el formulario con el metodo validate que se encarga de validar los campos
    final request = RegistergoogleRequest(
        email: email,
        password: _passwordController.text,
        rol: _selectedRol,
        especialidad: _selectedRol == "doctor" ? _especialidadController.text : null,
        telefono: _selectedRol == "paciente" ? _telefonoController.text : null,
      );
      authService.completeRegistration(request, context);
         
    }
  }




  InputDecoration buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon),
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
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
      body: SingleChildScrollView( // Permite el desplazamiento si el teclado aparece
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
        child: Column(
          children: [
            Image.asset('assets/doctora.png', height: 140),
            const SizedBox(height: 16),
            
            Text('Antes Completa tu Perfil', style: TextStyle(fontSize: 34, color: Colors.grey[600])),
            const SizedBox(height: 32),

            // Selector de rol
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: Text("Paciente"),
                  selected: _selectedRol == "paciente",
                  onSelected: (_) => setState(() => _selectedRol = "paciente"),
                  selectedColor: Colors.blue[100],
                  labelStyle: TextStyle(color: _selectedRol == "paciente" ? Colors.blue[900] : Colors.black),
                ),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: Text("Doctor"),
                  selected: _selectedRol == "doctor",
                  onSelected: (_) => setState(() => _selectedRol = "doctor"),
                  selectedColor: Colors.blue[100],
                  labelStyle: TextStyle(color: _selectedRol == "doctor" ? Colors.blue[900] : Colors.black),
                ),
              ],
            ),

            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
              TextFormField(
                    controller: _passwordController,
                    obscureText: !showPassword,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => showPassword = !showPassword),
                      ),
                      hintText: 'Contraseña',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) => value == null || value.length < 6 ? 'Mínimo 6 caracteres' : null,
                  ),

                  if (_selectedRol == 'doctor') ...[
                    TextFormField(
                      controller: _especialidadController,
                      decoration: buildInputDecoration('Especialidad médica', Icons.medical_services_outlined),
                      validator: (value) => value == null || value.isEmpty ? 'Ingresa tu especialidad' : null,
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (_selectedRol == 'paciente') ...[
                    TextFormField(
                      controller: _telefonoController,
                      keyboardType: TextInputType.phone,
                      decoration: buildInputDecoration('Teléfono de contacto', Icons.phone),
                      validator: (value) => value == null || value.isEmpty ? 'Ingresa tu teléfono' : null,
                    ),
                    const SizedBox(height: 16),
                  ],

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Hecho', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
    
                
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  }