import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../menu.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');

    if (savedEmail != null && savedPassword != null) {
      setState(() {
        emailController.text = savedEmail;
        passwordController.text = savedPassword;
        _rememberMe = true;
      });
    }
  }

  Future<void> signIn(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (_rememberMe) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', emailController.text.trim());
        prefs.setString('password', passwordController.text.trim());
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('email');
        prefs.remove('password');
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Menu()),
      );
    } catch (e) {
      // Mostrar mensaje de error al usuario
      String errorMessage = '';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'Usuario no encontrado.';
            break;
          case 'wrong-password':
            errorMessage = 'Contraseña incorrecta.';
            break;
          default:
            errorMessage = 'Error de inicio de sesión: ${e.message}';
        }
      } else {
        errorMessage = 'Error de inicio de sesión: ${e.toString()}';
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
                'Inicio de sesión',
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
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (bool? value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                  ),
                  Text('Recordar sesión'),
                ],
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => signIn(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4B7342),
                ),
                child: Text(
                  'Iniciar sesión',
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
