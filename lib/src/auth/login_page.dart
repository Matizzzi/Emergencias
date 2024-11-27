import 'package:flutter/material.dart';
import 'register_page.dart'; // Asegúrate de importar la página de registro

class LoginPage extends StatelessWidget {
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
                  Colors.blue.withOpacity(0.5), // Color más claro
                  Colors.white.withOpacity(0.8) // Color más transparente
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
                    color: Colors.white.withOpacity(0.8), // Fondo translúcido
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
                      // Título
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
                      // Campo de correo electrónico
                      TextField(
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
                      // Campo de contraseña
                      TextField(
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
                      // Botón de iniciar sesión
                      ElevatedButton(
                        onPressed: () {
                          print("Iniciar sesión");
                        },
                        child: Text(
                          "Iniciar Sesión",
                          style: TextStyle(
                            color: Colors.white, // Texto visible
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
                      // Botón para registrarse
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
                      // Botón de volver
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context); // Vuelve a la pantalla anterior
                        },
                        child: Text(
                          "Volver",
                          style: TextStyle(
                            color: Colors.blue[800], // Texto visible
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
