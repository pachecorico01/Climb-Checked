import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Importa el paquete de notificaciones locales
import 'package:firebase_core/firebase_core.dart';
import 'package:prueba/Inicio%20sesion/register.dart';
import 'Firebase/firebase_options.dart';
import 'Inicio sesion/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicializa el plugin de notificaciones locales
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'));
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Oculta la franja de debug
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  get flutterLocalNotificationsPlugin => null;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000), // Duración de la animación
    )..repeat(reverse: true); // Repite la animación en reverso

    _animation = Tween<double>(
      begin: 1.0, // Tamaño inicial
      end: 1.2, // Tamaño final
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut, // Curva de animación
      ),
    );

    // Llama a la función para programar la notificación cuando se inicializa el estado
    scheduleNotification(DateTime.now().add(Duration(
        days: 7))); // Ejemplo: programa la notificación 7 días desde ahora
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAEDE4),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _animation.value,
                  child: Image.asset(
                    'assets/logo.png', // Ruta de la imagen
                    height:
                        200, // Altura de la imagen (puedes cambiar este valor según tus necesidades)
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color(0xFF4B7342), // Cambia el color del botón a verde
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('Inicio de Sesión',
                  style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text(
                '¿No estás registrado? Regístrate aquí',
                style: TextStyle(color: Color(0xFF4B7342)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Función para programar la notificación
  void scheduleNotification(DateTime fechaProximaRevision) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Programa la notificación
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Próxima revisión',
      'Es hora de revisar el material',
      fechaProximaRevision,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
