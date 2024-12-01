import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trauma/screens/home_page.dart';  // Página de usuario común
import 'package:trauma/screens/home_doctor_page.dart';
import 'register_page.dart'; // Ruta relativa correcta a la ubicación del archivo
// Página de registro
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
Future<void> signInWithEmailPassword() async {
  String email = emailController.text.trim();
  String password = passwordController.text.trim();

  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>?;

        if (data != null && data.isNotEmpty) {
          String? role = data['tipo']?.toString().toLowerCase();
          
          if (role == 'doctor') {
            String? especializacion = data['especializacion'] as String?;
            if (especializacion != null && especializacion.isNotEmpty) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeDoctorPage()),
              );
            } else {
              _showErrorDialog("El doctor no tiene especialización definida.");
            }
          } else if (role == 'usuario') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage(userName: user.email ?? 'Usuario')),
            );
          } else {
            _showErrorDialog("Rol desconocido. Contacta al administrador.");
          }
        } else {
          _showErrorDialog("Los datos del usuario están vacíos.");
        }
      } else {
        _showErrorDialog("No se encontró el usuario en la base de datos.");
      }
    }
  } catch (e) {
    print('Error: $e');
    _showErrorDialog("Correo electrónico o contraseña incorrectos.");
  }
}

// Función para mostrar un diálogo de error
void _showErrorDialog(String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Error"),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cerrar"),
        ),
      ],
    ),
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 600;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.5),
                  Colors.white.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: isDesktop ? 500 : double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Iniciar Sesión",
                        style: TextStyle(
                          fontSize: isDesktop ? 28 : 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                          fontFamily: "Roboto",
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Correo Electrónico",
                          labelStyle: TextStyle(color: Colors.blue[800]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue[800]!, width: 2),
                          ),
                          prefixIcon: Icon(Icons.email, color: Colors.blue[800]),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: "Contraseña",
                          labelStyle: TextStyle(color: Colors.blue[800]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue[800]!, width: 2),
                          ),
                          prefixIcon: Icon(Icons.lock, color: Colors.blue[800]),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: signInWithEmailPassword,
                        child: Text(
                          "Iniciar Sesión",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isDesktop ? 18 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          backgroundColor: Colors.blue[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 8,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterPage()),
                          );
                        },
                        child: Text(
                          "¿No tienes cuenta? Regístrate",
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: isDesktop ? 16 : 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Volver",
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: isDesktop ? 16 : 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.blue[800]!, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
