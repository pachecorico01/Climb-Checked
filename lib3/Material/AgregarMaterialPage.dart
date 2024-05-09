import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

class AgregarMaterialPage extends StatefulWidget {
  final String equipoNombre;

  AgregarMaterialPage({required this.equipoNombre});

  @override
  _AgregarMaterialPageState createState() => _AgregarMaterialPageState();
}

class _AgregarMaterialPageState extends State<AgregarMaterialPage> {
  String _nombreMaterial = '';
  String _modelo = '';
  String _fechaCompra = '';
  String _fechaProximaRevision = '';
  String _imagePath = '';

  String? _tipoSeleccionado;

  List<String> _tiposMateriales = [
    'Cuerda',
    'Arnes',
    'Grigri',
    'Mosquetón',
    'Cinta express',
    // Agrega más tipos si es necesario
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _fechaCompra = DateFormat('yyyy-MM-dd').format(picked);
        // Calcular la fecha de próxima revisión siete días después de la fecha actual
        final DateTime proximaRevision = DateTime.now().add(Duration(days: 7));
        _fechaProximaRevision = DateFormat('yyyy-MM-dd').format(proximaRevision);
      });
    }
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imagePath = pickedImage.path;
      });
      try {
        final File imageFile = File(pickedImage.path);
        final String imageName = path.basename(imageFile.path);
        final firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('material')
            .child(imageName);
        final firebase_storage.UploadTask uploadTask = ref.putFile(imageFile);
        final firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
        final String imageUrl = await taskSnapshot.ref.getDownloadURL();

        setState(() {
          _imagePath = imageUrl;
        });
      } catch (e) {
        print('Error uploading image: $e');
      }
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Material'),
        backgroundColor: Color(0xFFFAEDE4), // Cambio de color de la barra de navegación
      ),
      body: Container(
        color: Color(0xFFFAEDE4), // Cambio de color de fondo del contenedor
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Nombre del Material',
                  labelStyle: TextStyle(color: Color(0xFF4B7342)), // Color del texto de la etiqueta
                ),
                onChanged: (value) {
                  setState(() {
                    _nombreMaterial = value;
                  });
                },
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Modelo',
                  labelStyle: TextStyle(color: Color(0xFF4B7342)), // Color del texto de la etiqueta
                ),
                onChanged: (value) {
                  setState(() {
                    _modelo = value;
                  });
                },
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _fechaCompra.isNotEmpty
                          ? 'Fecha de Compra: $_fechaCompra'
                          : 'Selecciona una Fecha de Compra',
                      style: TextStyle(
                          color: Color(0xFF4B7342)), // Color del texto
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _fechaProximaRevision.isNotEmpty
                          ? 'Fecha de Próxima Revisión: $_fechaProximaRevision'
                          : 'Próxima Revisión: Una semana después de la compra',
                      style: TextStyle(
                          color: Color(0xFF4B7342)), // Color del texto
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              DropdownButton<String>(
                hint: Text('Selecciona el tipo de material'),
                value: _tipoSeleccionado,
                onChanged: (String? newValue) {
                  setState(() {
                    _tipoSeleccionado = newValue;
                  });
                },
                items: _tiposMateriales.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: Color(
                        0xFF4B7342))), // Color del texto
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _imagePath.isNotEmpty
                          ? 'Imagen seleccionada'
                          : 'Selecciona una Imagen',
                      style: TextStyle(
                          color: Color(0xFF4B7342)), // Color del texto
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.photo),
                    onPressed: () => _selectImage(),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_nombreMaterial.isNotEmpty && _tipoSeleccionado != null) {
                    Navigator.pop(context, {
                      'nombre': _nombreMaterial,
                      'tipo': _tipoSeleccionado,
                      'modelo': _modelo,
                      'fechaCompra': _fechaCompra,
                      'fechaProximaRevision': _fechaProximaRevision,
                      'imagePath': _imagePath, // Pasar la ruta de la imagen
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Por favor selecciona un tipo de material.'),
                      duration: Duration(seconds: 2),
                    ));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4B7342), // Cambio de color del botón
                ),
                child: Text(
                  'Agregar',
                  style: TextStyle(color: Colors.white), // Color del texto en el botón
                ),
              ),
              SizedBox(height: 16), // Ajusta el espaciado según sea necesario
            ],
          ),
        ),
      ),
    );
  }
}
