import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AgregarPreguntaPage extends StatefulWidget {
  @override
  _AgregarPreguntaPageState createState() => _AgregarPreguntaPageState();
}

class _AgregarPreguntaPageState extends State<AgregarPreguntaPage> {
  final TextEditingController _preguntaController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Pregunta'),
        backgroundColor: Color(0xFFFAEDE4), // Cambio de color de la barra de navegación
      ),
      backgroundColor: Color(0xFFFAEDE4), // Cambio de color de fondo de la pantalla
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _preguntaController,
                decoration: InputDecoration(
                  labelText: 'Pregunta',
                  labelStyle: TextStyle(color: Color(0xFF4B7342)), // Cambio de color del texto de la etiqueta
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF4B7342)), // Cambio de color del borde
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF4B7342)), // Cambio de color del borde cuando está enfocado
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity, // Establece el ancho al máximo posible
                child: ElevatedButton(
                  onPressed: () {
                    _agregarPregunta();
                  },
                  child: Text('Enviar', style: TextStyle(color: Colors.white)), // Cambio de color del texto en el botón
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4B7342), // Cambio de color del botón
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _agregarPregunta() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String uid = user.uid;
        String pregunta = _preguntaController.text.trim();
        if (pregunta.isNotEmpty) {
          // Agregar la pregunta con el UID del usuario
          await FirebaseFirestore.instance.collection('Preguntas').add({
            'pregunta': pregunta,
            'UID': uid, // Usar el UID del usuario
            'fecha': DateTime.now(),
          });
          // Limpiar el campo de pregunta después de enviar
          _preguntaController.clear();
          // Mostrar mensaje de éxito o navegar a la página de preguntas
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Pregunta enviada exitosamente'),
            ),
          );
          // Opcional: navegar a la página de preguntas después de enviar la pregunta
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Por favor ingresa una pregunta válida'),
            ),
          );
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al enviar la pregunta: $error'),
        ),
      );
    }
  }
}
