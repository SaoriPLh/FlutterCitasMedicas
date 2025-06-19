class CitaResponse {
  final int id;
  final String fecha;
  final String hora;
  final String estado;
  final String doctorNombre;
  final String? pacienteNombre;
  final String descripcion;

  CitaResponse({
    required this.id,
    required this.fecha,
    required this.hora,
    required this.estado,
    required this.doctorNombre,
    required this.pacienteNombre,
    required this.descripcion
  });

  factory CitaResponse.fromJson(Map<String, dynamic> json) {
    return CitaResponse(
      id: json['id'],
      fecha: json['fecha'],
      hora: json['hora'],
      estado: json['estado'],
      doctorNombre: json['doctor']['nombre'],
      pacienteNombre: json['paciente']['nombre']??'',
      descripcion: json['descripcion']
    );
  }
}
