import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'AgregarMaterialPage.dart';
import 'MaterialDetallePage.dart';
import 'AgregarRevisionPage.dart';

class Material {
  final String nombre;
  final String tipo;
  final String modelo;
  final String fechaCompra;
  final String fechaProximaRevision;
  final String imagePath;

  Material({
    required this.nombre,
    required this.tipo,
    required this.modelo,
    required this.fechaCompra,
    required this.fechaProximaRevision,
    required this.imagePath,
  });
}

class MaterialesPage extends StatefulWidget {
  final String equipoNombre;

  MaterialesPage({required this.equipoNombre});

  @override
  _MaterialesPageState createState() => _MaterialesPageState();
}

class _MaterialesPageState extends State<MaterialesPage> {
  List<Material> materiales = [];

  @override
  void initState() {
    super.initState();
    _cargarMateriales();
  }

  void _cargarMateriales() {
    FirebaseFirestore.instance
        .collection('materiales')
        .where('equipoNombre', isEqualTo: widget.equipoNombre)
        .get()
        .then((querySnapshot) {
      setState(() {
        materiales = querySnapshot.docs.map((doc) {
          return Material(
            nombre: doc['nombre'],
            tipo: doc['tipo'],
            modelo: doc['modelo'],
            fechaCompra: doc['fechaCompra'],
            fechaProximaRevision: doc['fechaProximaRevision'],
            imagePath: doc['imagePath'],
          );
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Material>> materialesPorCategoria = {};
    for (var material in materiales) {
      if (!materialesPorCategoria.containsKey(material.tipo)) {
        materialesPorCategoria[material.tipo] = [];
      }
      materialesPorCategoria[material.tipo]!.add(material);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Materiales de ${widget.equipoNombre}'),
        backgroundColor: Color(0xFFFAEDE4),
      ),
      body: Container(
        color: Color(0xFFFAEDE4),
        child: ListView.builder(
          itemCount: materialesPorCategoria.length,
          itemBuilder: (context, index) {
            String categoria = materialesPorCategoria.keys.elementAt(index);
            List<Material> materialesCategoria = materialesPorCategoria[categoria]!;
            return ExpansionTile(
              title: Text(categoria, style: TextStyle(color: Color(0xFF4B7342))),
              children: materialesCategoria.map((material) {
                return ListTile(
                  title: Text(material.nombre),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MaterialDetallePage(
                        materialNombre: material.nombre,
                        materialTipo: material.tipo,
                        materialModelo: material.modelo,
                        materialFechaCompra: material.fechaCompra,
                        materialFechaProximaRevision: material.fechaProximaRevision,
                        materialImagePath: material.imagePath,
                      )),
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      String? fechaProximaRevision = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AgregarRevisionPage(categoriaMaterial: categoria)),
                      );
                      if (fechaProximaRevision != null) {
                        // Actualizar la interfaz si es necesario
                      }
                    },
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _agregarMaterial(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF4B7342),
      ),
    );
  }

  void _agregarMaterial(BuildContext context) async {
    final nuevoMaterial = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AgregarMaterialPage(equipoNombre: widget.equipoNombre)),
    );
    if (nuevoMaterial != null) {
      FirebaseFirestore.instance.collection('materiales').add({
        'nombre': nuevoMaterial['nombre'],
        'tipo': nuevoMaterial['tipo'],
        'modelo': nuevoMaterial['modelo'],
        'fechaCompra': nuevoMaterial['fechaCompra'],
        'fechaProximaRevision': nuevoMaterial['fechaProximaRevision'],
        'imagePath': nuevoMaterial['imagePath'],
        'equipoNombre': widget.equipoNombre,
      }).then((_) {
        _cargarMateriales();
      });
    }
  }
}
