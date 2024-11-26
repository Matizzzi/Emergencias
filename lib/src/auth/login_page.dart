import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Iniciar Sesión"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Si el ancho es mayor que 600, se considera como escritorio
          bool isDesktop = constraints.maxWidth > 600;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[900]!, Colors.blue[400]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: isDesktop ? 500 : double.infinity, // Contenedor más grande en escritorio
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 12,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Título de la página
                      Text(
                        "Iniciar Sesión",
                        style: TextStyle(
                          fontSize: isDesktop ? 32 : 24,
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

                      // Botón de inicio de sesión
                      ElevatedButton(
                        onPressed: () {
                          // Lógica para iniciar sesión (puedes agregar la validación aquí)
                          print("Iniciar sesión");
                        },
                        child: Text("Iniciar Sesión"),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          backgroundColor: Colors.blue[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 8,
                          textStyle: TextStyle(fontSize: isDesktop ? 20 : 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Enlace para registrarse
                      TextButton(
                        onPressed: () {
                          // Aquí puedes redirigir a la página de registro
                          print("Ir a registro");
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
