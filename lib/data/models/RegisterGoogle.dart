class RegistergoogleRequest {
  final String email; // Correo electrónico del usuario
  final String password;
  final String rol; // Puede ser "doctor" o "paciente"
  final String? especialidad; // Solo si es doctor
  final String? telefono; // Solo si es doctor

  RegistergoogleRequest({
    required this.email,
    required this.password,
    required this.rol,
    this.especialidad,
    this.telefono,
  });

  // Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'email': email,
      'password': password,
      'rol': rol,
    };

    // Agregar especialidad y teléfono solo si el rol es "doctor"
    if (rol == 'doctor') {
      data['especialidad'] = especialidad;
    
    }else{
      data['telefono'] = telefono;
    }

    return data;
  }
}