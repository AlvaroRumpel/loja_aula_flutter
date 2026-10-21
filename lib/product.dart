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
}
