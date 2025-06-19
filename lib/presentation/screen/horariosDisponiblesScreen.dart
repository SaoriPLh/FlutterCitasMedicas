import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:practicas_flutter/models/DoctorDTO.dart';

class HorariosDisponiblesScreen extends StatefulWidget {
  final DoctorDatosDTO doctor;

  const HorariosDisponiblesScreen({super.key, required this.doctor});

  @override
  State<HorariosDisponiblesScreen> createState() => _HorariosDisponiblesScreenState();
}

class _HorariosDisponiblesScreenState extends State<HorariosDisponiblesScreen> {
  bool verSemana = true;
  DateTime hoy = DateTime.now();
  DateTime diaSeleccionado = DateTime.now();
  String? horaSeleccionada;

  List<DateTime> diasDeLaSemana = [];

  @override
  void initState() {
    super.initState();
    generarSemana();
  }

  void generarSemana() {
    final inicioSemana = hoy.subtract(Duration(days: hoy.weekday - 1));
    diasDeLaSemana = List.generate(7, (i) => inicioSemana.add(Duration(days: i)));
  }

  List<Map<String, dynamic>> obtenerHorariosParaDia(DateTime dia) {
    return widget.doctor.horariosDisponibles  //aca vamos a filtrar los horarios q no estan ocupados
        .where((h) =>
            !h.ocupado &&  //y 
            DateFormat('yyyy-MM-dd').format(DateTime.parse(h.fecha)) ==
                DateFormat('yyyy-MM-dd').format(dia))
        .map((h) => {"hora": h.hora, "id": h.id})
        .toList();
  }

  void confirmarSeleccion() {
    if (horaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Selecciona una hora primero")));
      return;
    }

    Navigator.pop(context, {
      "fecha": DateFormat('yyyy-MM-dd').format(diaSeleccionado),
      "hora": horaSeleccionada,
    });
  }

  @override
  Widget build(BuildContext context) {
    final horarios = obtenerHorariosParaDia(diaSeleccionado);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: Text('Horarios de ${widget.doctor.nombre}'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: confirmarSeleccion,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text("Esta semana"),
                  selected: verSemana,
                  onSelected: (_) => setState(() => verSemana = true),
                ),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: const Text("Este mes"),
                  selected: !verSemana,
                  onSelected: (_) => setState(() => verSemana = false),
                ),
              ],
            ),
            const SizedBox(height: 20),
            verSemana ? _buildSemana(horarios) : _buildMes(horarios),
          ],
        ),
      ),
    );
  }

  Widget _buildSemana(List<Map<String, dynamic>> horarios) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: diasDeLaSemana.map((dia) {
            final esSeleccionado = DateFormat('yyyy-MM-dd').format(dia) ==
                DateFormat('yyyy-MM-dd').format(diaSeleccionado);
            return GestureDetector(
              onTap: () => setState(() => diaSeleccionado = dia),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: esSeleccionado ? Colors.blue : Colors.grey[300],
                child: Text(
                  DateFormat('E').format(dia).substring(0, 1),
                  style: TextStyle(color: esSeleccionado ? Colors.white : Colors.black),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        const Text("Horarios disponibles (verde: disponibles)", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        horarios.isEmpty
            ? const Text("No hay horarios disponibles para este día.")
            : Wrap(
                spacing: 10,
                children: horarios.map((h) {
                  final seleccionado = h["hora"] == horaSeleccionada;
                  return ChoiceChip(
                    label: Text(h["hora"]),
                    selected: seleccionado,
                    onSelected: (_) => setState(() => horaSeleccionada = h["hora"]),
                    selectedColor: Colors.green,
                    labelStyle: TextStyle(color: seleccionado ? Colors.white : Colors.black),
                  );
                }).toList(),
              ),
      ],
    );
  }

  Widget _buildMes(List<Map<String, dynamic>> horarios) {
    final fechasDisponibles = widget.doctor.horariosDisponibles
        .where((h) => !h.ocupado)
        .map((h) => DateTime.parse(h.fecha))
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TableCalendar(
          focusedDay: hoy,
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          selectedDayPredicate: (day) => isSameDay(day, diaSeleccionado),
          calendarStyle: const CalendarStyle(
            todayDecoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
            selectedDecoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
          ),
          onDaySelected: (selected, _) => setState(() => diaSeleccionado = selected),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, _) {
              final dia = DateTime(date.year, date.month, date.day);
              if (fechasDisponibles.contains(dia)) {
                return const Positioned(
                  bottom: 4,
                  child: Icon(Icons.check_circle, color: Colors.green, size: 16),
                );
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 20),
        const Text("Horarios disponibles (verde: disponibles)", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        horarios.isEmpty
            ? const Text("No hay horarios disponibles para este día.")
            : Wrap(
                spacing: 10,
                children: horarios.map((h) {
                  final seleccionado = h["hora"] == horaSeleccionada;
                  return ChoiceChip(
                    label: Text(h["hora"]),
                    selected: seleccionado,
                    onSelected: (_) => setState(() => horaSeleccionada = h["hora"]),
                    selectedColor: Colors.green,
                    labelStyle: TextStyle(color: seleccionado ? Colors.white : Colors.black),
                  );
                }).toList(),
              ),
      ],
    );
  }
}
