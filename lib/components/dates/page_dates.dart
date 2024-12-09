import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animate/flutter_animate.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({Key? key}) : super(key: key);

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  Map<String, dynamic> userData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final docSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (docSnapshot.exists) {
          setState(() {
            userData = docSnapshot.data()!;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Detalles de Usuario"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        // Fondo con gradiente que cubre toda la pantalla
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SizedBox.expand( // Esto asegura que el fondo cubra todo el espacio
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bienvenido, ${userData['nombre']} ${userData['apellido']}",
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ).animate().fadeIn(duration: 500.ms).moveY(begin: -30),
                        const SizedBox(height: 20),
                        _buildInfoCard(
                          icon: Icons.badge,
                          label: "RUT",
                          value: userData['rut'] ?? "N/A",
                        ),
                        _buildInfoCard(
                          icon: Icons.email,
                          label: "Correo Electrónico",
                          value: userData['email'] ?? "N/A",
                        ),
                        _buildInfoCard(
                          icon: Icons.person,
                          label: "Tipo de Usuario",
                          value: userData['tipo'] ?? "N/A",
                        ),
                        if (userData['tipo'] == "Doctor")
                          _buildInfoCard(
                            icon: Icons.local_hospital,
                            label: "Especialización",
                            value: userData['especializacion'] ?? "N/A",
                          ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  // Tarjetas de información mejoradas
  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.blueGrey[700],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent, size: 30),
        title: Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.white70),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
      ).animate().fadeIn(duration: 700.ms).moveX(begin: 100),
    );
  }
}
