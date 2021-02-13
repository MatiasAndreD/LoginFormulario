import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  String id;
  String titulo;
  int valor;
  bool disponible;
  String fotoUrl;

  Product({
    this.id,
    this.titulo = '',
    this.valor = 0,
    this.disponible = true,
    this.fotoUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        titulo: json["titulo"],
        valor: json["valor"],
        disponible: json["disponible"],
        fotoUrl: json["fotoURL"],
      );

  Map<String, dynamic> toJson() => {
        /* "id": id, */
        "titulo": titulo,
        "valor": valor,
        "disponible": disponible,
        "fotoURL": fotoUrl,
      };
}
