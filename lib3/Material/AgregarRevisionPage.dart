import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AgregarRevisionPage extends StatefulWidget {
  final String categoriaMaterial;

  AgregarRevisionPage({required this.categoriaMaterial});

  @override
  _AgregarRevisionPageState createState() => _AgregarRevisionPageState();
}

class _AgregarRevisionPageState extends State<AgregarRevisionPage> {
  String? fechaProximaRevisionFormateada;

  Map<String, Map<String, List<Map<String, dynamic>>>> _preguntasYRespuestas = {
    'Generales': {
      '¿Con qué frecuencia se utiliza este equipo?': [
        {'respuesta': 'Diariamente', 'puntuacion': 3,},
        {'respuesta': 'Semanalmente', 'puntuacion': 2,},
        {'respuesta': 'Mensualmente', 'puntuacion': 1,},
        {'respuesta': 'Ocasionalmente', 'puntuacion': 0,}
      ],
      '¿Cómo se guarda este material cuando no se está utilizando?': [
        {'respuesta': 'En un lugar seco y ventilado', 'puntuacion': 0,},
        {'respuesta': 'En una bolsa o mochila específica para escalada', 'puntuacion': 0,},
        {'respuesta': 'Colgado en un lugar adecuado', 'puntuacion': 0,},
        {'respuesta': 'No lo guardo adecuadamente', 'puntuacion': 2,}
      ],
      '¿Se han realizado inspecciones con regularidad?': [
        {'respuesta': 'Sí', 'puntuacion': 0},
        {'respuesta': 'No', 'puntuacion': 2},
        {'respuesta': 'Inspecciones ocasionales', 'puntuacion': 1}
      ],
    },
    'Cuerda': {
      '¿La cuerda presenta cortes, roces, deshilachados o deformaciones?': [
        {'respuesta': 'Sí', 'puntuacion': 10},
        {'respuesta': 'No', 'puntuacion': 0},
        {'respuesta': 'Rozaduras leves', 'puntuacion': 1},
        {'respuesta': 'Deformaciones', 'puntuacion': 2}
      ],
      '¿La cuerda tiene un núcleo visible o está muy desgastada?': [
        {'respuesta': 'Sí', 'puntuacion': 2},
        {'respuesta': 'No', 'puntuacion': 0},
        {'respuesta': 'Núcleo visible', 'puntuacion': 2},
        {'respuesta': 'Desgaste evidente', 'puntuacion': 1}
      ],
      '¿La cuerda ha sido sometida a grandes caídas o impactos?': [
        {'respuesta': 'Sí', 'puntuacion': 2},
        {'respuesta': 'No', 'puntuacion': 0},
        {'respuesta': 'Impactos fuertes', 'puntuacion': 2}
      ],
      '¿La cuerda ha estado expuesta a productos químicos o temperaturas extremas?': [
        {'respuesta': 'Sí', 'puntuacion': 2},
        {'respuesta': 'No', 'puntuacion': 0},
        {'respuesta': 'Exposición a químicos', 'puntuacion': 2},
        {'respuesta': 'Temperaturas extremas', 'puntuacion': 2}
      ],
      '¿La cuerda ha sido mojada o se ha usado en condiciones de humedad?': [
        {'respuesta': 'Sí', 'puntuacion': 1},
        {'respuesta': 'No', 'puntuacion': 0},
        {'respuesta': 'Humedad', 'puntuacion': 1},
        {'respuesta': 'Condiciones húmedas frecuentes', 'puntuacion': 2}
      ],
      '¿La cuerda ha sido almacenada en un lugar seco y fresco?': [
        {'respuesta': 'Sí', 'puntuacion': 0},
        {'respuesta': 'No', 'puntuacion': 2},
        {'respuesta': 'Condiciones de almacenamiento inadecuadas', 'puntuacion': 1}
      ],
      '¿Has verificado si tu cuerda tiene cinta de marcaje interior?': [
        {'respuesta': 'No', 'puntuacion': 2},
        {'respuesta': 'Sí', 'puntuacion': 0},
        {'respuesta': 'No sé', 'puntuacion': 1}
      ],
      '¿Has notado si tu cuerda está rígida e hinchada?': [
        {'respuesta': 'No', 'puntuacion': 0},
        {'respuesta': 'Sí', 'puntuacion': 2},
        {'respuesta': 'Ligeramente', 'puntuacion': 1}
      ],
      '¿Al raspar la cuerda limpia y seca, desprende de un polvillo blanco ?': [
        {'respuesta': 'Si', 'puntuacion': 2},
        {'respuesta': 'Levemente', 'puntuacion': 1},
        {'respuesta': 'No', 'puntuacion': 1}
      ]
    },
    'Arnes': {
      '¿El arnés muestra signos de desgaste o daño en las costuras?': [
        {'respuesta': 'Sí', 'puntuacion': 2},
        {'respuesta': 'No', 'puntuacion': 0},
        {'respuesta': 'Desgaste leve', 'puntuacion': 1}
      ],
      '¿Se observan signos de corrosión o desgaste en los puntos de conexión o hebillas?': [
        {'respuesta': 'Sí', 'puntuacion': 2},
        {'respuesta': 'No', 'puntuacion': 0},
        {'respuesta': 'Desgaste leve', 'puntuacion': 1}
      ],
      '¿El sistema de ajuste del arnés funciona correctamente y se puede ajustar de manera segura?': [
        {'respuesta': 'Sí', 'puntuacion': 0},
        {'respuesta': 'No', 'puntuacion': 2}
      ],
      '¿El arnés ha sido sometido a caídas o impactos significativos recientemente?': [
        {'respuesta': 'Sí', 'puntuacion': 2},
        {'respuesta': 'No', 'puntuacion': 0}
      ],
      '¿El arnés ha estado expuesto a productos químicos o a condiciones ambientales extremas?': [
        {'respuesta': 'Sí', 'puntuacion': 2},
        {'respuesta': 'No', 'puntuacion': 0}
      ],
      '¿Has revisado el estado de las cintas del arnés?': [
        {'respuesta': 'Sí, están en perfecto estado.', 'puntuacion': 0},
        {'respuesta': 'No, aún no lo he hecho.', 'puntuacion': 0},
        {'respuesta': 'Hay desgarros o daños visibles.', 'puntuacion': 2}
      ],
      '¿Has verificado las costuras de seguridad del arnés?': [
        {'respuesta': 'Sí, todas las costuras están intactas.', 'puntuacion': 0},
        {'respuesta': 'No, no he revisado las costuras.', 'puntuacion': 0},
        {'respuesta': 'Hay hilos flojos o cortados en algunas costuras.', 'puntuacion': 2}
      ],
      '¿Has inspeccionado los puntos de encordamiento y de anillo de aseguramiento?': [
        {'respuesta': 'Sí, ambos puntos están en buen estado.', 'puntuacion': 0},
        {'respuesta': 'No, aún no lo he hecho.', 'puntuacion': 0},
        {'respuesta': 'Hay desgaste o daños visibles en los puntos de encordamiento.', 'puntuacion': 2}
      ],
      '¿Has comprobado el estado de las hebillas de regulación del arnés?': [
        {'respuesta': 'Sí, las hebillas están en condiciones óptimas.', 'puntuacion': 0},
        {'respuesta': 'No, aún no he revisado las hebillas.', 'puntuacion': 0},
        {'respuesta': 'Algunas hebillas muestran signos de desgaste o deformación.', 'puntuacion': 2}
      ],
      '¿Has revisado los elementos de confort del arnés?': [
        {'respuesta': 'Sí, los acolchados y trabillas elásticas están en buen estado.', 'puntuacion': 0},
        {'respuesta': 'No, aún no he revisado los elementos de confort.', 'puntuacion': 0},
        {'respuesta': 'Hay cortes o desgarros en los acolchados o trabillas elásticas.', 'puntuacion': 2}
      ]
    },
    'Grigri': {
      '¿El dispositivo de aseguramiento presenta desgaste o deformaciones o microfisuras?': [
        {'respuesta': 'Sí', 'puntuacion': 2},
        {'respuesta': 'No', 'puntuacion': 0},
        {'respuesta': 'Desgaste leve', 'puntuacion': 1}
      ],
      '¿El dispositivo de aseguramiento ha sido sometido a caídas o impactos significativos recientemente?': [
        {'respuesta': 'Sí', 'puntuacion': 2},
        {'respuesta': 'No', 'puntuacion': 0}
      ],
      '¿El dispositivo de aseguramiento ha estado expuesto a productos químicos o a condiciones ambientales extremas?': [
        {'respuesta': 'Sí', 'puntuacion': 2},
        {'respuesta': 'No', 'puntuacion': 0}
      ],
      '¿Has revisado el estado de la leva del dispositivo de aseguramiento?': [
        {'respuesta': 'Sí, la leva está en perfecto estado.', 'puntuacion': 0},
        {'respuesta': 'No, aún no lo he hecho.', 'puntuacion': 0},
        {'respuesta': 'Hay desgaste o daños visibles en la leva.', 'puntuacion': 2}
      ],
      '¿Has verificado el estado de la palanca de bloqueo del dispositivo de aseguramiento?': [
        {'respuesta': 'Sí, la palanca de bloqueo funciona correctamente.', 'puntuacion': 0},
        {'respuesta': 'No, aún no he revisado la palanca de bloqueo.', 'puntuacion': 0},
        {'respuesta': 'La palanca de bloqueo no se acciona correctamente.', 'puntuacion': 2}
      ],
      '¿Has inspeccionado el estado de la correa de frenado del dispositivo de aseguramiento?': [
        {'respuesta': 'Sí, la correa de frenado está en buen estado.', 'puntuacion': 0},
        {'respuesta': 'No, aún no lo he hecho.', 'puntuacion': 0},
        {'respuesta': 'Hay desgaste o daños visibles en la correa de frenado.', 'puntuacion': 2}
      ],
    },
    'Cinta express':{
      '¿La cinta express presenta cortes, roces, deshilachados o deformaciones?': [
        {'respuesta': 'Sí', 'puntuacion': 10},
        {'respuesta': 'No', 'puntuacion': 0},
        {'respuesta': 'Rozaduras leves', 'puntuacion': 1},
        {'respuesta': 'Deformaciones', 'puntuacion': 2}
      ],
      '¿La cinta express tiene un núcleo visible o está muy desgastada?': [
        {'respuesta': 'Sí', 'puntuacion': 2},
        {'respuesta': 'No', 'puntuacion': 0},
        {'respuesta': 'Núcleo visible', 'puntuacion': 2},
        {'respuesta': 'Desgaste evidente', 'puntuacion': 1}
      ],
      '¿La cinta express ha sido sometida a grandes caídas o impactos?': [
        {'respuesta': 'Sí', 'puntuacion': 2},
        {'respuesta': 'No', 'puntuacion': 0},
        {'respuesta': 'Impactos fuertes', 'puntuacion': 2}
      ],
      '¿La cinta express ha estado expuesta a productos químicos o temperaturas extremas?': [
        {'respuesta': 'Sí', 'puntuacion': 2},
        {'respuesta': 'No', 'puntuacion': 0},
        {'respuesta': 'Exposición a químicos', 'puntuacion': 2},
        {'respuesta': 'Temperaturas extremas', 'puntuacion': 2}
      ],
      '¿La cinta express ha sido mojada o se ha usado en condiciones de humedad?': [
        {'respuesta': 'Sí', 'puntuacion': 1},
        {'respuesta': 'No', 'puntuacion': 0},
        {'respuesta': 'Humedad', 'puntuacion': 1},
        {'respuesta': 'Condiciones húmedas frecuentes', 'puntuacion': 2}
      ],
    },
  };

