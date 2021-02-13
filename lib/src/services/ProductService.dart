import 'dart:convert';
import 'dart:io';
import 'package:formulario_bloc_app/src/preferences/UserPreferences.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:formulario_bloc_app/src/models/producto_model.dart';
import 'package:mime_type/mime_type.dart';

class ProductService {
  final String _url =
      "https://flutter-varius-8cc19-default-rtdb.firebaseio.com";

  final _prefs = new UserPreferences();

  Future<bool> addProduct(Product product) async {
    final url = '$_url/Producto.json?auth=${_prefs.token}';

    await http.post(url, body: productToJson(product));

    return true;
  }

  Future<List<Product>> viewProducts() async {
    final List<Product> products = new List();
    final url = '$_url/Producto.json?auth=${_prefs.token}';
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);

    if (decodedData == null) return [];

    decodedData.forEach((id, product) {
      final prodTemp = Product.fromJson(product);
      prodTemp.id = id;

      products.add(prodTemp);
    });
    return products;
  }

  Future<int> deleteProduct(String id) async {
    final url = '$_url/Producto/$id.json?auth=${_prefs.token}';
    await http.delete(url);

    return 1;
  }

  Future<bool> putProductById(Product product) async {
    final url = '$_url/Producto/${product.id}.json?auth=${_prefs.token}';
    await http.put(url, body: productToJson(product));

    return true;
  }

  Future<String> uploadImage(File imagen) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/matiasandrediaza/image/upload?upload_preset=jefl5qqr');
    final mimeType = mime(imagen.path).split('/');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', imagen.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salio mal');
      print(resp.body);

      return null;
    }

    final responseData = json.decode(resp.body);

    print('----------------------------');
    print(responseData);
    print('----------------------------');

    return responseData['secure_url'];
  }
}
