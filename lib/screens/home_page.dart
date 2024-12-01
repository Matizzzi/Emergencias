import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required String userName}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  // Cargar el nombre del usuario desde Firestore
  Future<void> _loadUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String name = await getUserName(user.uid);
      setState(() {
        userName = name;
      });
    }
  }

  // Método para obtener el nombre del usuario desde Firestore
  Future<String> getUserName(String uid) async {
    try {
      // Obtén el documento del usuario en Firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      
      // Verifica si el documento existe y devuelve el nombre
      if (snapshot.exists) {
        return snapshot['name'] ?? 'Sin nombre'; // Usa 'name' o un valor por defecto
      } else {
        return 'Usuario no encontrado';
      }
    } catch (e) {
      print("Error al obtener el nombre del usuario: $e");
      return 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [],
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar
          Container(
            color: Colors.blue[700],
            width: MediaQuery.of(context).size.width * 0.25,
            child: Column(
              children: [
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: const [
                      SidebarButton(texto: "MIS DATOS", icono: Icons.person),
                      SidebarButton(texto: "MIS ATENCIONES", icono: Icons.medical_services),
                      SidebarButton(texto: "MIS EXÁMENES", icono: Icons.science),
                      SidebarButton(texto: "MIS IMÁGENES", icono: Icons.image),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const SidebarButton(texto: "CERRAR SESIÓN", icono: Icons.exit_to_app),
              ],
            ),
          ),

          // Main Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Personalized Welcome Message
                  Text(
                    userName.isNotEmpty ? "BIENVENIDO $userName" : "Cargando...",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: const [
                        MainMenuButton(texto: "MIS DATOS", icono: Icons.person),
                        MainMenuButton(texto: "MIS EXÁMENES DE LABORATORIO", icono: Icons.science),
                        MainMenuButton(texto: "MIS IMÁGENES", icono: Icons.image),
                        MainMenuButton(texto: "MIS ATENCIONES", icono: Icons.medical_services),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Botón para la barra lateral
class SidebarButton extends StatelessWidget {
  final String texto;
  final IconData icono;

  const SidebarButton({required this.texto, required this.icono});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icono, color: Colors.white),
      title: Text(texto, style: const TextStyle(color: Colors.white)),
      onTap: () {
        // Acción al hacer clic
      },
    );
  }
}

// Botón del menú principal
class MainMenuButton extends StatelessWidget {
  final String texto;
  final IconData icono;

  const MainMenuButton({required this.texto, required this.icono});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[50],
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () {
        // Acción al hacer clic
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icono, size: 40, color: Colors.blue[700]),
          const SizedBox(height: 10),
          Text(
            texto,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
