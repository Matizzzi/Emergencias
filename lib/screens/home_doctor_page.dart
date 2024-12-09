import 'package:flutter/material.dart';

class HomeDoctorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenido, Doctor"),
        backgroundColor: Colors.blue[700],
      ),
      body: Container(
        // Fondo con gradiente que cubre toda la pantalla
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[800]!, Colors.blue[300]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SizedBox.expand( // Esto asegura que el fondo cubra todo el espacio
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bienvenida al Doctor
                  Text(
                    "Bienvenido, Dr. Juan Pérez", // Aquí puedes poner el nombre del doctor
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Especialización
                  Text(
                    "Especialización: Cardiología", // Especialización del doctor
                    style: TextStyle(fontSize: 20, color: Colors.white70),
                  ),
                  SizedBox(height: 20),
                  // Correo
                  Text(
                    "Correo: juanperez@example.com", // Correo del doctor
                    style: TextStyle(fontSize: 20, color: Colors.white70),
                  ),
                  SizedBox(height: 40),
                  // Sección de Pacientes
                  _buildSectionTitle("Pacientes"),
                  _buildCard(
                    title: "Lista de Pacientes",
                    onTap: () {
                      // Acción para ver lista de pacientes
                    },
                  ),
                  SizedBox(height: 20),
                  // Sección de Consultas Terminadas
                  _buildSectionTitle("Consultas Terminadas"),
                  _buildCard(
                    title: "Ver Consultas Terminadas",
                    onTap: () {
                      // Acción para ver consultas terminadas
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Título de sección con un estilo atractivo
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  // Card personalizada con estilo para las acciones de cada sección
  Widget _buildCard({required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        color: Colors.blueGrey[700],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.blueAccent, size: 30),
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
