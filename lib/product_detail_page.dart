import 'package:flutter/material.dart';

import 'package:loja/product.dart';

// Tela de detalhe: mostra o produto que veio da vitrine.
// Não precisa buscar nada na internet, a vitrine já trouxe tudo.
class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.product});

  final Product product; // veio da vitrine pelo Navigator.push

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // O Navigator põe a seta de voltar na AppBar sozinho.
      appBar: AppBar(title: Text(product.name)),
      // ListView: a tela rola quando o conteúdo não cabe.
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Image.network(
            product.thumbnail,
            height: 300,
            errorBuilder: (context, error, stack) =>
                const Icon(Icons.image_not_supported),
          ),
          Text(
            formatPrice(product.price),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE8572A),
            ),
          ),
          Text(product.description),
        ],
      ),
    );
  }
}
