import 'package:flutter/material.dart';
import 'login_page.dart';

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
                    _buildTextField("RUT"),
                    SizedBox(height: 16),
                    _buildTextField("Nombre"),
                    SizedBox(height: 16),
                    _buildTextField("Apellido"),
                    SizedBox(height: 16),
                    _buildTextField("Correo Electrónico"),
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
                          () {
                            print("Registro enviado");
                          },
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

  Widget _buildTextField(String label) {
    return TextField(
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
}
