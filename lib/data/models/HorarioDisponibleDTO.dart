class HorarioDisponibleDTO {
  final int id;
  final String fecha;
  final String hora;
  final bool ocupado;

  HorarioDisponibleDTO({
    required this.id,
    required this.fecha,
    required this.hora,
    required this.ocupado,
  });

  factory HorarioDisponibleDTO.fromJson(Map<String, dynamic> json) {
    return HorarioDisponibleDTO(
      id: json['id'],
      fecha: json['fecha'],
      hora: json['hora'],
      ocupado: json['ocupado'],
    );
  }

  DateTime get fechaDateTime => DateTime.parse(fecha); // Útil para calendarios
}
