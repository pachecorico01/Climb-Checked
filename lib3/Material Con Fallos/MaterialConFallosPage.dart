import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'MaterialConFallosDetalle.dart' as detalle;
import 'AgregarMaterialConFallosPage.dart';

class MaterialConFallosPage extends StatefulWidget {
  @override
  _MaterialConFallosPageState createState() => _MaterialConFallosPageState();
}

class _MaterialConFallosPageState extends State<MaterialConFallosPage> {
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
        backgroundColor: Color(0xFFFAEDE4), // Color de la barra de navegación
        title: Text('Materiales con Fallos'),
      ),
      backgroundColor: Color(0xFFFAEDE4), // Color de fondo de la pantalla
      body: Column(
        children: [
          _buildSearchBar(), // Barra de búsqueda
          SizedBox(height: 25), // Añadir espacio
          Expanded(
            child: _buildMaterialList(), // Lista de materiales
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AgregarMaterialConFallosPage()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF4B7342), // Cambio de color del botón flotante
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar materiales...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white, // Color del fondo del campo de búsqueda
        ),
        onChanged: (value) {
          setState(() {
            // Lógica de búsqueda
          });
        },
      ),
    );
  }

  Widget _buildMaterialList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('materiales_con_fallos')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          final filteredDocs = snapshot.data!.docs.where((doc) {
            final nombre = doc['nombre']?.toString().toLowerCase() ?? '';
            final marca = doc['marca']?.toString().toLowerCase() ?? '';
            final searchTerm = _searchController.text.toLowerCase();
            return nombre.contains(searchTerm) || marca.contains(searchTerm);
          }).toList();

          return ListView.builder(
            itemCount: filteredDocs.length,
            itemBuilder: (context, index) {
              final doc = filteredDocs[index];
              return Card(
                color: Colors.white, // Color del fondo de la tarjeta
                child: ListTile(
                  title: Text(
                    doc['nombre'] ?? '',
                    style: TextStyle(color: Colors.black), // Color del texto
                  ),
                  subtitle: Text(
                    doc['marca'] ?? '',
                    style: TextStyle(color: Colors.black12), // Color del texto
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              detalle.MaterialConFallosDetalle(docId: doc.id)),
                    );
                  },
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
