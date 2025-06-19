import 'package:flutter/material.dart';
import 'package:practicas_flutter/data/models/CitaResponseDTO.dart';
import 'package:practicas_flutter/data/models/UsuarioResponse.dart';
import 'package:practicas_flutter/data/services/auth_service.dart';
import 'package:practicas_flutter/data/services/cita_service.dart';

class InicialScreen extends StatefulWidget {
  @override
  _InicialScreenState createState() => _InicialScreenState();
}

class _InicialScreenState extends State<InicialScreen> {
  final authService = AuthService();
  final citaService = CitaService();
  Usuarioresponse? usuario;
  List<CitaResponse> citas = [];
  bool isLoading = true;
  int? citaSeleccionadaId;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

Future<void> cargarDatos() async {
  try {
    final user = await authService.getUsuarioActual();
    print(" Usuario recibido: ${user?.nombre}, ${user?.email}");

    final userCitas = await citaService.getCitasDelUsuario();
    print("citas recibidas $userCitas");
    
    setState(() {
      usuario = user;
      citas = userCitas;
      isLoading = false;
    });
  } catch (e) {
    print(' Error al cargar datos: $e');
    setState(() {
      isLoading = false;
    });
  }
}


  Future<void> cambiarEstadoCita(int idCita, String estado) async {
    try {
      await citaService.actualizarEstadoCita(idCita, estado);
      cargarDatos();
    } catch (e) {
      print('Error al cambiar estado de la cita: $e');
    }
  }

  List<Map<String, dynamic>> obtenerAccionesPorEstado(String estado) {
    if (estado == 'PENDIENTE') {
      return [
        {'icono': Icons.check_circle_outline, 'valor': 'CONFIRMADA'},
        {'icono': Icons.cancel_outlined, 'valor': 'CANCELADA'},
      ];
    } else if (estado == 'CONFIRMADA') {
      return [
        {'icono': Icons.cancel_outlined, 'valor': 'CANCELADA'},
      ];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 245, 250),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Inicio', style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: Icon(Icons.notifications_none, color: Colors.blue[900]), onPressed: () {}),
          IconButton(icon: Icon(Icons.menu, color: Colors.blue[900]), onPressed: () {}),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    color: Colors.blue[100],
                    elevation: 4,
                    child: ListTile(
                      leading: Icon(Icons.add_circle_outline, color: Colors.blue[900], size: 36),
                      title: Text('Crear nueva cita', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900])),
                      subtitle: Text('Accede rápidamente al formulario para agendar una cita'),
                      onTap: () {
                        Navigator.pushNamed(context, '/crearCita');
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Hola, ${usuario?.nombre ?? 'Usuario'}',
                    style: const TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Estas son tus citas:',
                    style: TextStyle(color: Colors.black54, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: citas.isEmpty
                        ? const Center(child: Text('No tienes citas registradas.', style: TextStyle(color: Colors.black45)))
                        : ListView.builder(
                            itemCount: citas.length,
                            itemBuilder: (context, index) {
                              final cita = citas[index];
                              return Column(
                                children: [
                                  Card(
                                    elevation: 3,
                                    margin: const EdgeInsets.symmetric(vertical: 10),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(16),
                                      leading: Icon(Icons.calendar_today_outlined, color: Colors.blue[800]),
                                      title: Text('${cita.fecha} a las ${cita.hora}',
                                          style: const TextStyle(fontWeight: FontWeight.bold)),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 4),
                                          Text('Doctor: ${cita.doctorNombre}'),
                                          Text('Paciente: ${cita.pacienteNombre}'),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(
                                          cita.estado == 'PENDIENTE' ? Icons.access_time : Icons.check_circle_outline,
                                          color: cita.estado == 'PENDIENTE' ? Colors.orange : Colors.green,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            citaSeleccionadaId = citaSeleccionadaId == cita.id ? null : cita.id;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  if (citaSeleccionadaId == cita.id)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Row(
                                        children: obtenerAccionesPorEstado(cita.estado).map((accion) {
                                          return IconButton(
                                            icon: Icon(accion['icono'], color: Colors.blue[900]),
                                            onPressed: () {
                                              cambiarEstadoCita(cita.id, accion['valor']);
                                              setState(() {
                                                citaSeleccionadaId = null;
                                              });
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                  )
                ],
              ),
            ),
    );
  }
}
