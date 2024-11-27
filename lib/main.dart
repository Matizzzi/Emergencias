import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'src/auth/login_page.dart';

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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[900]!, Colors.blue[400]!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(context),
                  _buildWelcomeSection(context),
                  SizedBox(height: 30),
                  _buildHospitalInfoSection(context),  // Ensure this calls _hospitalCard correctly
                  SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        children: [
          Animate(
            effects: [FadeEffect(duration: 800.ms), ScaleEffect(duration: 800.ms)],
            child: CircleAvatar(
              radius: 70,
              backgroundImage: AssetImage('assets/logoMelipilla.png'),
            ),
          ),
          SizedBox(height: 40),
          Animate(
            effects: [SlideEffect(), FadeEffect()],
            child: Container(
              padding: const EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.grey[200]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    '¡Sistema de emergencia!',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _animatedButton(
                        context: context,
                        text: "Iniciar Sesión",
                        icon: Icons.login,
                        color: Colors.blue[700]!,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                      ),
                      SizedBox(width: 20),
                      _animatedButton(
                        context: context,
                        text: "Registrarse",
                        icon: Icons.person_add,
                        color: Colors.green[400]!,
                        onPressed: () {
                          print("Registrarse");
                        },
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
    );
  }

  Widget _buildHospitalInfoSection(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            "Conoce Nuestro Hospital",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _hospitalCard(
                context,
                "Infraestructura Moderna",
                "assets/infra.png",
                "Contamos con instalaciones modernas equipadas con tecnología avanzada.",
              ),
              _hospitalCard(
                context,
                "Personal Capacitado",
                "assets/medico.png",
                "Nuestros médicos y enfermeros están altamente capacitados para cualquier emergencia.",
              ),
            _hospitalCard(
  context,
  "Atención 24/7",
  "assets/atencion.png",  // Correct image path
  "Ofrecemos atención médica las 24 horas del día, los 7 días de la semana.",
),
            ],
          ),
        ),
      ],
    );
  }

  Widget _hospitalCard(BuildContext context, String title, String imagePath, String description) {
    return Animate(
      effects: [FadeEffect(duration: 500.ms), ScaleEffect(duration: 500.ms)],
      child: Container(
        width: MediaQuery.of(context).size.width > 600 ? 300 : double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(
                imagePath,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    description,
                    style: TextStyle(fontSize: 16, color: Colors.blueGrey[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _animatedButton({
    required BuildContext context,
    required String text,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Animate(
      effects: [ScaleEffect(), FadeEffect()],
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 22, color: Colors.white),
        label: Text(
          text,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 8,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[800]!, Colors.blue[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MediaQuery.of(context).size.width > 800
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/logoMelipilla.png'),
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
          if (MediaQuery.of(context).size.width > 800)
            Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text('Inicio', style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('Servicios', style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('Contacto', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
