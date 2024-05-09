import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'login.dart';

class ProfileScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController newPasswordController = TextEditingController();

  Future<void> _changePassword(BuildContext context) async {
    try {
      await _auth.currentUser?.updatePassword(newPasswordController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Contraseña cambiada con éxito.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print("Error during password change: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cambiar la contraseña: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      print("Error during sign out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Perfil'),
        backgroundColor: Color(0xFFFAEDE4),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('Usuarios').doc(_auth.currentUser?.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text('Usuario no encontrado'),
            );
          }
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          String username = userData['nombre'] ?? ''; // Obtener el nombre de usuario
          String photoUrl = userData['fotoUsuario'] ?? ''; // Obtener la URL de la foto del usuario
          return Container(
            color: Color(0xFFFAEDE4), // Color de fondo uniforme
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null, // Mostrar la foto de perfil si está disponible
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.camera_alt),
                            onPressed: () async {
                              final picker = ImagePicker();
                              final pickedFile = await picker.getImage(source: ImageSource.gallery); // Abre la galería para seleccionar una imagen
                              if (pickedFile != null) {
                                // Subir la imagen a Firebase Storage
                                try {
                                  await Firebase.initializeApp();
                                  final ref = FirebaseStorage.instance
                                      .ref()
                                      .child('fotos_perfil')
                                      .child('${_auth.currentUser?.uid}.jpg'); // Nombre del archivo en Firebase Storage
                                  await ref.putFile(File(pickedFile.path));
                                  final imageUrl = await ref.getDownloadURL();
                                  // Actualizar la URL de la foto de perfil en Firestore
                                  await FirebaseFirestore.instance.collection('Usuarios').doc(_auth.currentUser?.uid).update({
                                    'fotoUsuario': imageUrl,
                                  });
                                  // Actualizar la foto de perfil mostrada
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Foto de perfil actualizada con éxito.'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } catch (e) {
                                  print("Error during image upload: $e");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error al subir la imagen: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Nombre de Usuario:',
                      style: TextStyle(fontSize: 20, color: Colors.black), // Estilo de texto uniforme
                    ),
                    Text(
                      username,
                      style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Cambiar Contraseña:',
                      style: TextStyle(fontSize: 20, color: Colors.black), // Estilo de texto uniforme
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6, // Establece el ancho del contenedor
                      child: TextField(
                        controller: newPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Nueva Contraseña',
                        ),
                        obscureText: true,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _changePassword(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4B7342), // Cambia el color de fondo
                      ),
                      child: Text(
                        'Guardar Cambios',
                        style: TextStyle(
                          color: Colors.white, // Cambia el color del texto
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _signOut(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text(
                        'Cerrar Sesión',
                        style: TextStyle(
                          color: Colors.white, // Cambia el color del texto
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
