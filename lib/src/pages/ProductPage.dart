import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formulario_bloc_app/src/models/producto_model.dart';
import 'package:formulario_bloc_app/src/services/ProductService.dart';
import 'package:formulario_bloc_app/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  File photo;
  ProductService productService = new ProductService();
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _guardando = false;

  Product producto = new Product();

  @override
  Widget build(BuildContext context) {
    Product productData = ModalRoute.of(context).settings.arguments;

    if (productData != null) {
      producto = productData;
    }

    return Container(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Producto'),
          actions: [
            IconButton(
                icon: Icon(Icons.photo_size_select_actual),
                onPressed: _seleccionarFoto),
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: _tomarFoto,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  _mostrarFoto(),
                  _crearNombre(),
                  _crearPrecio(),
                  _crearDisponible(),
                  SizedBox(height: 20.0),
                  _crearBoton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Producto'),
      onSaved: (value) => producto.titulo = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textCapitalization: TextCapitalization.sentences,
      onSaved: (value) => producto.valor = int.parse(value),
      decoration: InputDecoration(labelText: 'Precio'),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return 'Solo numeros';
        }
      },
    );
  }

  Widget _crearBoton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      icon: Icon(Icons.save),
      onPressed: (_guardando) ? null : _submit,
      label: Text('Guardar'),
      color: Colors.deepPurple,
      textColor: Colors.white,
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();

    setState(() {
      _guardando = true;
    });

    if (photo != null) {
      producto.fotoUrl = await productService.uploadImage(photo);
    }

    if (producto.id != null) {
      productService.putProductById(producto);
      mostrarSnackBar('Registro cambiado');

      Timer(Duration(milliseconds: 1000), () => Navigator.pop(context, 'home'));
    } else {
      productService.addProduct(producto);
      mostrarSnackBar('Registro guardado');
    }

    setState(() {
      _guardando = false;
    });
  }

  Widget _crearDisponible() {
    return SwitchListTile(
      activeColor: Colors.deepPurple,
      value: producto.disponible,
      title: Text('Disponible'),
      onChanged: (value) => setState(() {
        producto.disponible = value;
      }),
    );
  }

  void mostrarSnackBar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(
        mensaje,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      duration: Duration(milliseconds: 2500),
      backgroundColor: Color.fromRGBO(30, 215, 96, 1),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  void _seleccionarFoto() async {
    _procesarFoto(ImageSource.gallery);
  }

  _mostrarFoto() {
    if (producto.fotoUrl != null) {
      return Image(
        image: NetworkImage(producto.fotoUrl),
        fit: BoxFit.cover,
        height: 300.0,
      );
    } else {
      if (photo != null) {
        return Image.file(
          photo,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }
  }

  void _tomarFoto() async {
    _procesarFoto(ImageSource.camera);
  }

  _procesarFoto(ImageSource img) async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(
      source: img,
    );

    photo = File(pickedFile.path);

    if (photo != null) {
      producto.fotoUrl = null;
    }

    setState(() {});
  }
}
