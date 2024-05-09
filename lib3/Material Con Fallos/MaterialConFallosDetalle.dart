import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MaterialConFallosDetalle extends StatelessWidget {
  final String docId;

  MaterialConFallosDetalle({required this.docId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalles del Material',
          style: TextStyle(color: Colors.black87), // Color del texto en el AppBar
        ),
        backgroundColor: Color(0xFFFAEDE4), // Color del AppBar
        elevation: 0, // Sin sombra debajo del AppBar
      ),
      backgroundColor: Color(0xFFFAEDE4), // Color de fondo de la pantalla
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('materiales_con_fallos').doc(docId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data!.data() as Map<String, dynamic>;

            return Padding(
              padding: EdgeInsets.all(20.0),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 1), // Cambia la posición de la sombra
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImage(data['imagen_url']), // Mostrar la imagen
                    SizedBox(height: 20), // Espacio adicional
                    _buildInfo('Nombre:', data['nombre']),
                    _buildInfo('Marca:', data['marca']),
                    _buildInfo('Modelo:', data['modelo']),
                    _buildInfo('Tipo:', data['tipo']),
                    _buildInfo('Fecha de Fabricación:', data['fecha_fabricacion']),
                    _buildInfo('Número de Serie:', data['numero_serie']),
                    SizedBox(height: 20), // Espacio adicional
                    _buildFalloInfo('Descripción del Fallo:', data['descripcion_fallo']), // Estilo personalizado para la descripción del fallo
                    SizedBox(height: 20), // Espacio adicional
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return Text(
      '$label $value',
      style: TextStyle(fontSize: 16, color: Colors.black87), // Color del texto y tamaño
    );
  }

  Widget _buildFalloInfo(String label, String value) {
    return Container(
      width: double.infinity, // Ancho máximo
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4B7342)), // Estilo personalizado para la etiqueta del fallo
          ),
          SizedBox(height: 5), // Espacio adicional
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.black87), // Color del texto y tamaño
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    if (imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        width: double.infinity, // Ancho máximo
        fit: BoxFit.cover, // Ajuste de la imagen
      );
    } else {
      return SizedBox.shrink(); // Retorna un widget vacío si no hay URL de imagen
    }
  }
}
