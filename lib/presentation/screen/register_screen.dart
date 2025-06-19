import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:practicas_flutter/models/register_request.dart';
import 'package:practicas_flutter/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _especialidadController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();

  final AuthService authService = AuthService();
  String _selectedRol = "paciente";
  bool showPassword = false;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final request = RegisterRequest(
        nombre: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        rol: _selectedRol,
        especialidad: _selectedRol == "doctor" ? _especialidadController.text : null,
        telefono: _selectedRol == "paciente" ? _telefonoController.text : null,
      );
    
        print("$request");
      

      final success = await authService.register(request);

      if (success==null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro exitoso')),
        );
        Navigator.pushNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al registrar usuario')),
        );
      }
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
            Text('Registro', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue[900])),
            const SizedBox(height: 8),
            Text('Completa tu información para continuar.', style: TextStyle(color: Colors.grey[600])),
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
                    controller: _nameController,
                    decoration: buildInputDecoration('Nombre completo', Icons.person_outline),
                    validator: (value) => value == null || value.isEmpty ? 'Ingresa tu nombre' : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _emailController,
                    decoration: buildInputDecoration('Correo electrónico', Icons.email_outlined),
                    validator: (value) => value == null || value.isEmpty ? 'Ingresa tu correo' : null,
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),

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
                      child: const Text('Registrarse', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                onPressed: () async {
        await authService.registerWithGoogle(context); // Llamamos a la función asincrónica correctamente
      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Registrarse con Google',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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