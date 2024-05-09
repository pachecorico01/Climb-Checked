import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController(); // Nuevo controlador para el nombre de usuario

  Future<void> register(BuildContext context) async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Obtener el UID del usuario
      String uid = userCredential.user!.uid;

      // Guardar el nombre de usuario en la colección "Usuarios" de Firestore
      await FirebaseFirestore.instance.collection('Usuarios').doc(uid).set({
        'UID': uid,
        'nombre': usernameController.text.trim(),
        'fotoUsuario': '', // Inicialmente no hay foto de perfil
      });

      // Registro exitoso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tu cuenta se ha creado con éxito.'),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
        ),
      );
    } catch (e) {
      // Manejar errores durante el registro
      String errorMessage = '';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage =
            'Este correo electrónico ya está en uso. Por favor, utiliza otro.';
            break;
          default:
            errorMessage = 'Error durante el registro: ${e.message}';
        }
      } else {
        errorMessage = 'Error durante el registro: ${e.toString()}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFFAEDE4),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/logo.png',
                height: 300,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20.0),
              Text(
                'Registro',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4B7342),
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  labelStyle: TextStyle(color: Color(0xFF4B7342)),
                ),
                style: TextStyle(color: Color(0xFF4B7342)),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(color: Color(0xFF4B7342)),
                ),
                style: TextStyle(color: Color(0xFF4B7342)),
                obscureText: true,
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Nombre de usuario',
                  labelStyle: TextStyle(color: Color(0xFF4B7342)),
                ),
                style: TextStyle(color: Color(0xFF4B7342)),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => register(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4B7342),
                ),
                child: Text(
                  'Registrar',
                  style: TextStyle(
                    color: Colors.white,
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
