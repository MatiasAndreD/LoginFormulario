import 'package:flutter/material.dart';
import 'package:formulario_bloc_app/src/models/producto_model.dart';
import 'package:formulario_bloc_app/src/services/ProductService.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final productService = new ProductService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: _crearListado(),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => Navigator.pushNamed(context, 'product')
          .then((value) => setState(() {})),
      backgroundColor: Colors.deepPurple,
    );
  }

  Widget _crearListado() {
    return FutureBuilder(
      future: productService.viewProducts(),
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
        final productos = snapshot.data;

        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, i) => _crearItem(context, productos[i]),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _crearItem(BuildContext context, Product product) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direccion) {
          //TODO: Borrar producto

          productService.deleteProduct(product.id);
        },
        child: GestureDetector(
          onTap: () =>
              Navigator.pushNamed(context, 'product', arguments: product),
          child: Card(
            child: Column(
              children: [
                (product.fotoUrl == null)
                    ? Image(
                        image: AssetImage('assets/no-image.png'),
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : FadeInImage(
                        placeholder: AssetImage('assets/jar-loading.gif'),
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        image: NetworkImage(product.fotoUrl),
                      ),
                ListTile(
                  title: Text('${product.titulo} - ${product.valor}'),
                  subtitle: Text(product.id),
                ),
              ],
            ),
          ),
        ));
  }
}
