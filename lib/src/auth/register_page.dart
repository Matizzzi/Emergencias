import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import 'login_page.dart'; // Asegúrate de implementar esta página

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final List<String> doctorAreas = [
    "Medicina de Emergencias",
    "Traumatología",
    "Cardiología",
    "Neurocirugía",
    "Anestesiología",
    "Pediatría de Emergencias",
    "Medicina Intensiva",
    "Obstetricia", 
    "Psiquiatría de Emergencias", 
    "Cirugía General de Emergencias", 
    "Otra"
  ];
  String? selectedArea;

  // Controladores de texto
  final TextEditingController _rutController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _registerUser() async {
    if (!_validateFields()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'rut': _rutController.text.trim(),
        'nombre': _nombreController.text.trim(),
        'apellido': _apellidoController.text.trim(),
        'tipo': "Doctor", // Siempre será Doctor
        'especializacion': selectedArea ?? "", // Especialización seleccionada
        'email': _emailController.text.trim(),
        'created_at': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("¡Registro exitoso!")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al registrar: ${e.toString()}")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _validateFields() {
    if (_rutController.text.isEmpty ||
        _nombreController.text.isEmpty ||
        _apellidoController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, completa todos los campos.")),
      );
      return false;
    }
    if (selectedArea == null || selectedArea!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, selecciona un área de especialización.")),
      );
      return false;
    }
    return true;
  }

  Widget _buildTextField(String label,
      {TextEditingController? controller, bool isPassword = false, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.blue[800]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[800]!, width: 2),
        ),
      ),
      keyboardType: keyboardType,
      inputFormatters: label == "RUT"
          ? [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(9),
            ]
          : [],
    );
  }

  Widget _buildDoctorAreaDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedArea,
      items: doctorAreas
          .map((area) => DropdownMenuItem(value: area, child: Text(area)))
          .toList(),
      onChanged: (value) => setState(() {
        selectedArea = value!;
      }),
      decoration: InputDecoration(
        labelText: "Área de Especialización",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: _registerUser,
      child: _isLoading
          ? CircularProgressIndicator(color: Colors.white)
          : Text("Registrar"),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        backgroundColor: Colors.blue[800],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro de Doctor"),
        backgroundColor: Colors.blue[800],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildTextField("RUT", controller: _rutController, keyboardType: TextInputType.number),
              SizedBox(height: 16),
              _buildTextField("Nombre", controller: _nombreController),
              SizedBox(height: 16),
              _buildTextField("Apellido", controller: _apellidoController),
              SizedBox(height: 16),
              _buildTextField("Correo Electrónico", controller: _emailController, keyboardType: TextInputType.emailAddress),
              SizedBox(height: 16),
              _buildTextField("Contraseña", controller: _passwordController, isPassword: true),
              SizedBox(height: 16),
              _buildDoctorAreaDropdown(),
              SizedBox(height: 32),
              _buildRegisterButton(),
            ],
          ),
        ),
      ),
    );
  }
}
