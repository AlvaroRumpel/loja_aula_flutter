import 'dart:convert';

// Preço em reais: 9.99 vira 'R$ 9,99' (duas casas, vírgula no lugar do ponto).
String formatPrice(double value) =>
    'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';

// Modelo de dados: descreve um produto com o que as telas precisam.
class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final double rating; // nota de 0 a 5
  final String thumbnail; // endereço da foto

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.thumbnail,
  });

  // Cria um produto a partir do JSON da DummyJSON.
  // Na API o nome se chama "title".
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['title'] as String,
      description: json['description'] as String,
      // num: a API às vezes manda 10 em vez de 10.0.
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      thumbnail: json['thumbnail'] as String,
    );
  }
}

// Transforma o texto JSON da resposta numa lista de produtos.
List<Product> productsFromJson(String body) {
  final data = jsonDecode(body) as Map<String, dynamic>;
  final products = data['products'] as List;
  return products
      .map((item) => Product.fromJson(item as Map<String, dynamic>))
      .toList();
}
