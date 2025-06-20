import 'package:flutter/material.dart';
import 'package:practicas_flutter/data/http/AuthRepository.dart';
import 'package:practicas_flutter/data/http/CitaRepository.dart';
import 'package:practicas_flutter/data/http/http_client.dart';
import 'package:practicas_flutter/data/models/DoctorDTO.dart';
import 'package:practicas_flutter/data/models/CitaRequest.dart';
import 'package:practicas_flutter/data/models/UsuarioResponse.dart';
import 'package:practicas_flutter/presentation/screen/horariosDisponiblesScreen.dart';
import 'package:practicas_flutter/data/services/auth_service.dart';
import 'package:practicas_flutter/data/services/doctor_service.dart';
import 'package:practicas_flutter/data/services/cita_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CrearCitaScreen extends StatefulWidget {
  const CrearCitaScreen({super.key});

  @override
  State<CrearCitaScreen> createState() => _CrearCitaScreenState();
}

class _CrearCitaScreenState extends State<CrearCitaScreen> {
  final TextEditingController _descripcionController = TextEditingController();
  final DoctorService _doctorService = DoctorService();
  final citaService = CitaService(CitaRepository(CustomHttpClient()));
   Usuarioresponse? usuario;
final authService = AuthService(
  AuthRepository(CustomHttpClient()),
);
  String? especialidadSeleccionada;
  int? idDoctorSeleccionado;
  DoctorDatosDTO? doctorSeleccionado;

  List<DoctorDatosDTO> doctores = [];
  bool isLoading = false;
  
   @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
  try {
    final user = await authService.getUsuarioActual();
    print("📦 id recibido: ${user?.id}, ${user?.email}");

 
    
    setState(() {
      usuario = user;
    
      isLoading = false;
    });
  } catch (e) {
    print(' Error al cargar datos: $e');
    setState(() {
      isLoading = false;
    });
  }
}

  final Map<String, IconData> especialidadesConIconos = {
    "Cardiología": Icons.favorite,
    "Dermatología": Icons.face,
    "Neurología": Icons.psychology,
    "Pediatría": Icons.child_care,
    "Medicina general": Icons.local_hospital,
  };

  final Map<String, Color> coloresEspecialidades = {
    "Cardiología": Colors.redAccent,
    "Dermatología": Colors.orangeAccent,
    "Neurología": Colors.purpleAccent,
    "Pediatría": Colors.lightBlueAccent,
    "Medicina general": Colors.teal,
  };

  Future<void> cargarDoctores(String especialidad) async {
    setState(() => isLoading = true);
    try {
      final resultado = await _doctorService.obtenerDoctoresPorEspecialidad(especialidad);
      setState(() {
        doctores = resultado;
        isLoading = false;
      });
    } catch (e) {
      print('Error al cargar doctores: $e');
      setState(() {
        doctores = [];
        isLoading = false;
      });
    }
  }
//vamos a navegar a la pantalla de  horarios disponibles de acuerdo al doctor 
  Future<void> navegarAHorariosDisponibles(DoctorDatosDTO doctor) async {
    //vamos a esprar el navigation pop de la otra pagina donde le pasaremos el doctor para q en la otra pagina buscar o mas q nada filtrar por los dias disponibles y horas bueno recuperar los horarios ya que popr aca no los recueoramos
    final resultado = await Navigator.push( //Esto abre esa pantalla y espera a que el usuario la cierre (cuando hace Navigator.pop(...) allá).
      context,
      MaterialPageRoute( //abrimos una pantalla 
        builder: (context) => HorariosDisponiblesScreen(doctor: doctor),
      ),
    );
//ACA ACOMODAMOS Y RECUPERAMOS LA FATA PARA QUE SI OBTENEMOS LA REPSUESTA ENTONCES PUES CONSTRUIMOS EL CITA REQUEST
    if (resultado != null) {
      final Map<String, dynamic> datos = resultado;
      final fecha = datos['fecha'];
      final hora = datos['hora'];

      print("Datos recibidos $fecha y $hora");
      final idPaciente = usuario?.id; // Guarda esto antes

      final cita = CitaRequest(
        descripcion: _descripcionController.text,
        doctorId: doctor.id,
        pacienteId: idPaciente ?? 0,
        fecha: fecha,
        hora: hora,
      );

      await citaService.crearCita(cita);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Cita registrada con éxito")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text('Crear nueva cita'),
        backgroundColor: const Color.fromARGB(255, 121, 148, 195),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("¿Cuál es tu padecimiento?", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _descripcionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Describe tu malestar',
                prefixIcon: Icon(Icons.edit, color: Colors.blueAccent),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Selecciona la especialidad", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: especialidadSeleccionada,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
              ),
              items: especialidadesConIconos.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Row(
                    children: [
                      Icon(entry.value, color: coloresEspecialidades[entry.key]),
                      const SizedBox(width: 10),
                      Text(entry.key),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    especialidadSeleccionada = value;
                    idDoctorSeleccionado = null;
                    doctorSeleccionado = null;
                  });
                  cargarDoctores(value);
                }
              },
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (doctores.isEmpty && especialidadSeleccionada != null)
              const Center(child: Text("No se encontraron doctores para esta especialidad."))
            else
              Expanded(
                child: GridView.builder(
                  itemCount: doctores.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, index) {
                    final doctor = doctores[index];
                    final seleccionado = doctor.id == idDoctorSeleccionado;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          idDoctorSeleccionado = doctor.id;
                          doctorSeleccionado = doctor;
                        });
                      },
                      child: Card(
                        color: seleccionado ? Colors.blue[50] : Colors.white,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: seleccionado ? Colors.blue : Colors.grey.shade300, width: 2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.person, size: 40, color: Colors.deepPurpleAccent),
                              const SizedBox(height: 8),
                              Text(doctor.nombre, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 4),
                              Text(doctor.email, style: TextStyle(fontSize: 12, color: Colors.grey)),
                              const Spacer(),
                              Row(
                                children: [
                                  FaIcon(FontAwesomeIcons.stethoscope, size: 16, color: Colors.blueGrey),
                                  const SizedBox(width: 4),
                                  Text(doctor.especialidad),
                                ],
                              ),
                              if (seleccionado)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () => navegarAHorariosDisponibles(doctor),
                                    child: const Text("Ver horarios disponibles"),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

 
