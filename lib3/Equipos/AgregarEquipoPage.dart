import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AgregarEquipoPage extends StatefulWidget {
  @override
  _AgregarEquipoPageState createState() => _AgregarEquipoPageState();
}

class _AgregarEquipoPageState extends State<AgregarEquipoPage> {
  String _nombreEquipo = '';

  void _agregarEquipo(BuildContext context) async {
    try {
      if (_nombreEquipo.isNotEmpty) {
        await FirebaseFirestore.instance.collection('Equipos').add({
          'UID': FirebaseAuth.instance.currentUser?.uid,
          'nombreEquipo': _nombreEquipo,
          // Agregar otros campos si es necesario
        });

        Navigator.pop(context); // Volver a la pantalla anterior después de agregar el equipo
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Por favor ingrese un nombre para el equipo.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      print('Error al guardar el equipo en Firebase: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Equipo'),
        backgroundColor: Color(0xFFFAEDE4), // Cambio de color de fondo del appbar
      ),
      body: Container(
        color: Color(0xFFFAEDE4), // Cambio de color de fondo del contenedor
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Nombre del Equipo', labelStyle: TextStyle(color: Color(0xFF4B7342))), // Cambio de color del texto de la etiqueta
                onChanged: (value) {
                  setState(() {
                    _nombreEquipo = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _agregarEquipo(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4B7342), // Cambio de color del botón
                ),
                child: Text('Agregar', style: TextStyle(color: Colors.white)), // Cambio de color del texto en el botón
              ),
            ],
          ),
        ),
      ),
    );
  }
}
