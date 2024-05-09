import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PreguntasDetallePage extends StatelessWidget {
  final String preguntaId;

  PreguntasDetallePage({required this.preguntaId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Respuestas'),
        backgroundColor: Color(0xFFFAEDE4), // Cambio de color de la barra de navegación
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Preguntas').doc(preguntaId).snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return Center(child: Text('Error al cargar la pregunta'));
              }

              var preguntaData = snapshot.data!.data() as Map<String, dynamic>;
              String pregunta = preguntaData['pregunta'];

              return Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Pregunta: $pregunta',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
          SizedBox(height: 10), // Separación entre la pregunta y las respuestas
          Expanded(
            child: Container(
              color: Color(0xFFFAEDE4), // Cambio de color de fondo de la lista de respuestas
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Preguntas')
                    .doc(preguntaId)
                    .collection('Respuestas')
                    .orderBy('fecha', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(color: Colors.red), // Cambio de color del texto de error
                      ),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No hay respuestas disponibles para esta pregunta.',
                        style: TextStyle(color: Colors.black87), // Cambio de color del texto de información
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var respuesta = snapshot.data!.docs[index];
                      return FutureBuilder(
                        future: FirebaseFirestore.instance.collection('Usuarios').doc(respuesta['UID']).get(),
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                          if (userSnapshot.connectionState == ConnectionState.waiting) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: Offset(0, 1), // Cambio en el desplazamiento de la sombra
                                  ),
                                ],
                              ),
                              child: Text('Cargando...'),
                            );
                          }
                          if (userSnapshot.hasError) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: Offset(0, 1), // Cambio en el desplazamiento de la sombra
                                  ),
                                ],
                              ),
                              child: Text('Error al cargar el nombre del usuario'),
                            );
                          }
                          if (userSnapshot.hasData) {
                            var userData = userSnapshot.data!.data() as Map<String, dynamic>;
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: Offset(0, 1), // Cambio en el desplazamiento de la sombra
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    respuesta['respuesta'],
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Usuario: ${userData['nombre']}',
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                  Text(
                                    'Fecha: ${DateTime.fromMillisecondsSinceEpoch(respuesta['fecha'].seconds * 1000)}', // Convertir los segundos a DateTime
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                ],
                              ),
                            );
                          }
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(0, 1), // Cambio en el desplazamiento de la sombra
                                ),
                              ],
                            ),
                            child: Text('Usuario no encontrado'),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            _agregarRespuesta(context, preguntaId); // Pasar el ID de la pregunta al método
          },
          child: Text(
            'Responder',
            style: TextStyle(color: Colors.white), // Cambio de color del texto del botón
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF4B7342), // Cambio de color del botón
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, // Posiciona el botón en el centro horizontal de la pantalla
    );
  }

  void _agregarRespuesta(BuildContext context, String preguntaId) {
    // Implementa la lógica para agregar una respuesta asociada a la pregunta
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String respuestaText = ''; // Variable para almacenar la respuesta

        return AlertDialog(
          title: Text('Agregar Respuesta'),
          content: TextField(
            // Aquí puedes personalizar el campo de texto según tus necesidades
            decoration: InputDecoration(
              hintText: 'Ingresa tu respuesta aquí',
            ),
            onChanged: (value) {
              respuestaText = value; // Actualizar la respuesta cuando el texto cambie
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Verificar si la respuesta no está vacía
                if (respuestaText.isNotEmpty) {
                  // Guardar la respuesta en la base de datos
                  FirebaseFirestore.instance
                      .collection('Preguntas')
                      .doc(preguntaId)
                      .collection('Respuestas')
                      .add({
                    'respuesta': respuestaText,
                    'UID': FirebaseAuth.instance.currentUser?.uid, // Agregar el UID del usuario actual
                    'fecha': DateTime.now(), // Agregar la fecha actual
                  });

                  // Cerrar el diálogo después de guardar la respuesta
                  Navigator.pop(context);
                }
              },
              child: Text(
                'Enviar',
                style: TextStyle(color: Colors.white), // Cambio de color del texto del botón
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4B7342), // Cambio de color del botón
              ),
            ),
          ],
        );
      },
    );
  }
}
