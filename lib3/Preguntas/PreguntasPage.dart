import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'AgregarPreguntaPage.dart'; // Importa la página de agregar pregunta
import 'PreguntasDetallePage.dart'; // Importa la página de detalles de la pregunta

class PreguntasPage extends StatefulWidget {
  @override
  _PreguntasPageState createState() => _PreguntasPageState();
}

class _PreguntasPageState extends State<PreguntasPage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preguntas'),
        backgroundColor: Color(0xFFFAEDE4), // Color de la barra de navegación
      ),
      backgroundColor: Color(0xFFFAEDE4),
      body: Column(
        children: [
          SizedBox(height: 10), // Añadir espacio arriba
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar preguntas...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white, // Cambio de color de fondo de la barra de búsqueda
              ),
              onChanged: (query) {
                setState(() {
                  // Realizar la búsqueda filtrando localmente los datos en lugar de realizar una nueva consulta a Firestore
                });
              },
            ),
          ),
          SizedBox(height: 25), // Añadir espacio entre la barra de búsqueda y la lista
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Preguntas')
                  .orderBy('fecha', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(
                        color: Colors.red, // Cambio de color del texto de error
                      ),
                    ),
                  );
                }
                var preguntas = snapshot.data!.docs;

                if (preguntas.isEmpty) {
                  return Center(
                    child: Text(
                      'No hay preguntas disponibles.',
                      style: TextStyle(
                        color: Colors.black87, // Cambio de color del texto de información
                      ),
                    ),
                  );
                }

                // Filtrar localmente las preguntas en función de la consulta de búsqueda
                var filteredPreguntas = preguntas.where((pregunta) {
                  var preguntaData = pregunta.data() as Map<String, dynamic>;
                  var searchTerm = _searchController.text.toLowerCase();
                  return preguntaData['pregunta'].toLowerCase().contains(searchTerm);
                }).toList();

                if (filteredPreguntas.isEmpty) {
                  return Center(
                    child: Text(
                      'No se encontraron preguntas.',
                      style: TextStyle(
                        color: Colors.black87, // Cambio de color del texto de información
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredPreguntas.length,
                  itemBuilder: (context, index) {
                    var pregunta = filteredPreguntas[index];
                    return Card(
                      color: Colors.white, // Cambio de color de fondo de la tarjeta
                      margin: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ), // Añadir margen a la tarjeta
                      child: ListTile(
                        title: Text(
                          pregunta['pregunta'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold, // Cambio de estilo de la pregunta
                          ),
                        ),
                        subtitle: FutureBuilder(
                          future: FirebaseFirestore.instance.collection('Usuarios').doc(pregunta['UID']).get(),
                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text('Cargando...');
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            if (snapshot.hasData) {
                              var userData = snapshot.data!.data() as Map<String, dynamic>;
                              return Text(
                                'Usuario: ${userData['nombre']}',
                                style: TextStyle(
                                  color: Colors.black87, // Cambio de color del texto del usuario
                                ),
                              );
                            }
                            return Text('Usuario no encontrado');
                          },
                        ),
                        onTap: () {
                          // Navegar a la página de detalles de la pregunta
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PreguntasDetallePage(
                                preguntaId: pregunta.id,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Cambio de ubicación del botón flotante
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a la página para añadir una nueva pregunta
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AgregarPreguntaPage(), // Cambio a la página de agregar pregunta
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF4B7342), // Cambio de color del botón flotante
      ),
    );
  }
}

class NuevaPreguntaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Nueva Pregunta'),
        backgroundColor: Color(0xFF4B7342), // Cambio de color de la barra de navegación
      ),
      body: Center(
        child: Text(
          'Formulario para añadir una nueva pregunta',
          style: TextStyle(
            color: Colors.black87, // Cambio de color del texto
          ),
        ),
      ),
    );
  }
}
