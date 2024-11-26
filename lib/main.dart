import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'src/auth/login_page.dart';
// Asegúrate de importar la pantalla de login

void main() {
  runApp(TraumaApp());
}

class TraumaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sistema Trauma',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WelcomePage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[900]!, Colors.blue[500]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Header que solo se muestra en escritorio
            _buildHeader(context),
            // Resto del contenido
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo con animación de entrada
                      Animate(
                        effects: [FadeEffect(), SlideEffect()],
                        child: CircleAvatar(
                          radius: 70,
                          backgroundImage: AssetImage('assets/images/logo.png'),
                        ),
                      ),
                      SizedBox(height: 40),
                      // Tarjeta de bienvenida con estilo moderno
                      Animate(
                        effects: [FadeEffect(), SlideEffect()],
                        child: Container(
                          padding: const EdgeInsets.all(30.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 12,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                '¡Bienvenido a Trauma!',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 15),
                              Text(
                                'Gestiona emergencias hospitalarias con eficiencia y precisión.',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blueGrey[800],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 40),
                              // Fila de botones con animación hover
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Animate(
                                    effects: [ScaleEffect()],
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        // Aquí se navega a la página de login
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LoginPage(),
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.login, size: 22),
                                      label: Text('Iniciar Sesión'),
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                        backgroundColor: Colors.blue[800],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        elevation: 8,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Animate(
                                    effects: [ScaleEffect()],
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        print("Registrarse");
                                      },
                                      icon: Icon(Icons.person_add, size: 22),
                                      label: Text('Registrarse'),
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                        backgroundColor: Colors.red[400],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        elevation: 8,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Animate(
                                effects: [SlideEffect()],
                                child: TextButton(
                                  onPressed: () {
                                    print("Explorar más");
                                  },
                                  child: Text(
                                    'Explorar más',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.blue[800],
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir el header responsivo
  Widget _buildHeader(BuildContext context) {
    // Verifica si el ancho de la pantalla es grande (escritorio)
    if (MediaQuery.of(context).size.width > 800) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        color: Colors.blue[800],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/logo.png'),
                ),
                SizedBox(width: 10),
                Text(
                  'Sistema Trauma',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            // Menú de opciones
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    print("Inicio");
                  },
                  child: Text(
                    'Inicio',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    print("Emergencias");
                  },
                  child: Text(
                    'Emergencias',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    print("Contacto");
                  },
                  child: Text(
                    'Contacto',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    print("Iniciar sesión");
                  },
                  child: Text('Iniciar Sesión'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return SizedBox.shrink(); // No muestra nada en dispositivos pequeños
    }
  }
}
