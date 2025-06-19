class RegisterRequest {
  final String nombre;
  final String email;
  final String password;
  final String rol; // Puede ser "doctor" o "paciente"
  final String? especialidad; // Solo si es doctor
  final String? telefono; // Solo si es doctor

  RegisterRequest({
    required this.nombre,
    required this.email,
    required this.password,
    required this.rol,
    this.especialidad,
    this.telefono,
  });

  // Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'nombre':nombre,
      'email': email,
      'password': password,
      'rol': rol,
    };

    // Agregar especialidad y teléfono solo si el rol es "doctor"
    if (rol == 'doctor') {
      data['especialidad'] = especialidad;
      data['telefono'] = telefono;
    }

    return data;
  }
}