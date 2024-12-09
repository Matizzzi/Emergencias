import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trauma/components/dates/page_dates.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required String userName}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userFullName = "";

  @override
  void initState() {
    super.initState();
    _loadUserFullName();
  }

  Future<void> _loadUserFullName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Consultar datos del usuario en Firestore
        final docSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (docSnapshot.exists) {
          final data = docSnapshot.data();
          final String? nombre = data?['nombre'];
          final String? apellido = data?['apellido'];

          if (nombre != null && apellido != null) {
            setState(() {
              userFullName = "$nombre $apellido";
            });
          } else {
            setState(() {
              userFullName = "Nombre no disponible";
            });
          }
        } else {
          setState(() {
            userFullName = "Usuario no encontrado";
          });
        }
      }
    } catch (e) {
      print("Error al obtener el nombre del usuario: $e");
      setState(() {
        userFullName = "Error";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: const Text(
          "BIENVENIDO",
          style: TextStyle(fontSize: 20),
        ),
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
                    children: [
                      SidebarButton(texto: "MIS DATOS", icono: Icons.person),
                      SidebarButton(
                          texto: "MIS ATENCIONES", icono: Icons.medical_services),
                      SidebarButton(texto: "MIS EXÁMENES", icono: Icons.science),
                      SidebarButton(texto: "MIS IMÁGENES", icono: Icons.image),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SidebarButton(
                    texto: "CERRAR SESIÓN", icono: Icons.exit_to_app),
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
                  // Personalized Welcome Message (Only here)
                  Text(
                    userFullName.isNotEmpty
                        ? "Bienvenido $userFullName"
                        : "Cargando...",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: [
                        MainMenuButton(texto: "MIS DATOS", icono: Icons.person),
                        MainMenuButton(
                            texto: "MIS EXÁMENES DE LABORATORIO",
                            icono: Icons.science),
                        MainMenuButton(
                            texto: "MIS IMÁGENES", icono: Icons.image),
                        MainMenuButton(
                            texto: "MIS ATENCIONES",
                            icono: Icons.medical_services),
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

  const SidebarButton({Key? key, required this.texto, required this.icono})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (texto == "MIS DATOS") {
        Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const UserDetailsPage()),
);
        }
        // Puedes agregar lógica para otros botones aquí si lo necesitas
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(icono, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              texto,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// Botón del menú principal
class MainMenuButton extends StatelessWidget {
  final String texto;
  final IconData icono;

  const MainMenuButton({Key? key, required this.texto, required this.icono})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (texto == "MIS DATOS") {
        Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const UserDetailsPage()),
);
        }
        // Lógica adicional para otros botones
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[700],
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icono, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              texto,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
