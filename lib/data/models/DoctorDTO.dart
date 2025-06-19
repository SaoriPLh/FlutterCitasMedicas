import 'HorarioDisponibleDTO.dart';

class DoctorDatosDTO {
  final int id;
  final String nombre;
  final String email;
  final String especialidad;
  final List<HorarioDisponibleDTO> horariosDisponibles;

  DoctorDatosDTO({
    required this.id,
    required this.nombre,
    required this.email,
    required this.especialidad,
    required this.horariosDisponibles,
  });

  factory DoctorDatosDTO.fromJson(Map<String, dynamic> json) {
    return DoctorDatosDTO(
      id: json['id'],
      nombre: json['nombre'],
      email: json['email'],
      especialidad: json['especialidad'],
      horariosDisponibles: (json['horariosDisponibles'] as List)
          .map((item) => HorarioDisponibleDTO.fromJson(item))
          .toList(),
    );
  }
}
