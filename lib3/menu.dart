import 'package:flutter/material.dart';
import 'package:prueba/Preguntas/PreguntasPage.dart';
import 'Material Con Fallos/MaterialConFallosPage.dart';
import 'Videos/VideosPage.dart';
import 'Equipos/EquiposPage.dart';
import 'Inicio sesion/miPerfil.dart'; // Importa la pantalla de perfil que has creado

class MenuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Menu(), // Usar Menu como la página principal
    );
  }
}

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAEDE4), // Cambiar color de fondo
      appBar: AppBar(
        backgroundColor: Color(0xFFFAEDE4), // Color del AppBar
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: Color(0xFF4B7342)), // Icono de usuario
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()), // Navegar a la pantalla de perfil
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView( // Envuelve la columna con SingleChildScrollView
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 0), // Añadir espacio superior para el logo
              Image.asset(
                'assets/logo.png', // Ruta de tu logo
                width: 200, // Ajustar el tamaño de acuerdo a tus necesidades
              ),
              SizedBox(height: 0), // Añadir espacio entre el logo y los íconos
              IconButton(
                icon: Icon(Icons.backpack_rounded, color: Color(0xFF4B7342)), // Cambiar color del ícono
                iconSize: 100,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EquiposPage()), // Navegar a EquiposPage al presionar el ícono
                  );
                },
              ),
              Text('Mis Equipos'),
              SizedBox(height: 20),
              IconButton(
                icon: Icon(Icons.warning_rounded, color: Color(0xFF4B7342)), // Cambiar color del ícono
                iconSize: 100,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MaterialConFallosPage()), // Navegar a MaterialesConFallosPage al presionar el ícono
                  );
                },
              ),
              Text('Material Defectuoso'),
              SizedBox(height: 20),
              IconButton(
                icon: Icon(Icons.video_library, color: Color(0xFF4B7342)), // Cambiar color del ícono
                iconSize: 100,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VideosPage()), // Navegar a VideosPage al presionar el ícono
                  );
                },
              ),
              Text('Videos'),
              SizedBox(height: 20),
              IconButton(
                icon: Icon(Icons.question_answer_rounded, color: Color(0xFF4B7342)), // Cambiar color del ícono
                iconSize: 100,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PreguntasPage()), // Navegar a VideosPage al presionar el ícono
                  );
                },
              ),
              Text('Preguntas'),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

