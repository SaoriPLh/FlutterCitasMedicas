class Usuarioresponse {
  final int id;
  final String nombre;
  final String email;
  final String rol;

  Usuarioresponse({required this.nombre, required this.email, required this.rol, required this.id});

  factory Usuarioresponse.fromJson(Map<String, dynamic> json) {
    return Usuarioresponse(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? '',
      email: json['email'] ?? '',
      rol: json['rol'] ?? '',
    );
  }
}