  void _calcularYGenerarProximaRevision() {
    Duration tiempoDeVidaUtil = Duration();

    if (_puntuacionTotal > 10 && _puntuacionTotal <= 20) {
      tiempoDeVidaUtil = Duration(days: 6 * 30);
    } else if (_puntuacionTotal > 0 && _puntuacionTotal <= 10) {
      tiempoDeVidaUtil = Duration(days: 12 * 30);
    } else if (_puntuacionTotal == 0) {
      tiempoDeVidaUtil = Duration(days: 18 * 30);
    } else if (_puntuacionTotal > 20 && _puntuacionTotal <= 30) {
      tiempoDeVidaUtil = Duration(days: 3 * 30);
    } else {
      print(
          'La puntuación total supera 30. Deberías considerar cambiar el material.');
      return;
    }

    DateTime proximaRevision = DateTime.now().add(tiempoDeVidaUtil);

    fechaProximaRevisionFormateada =
        DateFormat('dd/MM/yyyy').format(proximaRevision);

    // Actualizar la fecha antes de abrir el diálogo
    _actualizarFechaProximaRevision();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Fecha para la próxima revisión'),
          content: Text(
              'La próxima revisión se recomienda para el $fechaProximaRevisionFormateada.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  Map<String, String?> _respuestas = {};
  int _puntuacionTotal = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Revisión de ${widget.categoriaMaterial}'),
        backgroundColor: Color(0xFFFAEDE4), // Color de fondo de la barra superior
      ),
      backgroundColor: Color(0xFFFAEDE4), // Color de fondo
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Preguntas generales:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4B7342)), // Color de texto
              ),
              SizedBox(height: 8),
              Column(
                children: _preguntasYRespuestas['Generales']!.keys.map((
                    pregunta) {
                  return DropdownButtonFormField<String>(
                    value: _respuestas[pregunta],
                    onChanged: (value) {
                      setState(() {
                        _respuestas[pregunta] = value;
                        _calcularPuntuacionTotal();
                      });
                    },
                    items: _preguntasYRespuestas['Generales']![pregunta]!.map((
                        respuesta) {
                      return DropdownMenuItem<String>(
                        value: respuesta['respuesta'],
                        child: Text(respuesta['respuesta'], style: TextStyle(color: Color(0xFF4B7342))), // Color de texto
                      );
                    }).toList(),
                    decoration: InputDecoration(labelText: pregunta),
                  );
                }).toList(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Preguntas específicas para ${widget.categoriaMaterial}:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4B7342)), // Color de texto
                ),
              ),
              Column(
                children: _preguntasYRespuestas[widget.categoriaMaterial]!.keys
                    .map((pregunta) {
                  return DropdownButtonFormField<String>(
                    value: _respuestas[pregunta],
                    onChanged: (value) {
                      setState(() {
                        _respuestas[pregunta] = value;
                        _calcularPuntuacionTotal();
                      });
                    },
                    items: _preguntasYRespuestas[widget
                        .categoriaMaterial]![pregunta]!.map((respuesta) {
                      return DropdownMenuItem<String>(
                        value: respuesta['respuesta'],
                        child: Text(respuesta['respuesta'] as String, style: TextStyle(color: Color(0xFF4B7342))), // Color de texto
                      );
                    }).toList(),
                    decoration: InputDecoration(labelText: pregunta),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _guardarYProcesarRespuestas();
                  },
                  child: Text(
                    'Guardar Revisión',
                    style: TextStyle(color: Colors.white), // Color del texto
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4B7342), // Color de fondo verde
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _guardarYProcesarRespuestas() {
    _calcularYGenerarProximaRevision();
  }

  void _calcularPuntuacionTotal() {
    int puntuacionTotal = 0;

    _respuestas.forEach((pregunta, respuesta) {
      if (respuesta != null) {
        var preguntaGeneral = _preguntasYRespuestas['Generales']![pregunta];
        if (preguntaGeneral != null) {
          preguntaGeneral.forEach((respuestaMap) {
            if (respuestaMap['respuesta'] == respuesta) {
              puntuacionTotal += respuestaMap['puntuacion'] as int;
            }
          });
        } else {
          var preguntaEspecifica = _preguntasYRespuestas[widget.categoriaMaterial]![pregunta];
          if (preguntaEspecifica != null) {
            preguntaEspecifica.forEach((respuestaMap) {
              if (respuestaMap['respuesta'] == respuesta) {
                puntuacionTotal += respuestaMap['puntuacion'] as int;
              }
            });
          }
        }
      }
    });

    setState(() {
      _puntuacionTotal = puntuacionTotal;
    });
  }

  void _actualizarFechaProximaRevision() {
    if (fechaProximaRevisionFormateada != null) {
      FirebaseFirestore.instance
          .collection('materiales')
          .where('tipo', isEqualTo: widget.categoriaMaterial) // Filtra los materiales por tipo
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({'fechaProximaRevision': fechaProximaRevisionFormateada})
              .then((_) {
            print('Fecha de próxima revisión actualizada para ${doc['nombre']} en Firestore.');
          }).catchError((error) {
            print('Error al actualizar la fecha de próxima revisión para ${doc['nombre']}: $error');
          });
        });
      }).catchError((error) {
        print('Error al obtener los materiales: $error');
      });
    } else {
      print('La fecha de próxima revisión no está definida.');
    }
  }
}
