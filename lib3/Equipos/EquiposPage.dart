import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Material/MaterialesPage.dart';
import 'AgregarEquipoPage.dart';

class EquiposPage extends StatefulWidget {
  @override
  _EquiposPageState createState() => _EquiposPageState();
}

class _EquiposPageState extends State<EquiposPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Equipos'),
        backgroundColor: Color(0xFFFAEDE4), // Cambio de color de fondo del appbar
      ),
      body: Container(
        color: Color(0xFFFAEDE4), // Color de fondo de la pantalla
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Equipos')
              .where('UID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No hay equipos disponibles'));
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var equipo = snapshot.data!.docs[index];
                var data = equipo.data() as Map<String, dynamic>;
                return Card(
                  color: Color(0xFFFFFFFF), // Cambio de color del fondo de la tarjeta
                  child: ListTile(
                    title: Text(data['nombreEquipo'] ?? 'Equipo sin nombre', style: TextStyle(color: Color(0xFF4B7342))), // Cambio de color del texto
                    onTap: () {
                      _verMateriales(context, data['nombreEquipo'] ?? ''); // Pasar el nombre del equipo en lugar del ID
                    },
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _confirmarEliminarEquipo(context, equipo.id); // Mostrar el diálogo de confirmación para eliminar el equipo
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _agregarEquipo(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF4B7342), // Cambio de color del botón flotante
      ),
    );
  }

  void _verMateriales(BuildContext context, String equipoNombre) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MaterialesPage(equipoNombre: equipoNombre)), // Pasar el nombre del equipo en lugar del ID
    );
  }

  void _agregarEquipo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AgregarEquipoPage()),
    );
  }

  void _eliminarEquipo(String equipoId) {
    FirebaseFirestore.instance.collection('Equipos').doc(equipoId).delete();
    // Agregar cualquier otra lógica de eliminación necesaria, como eliminar materiales relacionados, etc.
  }

  void _confirmarEliminarEquipo(BuildContext context, String equipoId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que quieres eliminar este equipo?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _eliminarEquipo(equipoId); // Llamar a la función para eliminar el equipo
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
