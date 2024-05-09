import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AgregarMaterialConFallosPage extends StatefulWidget {
  @override
  _AgregarMaterialConFallosPageState createState() =>
      _AgregarMaterialConFallosPageState();
}

class _AgregarMaterialConFallosPageState
    extends State<AgregarMaterialConFallosPage> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController marcaController = TextEditingController();
  final TextEditingController modeloController = TextEditingController();
  String? selectedTipo;
  final TextEditingController fechaFabricacionController =
  TextEditingController();
  final TextEditingController numeroSerieController = TextEditingController();
  final TextEditingController descripcionFalloController =
  TextEditingController();
  File? _image;

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<String> _uploadImageToFirebase() async {
    if (_image == null) return '';

    try {
      final firebase_storage.Reference ref = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('materiales_con_fallos')
          .child('${DateTime.now()}.jpg');
      final firebase_storage.UploadTask uploadTask = ref.putFile(_image!);
      final firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
      final String url = await taskSnapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  void agregarMaterialConFallo() async {
    if (nombreController.text.isNotEmpty &&
        marcaController.text.isNotEmpty &&
        modeloController.text.isNotEmpty &&
        selectedTipo != null &&
        fechaFabricacionController.text.isNotEmpty &&
        numeroSerieController.text.isNotEmpty &&
        descripcionFalloController.text.isNotEmpty) {
      final imageUrl = await _uploadImageToFirebase();
      FirebaseFirestore.instance.collection('materiales_con_fallos').add({
        'nombre': nombreController.text,
        'marca': marcaController.text,
        'modelo': modeloController.text,
        'tipo': selectedTipo,
        'fecha_fabricacion': fechaFabricacionController.text,
        'numero_serie': numeroSerieController.text,
        'descripcion_fallo': descripcionFalloController.text,
        'imagen_url': imageUrl,
      });
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor complete todos los campos.'),
          action: SnackBarAction(
            backgroundColor: Colors.red,
            label: 'OK',
            onPressed: () {},
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Material con Fallos'),
        backgroundColor: Color(0xFFFAEDE4),
      ),
      body: Container(
        color: Color(0xFFFAEDE4),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: nombreController,
                        decoration: InputDecoration(
                            labelText: 'Nombre',
                            labelStyle: TextStyle(color: Color(0xFF4B7342))),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: marcaController,
                        decoration: InputDecoration(
                            labelText: 'Marca',
                            labelStyle: TextStyle(color: Color(0xFF4B7342))),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: modeloController,
                        decoration: InputDecoration(
                            labelText: 'Modelo',
                            labelStyle: TextStyle(color: Color(0xFF4B7342))),
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedTipo,
                        onChanged: (String? value) {
                          setState(() {
                            selectedTipo = value;
                          });
                        },
                        items: <String>[
                          'Cuerda',
                          'Arnes',
                          'Grigri',
                          'Mosquetón',
                          'Cinta express',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Tipo',
                          labelStyle: TextStyle(color: Color(0xFF4B7342)),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: fechaFabricacionController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Fecha de fabricación',
                          labelStyle: TextStyle(color: Color(0xFF4B7342)),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () async {
                              final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2015, 8),
                                lastDate: DateTime.now(),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  fechaFabricacionController.text =
                                  '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: numeroSerieController,
                        decoration: InputDecoration(
                            labelText: 'Número de serie',
                            labelStyle: TextStyle(color: Color(0xFF4B7342))),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: descripcionFalloController,
                        maxLines: null,
                        decoration: InputDecoration(
                            labelText: 'Descripción del fallo',
                            labelStyle: TextStyle(color: Color(0xFF4B7342))),
                      ),
                      SizedBox(height: 10),
                      _image == null
                          ? ElevatedButton(
                        onPressed: _getImage,
                        child: Text(
                          'Seleccionar Imagen',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4B7342),
                        ),
                      )
                          : Image.file(_image!),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          agregarMaterialConFallo();
                        },
                        child: Text(
                          'Agregar Material con Fallo',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4B7342),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MaterialConFallosDetalle extends StatelessWidget {
  final String docId;

  MaterialConFallosDetalle({required this.docId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Material con Fallos'),
        backgroundColor: Color(0xFF4B7342),
      ),
      backgroundColor: Color(0xFFFAEDE4),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('materiales_con_fallos')
            .doc(docId)
            .get(),
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
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfo('Nombre:', data['nombre']),
                    SizedBox(height: 10),
                    _buildInfo('Marca:', data['marca']),
                    SizedBox(height: 10),
                    _buildInfo('Modelo:', data['modelo']),
                    SizedBox(height: 10),
                    _buildInfo('Tipo:', data['tipo']),
                    SizedBox(height: 10),
                    _buildInfo('Fecha de Fabricación:', data['fecha_fabricacion']),
                    SizedBox(height: 10),
                    _buildInfo('Número de Serie:', data['numero_serie']),
                    SizedBox(height: 10),
                    _buildInfo('Descripción del Fallo:', data['descripcion_fallo']),
                    SizedBox(height: 10),
                    _buildImage(data['imagen_url']),
                    SizedBox(height: 10),
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
      style: TextStyle(fontSize: 16, color: Color(0xFF4B7342)),
    );
  }

  Widget _buildImage(String imageUrl) {
    if (imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
