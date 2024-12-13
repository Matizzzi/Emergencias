import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance; // FirebaseAuth instance
  final List<Map<String, String>> _messages = [];
  int _responseCount = 0;
  String? _userName;
  String? _userRut;
  String? _guardianName;
  String? _guardianRut;
  String? _emergencyDescription;
  String? _emergencyType;
  String? _emergencySeverity;

  @override
  void initState() {
    super.initState();
    _startChat();
  }

  void _startChat() {
    setState(() {
      _messages.add({
        "role": "bot",
        "message": "¡Bienvenido a Emergencias! ¿Cual es el nombre del paciente?",
      });
    });
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    final userMessage = _controller.text.trim();
    setState(() {
      _messages.add({"role": "user", "message": userMessage});
    });

    _controller.clear();

    _responseCount++;

    if (_responseCount == 1) {
      // El bot pide el nombre del paciente
      setState(() {
        _userName = userMessage;
        _messages.add({
          "role": "bot",
          "message": "Hola, $_userName. ¿Cuál es tu RUT del paciente?",
        });
      });
    } else if (_responseCount == 2) {
      // El bot guarda el RUT del paciente
      _userRut = userMessage;
      setState(() {
        _messages.add({
          "role": "bot",
          "message": "¿Cuál es el nombre del titular de la emergencia?",
        });
      });
    } else if (_responseCount == 3) {
      // El bot guarda el nombre del titular
      _guardianName = userMessage;
      setState(() {
        _messages.add({
          "role": "bot",
          "message": "¿Cuál es el RUT del titular?",
        });
      });
    } else if (_responseCount == 4) {
      // El bot guarda el RUT del titular
      _guardianRut = userMessage;
      setState(() {
        _messages.add({
          "role": "bot",
          "message": "Por favor, describe la emergencia.",
        });
      });
    } else if (_responseCount == 5) {
      // El bot guarda la descripción de la emergencia
      _emergencyDescription = userMessage;
      setState(() {
        _messages.add({
          "role": "bot",
          "message": "¿Cuál es la gravedad de la emergencia?\n1. Baja\n2. Media\n3. Alta",
        });
      });
    } else if (_responseCount == 6) {
      // El bot guarda la gravedad de la emergencia
      if (userMessage == "1") {
        _emergencySeverity = "Baja";
      } else if (userMessage == "2") {
        _emergencySeverity = "Media";
      } else if (userMessage == "3") {
        _emergencySeverity = "Alta";
      }

      // Crear el usuario del titular
      _createTitularAccount();
    }
  }

  void _createTitularAccount() async {
    if (_guardianRut != null && _guardianRut!.length >= 5) {
      // Obtener los últimos 4 números antes del guion en el RUT
      String password = _guardianRut!.substring(_guardianRut!.length - 5, _guardianRut!.length - 1);
      
      // Asegurarse de que la contraseña tenga al menos 6 caracteres
      if (password.length < 6) {
        password = "00000" + password; // Rellenar con ceros si es necesario
      }

      // Crear el correo electrónico del titular
      String email = _guardianName!.substring(0, 1).toLowerCase() + "@emergencias.cl";

      try {
        // Crear la cuenta de Firebase
        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        
        // Crear el documento en la colección 'titulares'
        await _firestore.collection('titulares').add({
          'nombre_titular': _guardianName,
          'rut_titular': _guardianRut,
          'email_titular': email,
          'password_titular': password, // Almacenar la contraseña en Firestore
          'fecha_creacion': FieldValue.serverTimestamp(),
        });

        // Mostrar mensaje de éxito y la información del usuario
        setState(() {
          _messages.add({
            "role": "bot",
            "message": "La cuenta del titular ha sido creada exitosamente.\n"
                        "Tu correo es: $email\n"
                        "Tu contraseña es: $password",
          });
        });
      } on FirebaseAuthException catch (e) {
        setState(() {
          _messages.add({
            "role": "bot",
            "message": "Hubo un problema al crear la cuenta del titular. ${e.message}",
          });
        });
      }
    } else {
      setState(() {
        _messages.add({
          "role": "bot",
          "message": "El RUT ingresado no es válido.",
        });
      });
    }
  }

  Future<void> _saveEmergency() async {
    try {
      await _firestore.collection('emergencias').add({
        'nombre_paciente': _userName,
        'rut_paciente': _userRut,
        'nombre_titular': _guardianName,
        'rut_titular': _guardianRut,
        'descripcion_emergencia': _emergencyDescription,
        'tipo_emergencia': _emergencyType ?? 'Otros',
        'gravedad': _emergencySeverity,
        'fecha': FieldValue.serverTimestamp(),
      });

      setState(() {
        _messages.add({
          "role": "bot",
          "message": "¡Tu emergencia ha sido registrada exitosamente! Un doctor se pondrá en contacto contigo pronto.",
        });
      });
    } catch (e) {
      setState(() {
        _messages.add({
          "role": "bot",
          "message": "Hubo un problema al guardar la emergencia. Intenta de nuevo más tarde.",
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Asistencia Médica"),
        backgroundColor: Colors.blue[700],
      ),
      body: Center(
        child: Container(
          width: 800,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(blurRadius: 10, color: Colors.grey[300]!, spreadRadius: 5)],
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    final isUser = message["role"] == "user";
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        margin: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.blueAccent : Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          message["message"]!,
                          style: TextStyle(
                            color: isUser ? Colors.white : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: "Escribe tu mensaje...",
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _sendMessage,
                      child: Icon(Icons.send, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(15),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
