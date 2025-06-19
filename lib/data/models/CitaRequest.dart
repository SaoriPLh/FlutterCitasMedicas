class CitaRequest {
  final int doctorId;
  final int pacienteId;
  final String fecha; // Formato: yyyy-MM-dd
  final String hora;  // Formato: HH:mm
  final String descripcion;

  CitaRequest({
    required this.doctorId,
    required this.pacienteId,
    required this.fecha,
    required this.hora,
    required this.descripcion,
  });

  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'pacienteId': pacienteId,
      'fecha': fecha,
      'hora': hora,
      'descripcion': descripcion,
    };
  }
}
