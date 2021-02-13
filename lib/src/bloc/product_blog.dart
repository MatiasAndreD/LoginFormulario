import 'dart:io';

import 'package:formulario_bloc_app/src/models/producto_model.dart';
import 'package:formulario_bloc_app/src/services/ProductService.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc {
  final _productosController = new BehaviorSubject<List<Product>>();

  final _cargandoController = new BehaviorSubject<bool>();

  final _productService = new ProductService();

  Stream<List<Product>> get productStream => _productosController.stream;
  Stream<bool> get cargando => _cargandoController.stream;

  void loadProduct() async {
    final products = await _productService.viewProducts();

    _productosController.sink.add(products);
  }

  void addProduct(Product products) async {
    _cargandoController.sink.add(true);
    await _productService.addProduct(products);
    _cargandoController.sink.add(false);
  }

  Future<String> uploadImage(File image) async {
    _cargandoController.sink.add(true);
    final fotoURL = await _productService.uploadImage(image);
    _cargandoController.sink.add(false);

    return fotoURL;
  }

  void putProduct(Product products) async {
    _cargandoController.sink.add(true);
    await _productService.putProductById(products);
    _cargandoController.sink.add(false);
  }

  void deleteProduct(String id) async {
    await _productService.deleteProduct(id);
  }

  dispose() {
    _cargandoController?.close();
    _productosController?.close();
  }
}
