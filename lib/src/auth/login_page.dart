import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trauma/screens/home_page.dart';
import 'package:trauma/screens/home_doctor_page.dart';
import 'package:trauma/src/auth/register_page.dart'; // Asegúrate de implementar esta página

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

  // Método para mostrar cuadro de diálogo para recuperación de contraseña
  void _showPasswordResetDialog() {
    final TextEditingController emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Recuperar Contraseña'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Correo Electrónico",
                  prefixIcon: Icon(Icons.email),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                String email = emailController.text.trim();
                if (email.isNotEmpty) {
                  await _resetPassword(email);
                  Navigator.of(context).pop();
                } else {
                  _showErrorDialog("Por favor ingresa un correo electrónico.");
                }
              },
              child: Text("Enviar Enlace de Recuperación"),
            ),
          ],
        );
      },
    );
  }

  // Método para enviar el enlace de recuperación de contraseña
  Future<void> _resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showSuccessDialog("Se ha enviado un enlace de recuperación al correo.");
    } catch (e) {
      print('Error: $e');
      _showErrorDialog("Hubo un error al enviar el correo de recuperación.");
    }
  }

  // Mostrar mensaje de éxito
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Éxito"),
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
                  Colors.blue.shade700,
                  Colors.purple.shade500,
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
                    color: Colors.white,
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
                          color: Colors.blue.shade800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Correo Electrónico",
                          prefixIcon: Icon(Icons.email, color: Colors.blue.shade800),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: "Contraseña",
                          prefixIcon: Icon(Icons.lock, color: Colors.blue.shade800),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                            ),
                            onPressed: signInWithEmailPassword,
                            child: Text(
                              "Iniciar Sesión",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.blue.shade700),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Volver",
                              style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
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
                          style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue.shade700),
                        ),
                      ),
                      // Agregar botón para recuperar contraseña
                      TextButton(
                        onPressed: () {
                          _showPasswordResetDialog();
                        },
                        child: Text(
                          "¿Olvidaste tu contraseña?",
                          style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue.shade700),
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
