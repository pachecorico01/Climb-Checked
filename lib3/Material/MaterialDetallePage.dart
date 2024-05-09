import 'package:flutter/material.dart';

class MaterialDetallePage extends StatelessWidget {
  final String materialNombre;
  final String materialTipo;
  final String materialModelo;
  final String materialFechaCompra;
  final String materialFechaProximaRevision;
  final String materialImagePath;

  MaterialDetallePage({
    required this.materialNombre,
    required this.materialTipo,
    required this.materialModelo,
    required this.materialFechaCompra,
    required this.materialFechaProximaRevision,
    required this.materialImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Material'),
        backgroundColor: Color(0xFFFAEDE4), // Cambio de color del appbar
      ),
      body: Container(
        color: Color(0xFFFAEDE4), // Color de fondo de la pantalla
        padding: EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Imagen del producto
            Container(
              width: 120.0, // Ancho fijo para la imagen
              height: 120.0, // Altura fija para la imagen
              margin: EdgeInsets.only(right: 16.0), // Margen a la derecha para separar la imagen del texto
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0), // Bordes redondeados para la imagen
                image: DecorationImage(
                  image: NetworkImage(materialImagePath), // Utiliza NetworkImage para cargar la imagen desde la URL
                  fit: BoxFit.cover, // Ajusta la imagen para cubrir el contenedor
                ),
              ),
            ),
            // Información del producto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Nombre: $materialNombre',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 8.0), // Espacio entre las líneas de texto
                  Text(
                    'Tipo: $materialTipo',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Modelo: $materialModelo',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Fecha de compra: $materialFechaCompra',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Fecha próxima revisión: $materialFechaProximaRevision',
                    style: TextStyle(fontSize: 20),
                  ),
                  // Puedes agregar más campos aquí según sea necesario
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
