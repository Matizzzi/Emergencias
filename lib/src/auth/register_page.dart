import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import 'login_page.dart'; // Asegúrate de tener esta página implementada

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? userType = "Usuario"; // Por defecto, selecciona "Usuario"
  final List<String> doctorAreas = [
    "Cardiología",
    "Pediatría",
    "Dermatología",
    "Traumatología",
    "Otra"
  ];
  String? selectedArea; // Área seleccionada (si es doctor)

  // Controladores de texto
  final TextEditingController _rutController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false; // Indicador de carga

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: MediaQuery.of(context).size.width > 600 ? 500 : double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
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
                      "Registro de Cuenta",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24),
                    _buildTextField("RUT", controller: _rutController),
                    SizedBox(height: 16),
                    _buildTextField("Nombre", controller: _nombreController),
                    SizedBox(height: 16),
                    _buildTextField("Apellido", controller: _apellidoController),
                    SizedBox(height: 16),
                    _buildTextField("Correo Electrónico", controller: _emailController),
                    SizedBox(height: 16),
                    _buildTextField("Contraseña", controller: _passwordController, isPassword: true),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: userType,
                      onChanged: (value) {
                        setState(() {
                          userType = value;
                          if (value == "Usuario") {
                            selectedArea = null; // Limpia el área si no es doctor
                          }
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Tipo de Usuario",
                        labelStyle: TextStyle(color: Colors.blue[800]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: ["Usuario", "Doctor"]
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                    ),
                    if (userType == "Doctor") ...[
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedArea,
                        onChanged: (value) {
                          setState(() {
                            selectedArea = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: "Área de Especialización",
                          labelStyle: TextStyle(color: Colors.blue[800]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: doctorAreas
                            .map((area) => DropdownMenuItem(
                                  value: area,
                                  child: Text(area),
                                ))
                            .toList(),
                      ),
                    ],
                    SizedBox(height: 32),
                    if (_isLoading)
                      CircularProgressIndicator()
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildButton(
                            "Iniciar Sesión",
                            Colors.blue[600]!,
                            Colors.white,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            },
                          ),
                          _buildButton(
                            "Registrar",
                            Colors.blue[800]!,
                            Colors.white,
                            () => _registerUser(),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label,
      {TextEditingController? controller, bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.blue[800]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[800]!, width: 2),
        ),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: label == "RUT" ? [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(9), // Limitar a 9 dígitos
      ] : [],
    );
  }

  Widget _buildButton(String text, Color backgroundColor, Color textColor, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 8,
      ),
    );
  }

  Future<void> _registerUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Crear usuario en Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Guardar datos en Firestore, incluyendo el tipo de usuario (userType)
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'rut': _rutController.text.trim(),
        'nombre': _nombreController.text.trim(),
        'apellido': _apellidoController.text.trim(),
        'tipo': userType, // Tipo de usuario ("Usuario" o "Doctor")
        'especializacion': selectedArea ?? "", // Área de especialización si es doctor
        'email': _emailController.text.trim(),
        'created_at': Timestamp.now(),
      });

      // Mostrar éxito y redirigir al login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("¡Registro exitoso!")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      // Mostrar error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al registrar: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
