import 'package:flutter/material.dart';

import 'package:loja/product.dart';

// Card de um produto: foto, nome, preço e nota.
class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8),
        // Column coloca os filhos um embaixo do outro.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Expanded: a foto ocupa o espaço que sobra depois dos textos.
            Expanded(
              child: Image.network(
                product.thumbnail,
                // Se a foto não carregar, aparece um ícone no lugar.
                errorBuilder: (context, error, stack) =>
                    const Icon(Icons.image_not_supported),
              ),
            ),
            Text(
              product.name,
              maxLines: 2, // nome comprido não empurra o resto do card
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              formatPrice(product.price),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE8572A),
              ),
            ),
            // Row coloca os filhos lado a lado.
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                Text('${product.rating}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Produto fixo para testar o card antes de buscar na internet.
const sampleProduct = Product(
  id: 6,
  name: 'Calvin Klein CK One',
  description: 'CK One by Calvin Klein is a classic unisex fragrance.',
  price: 49.99,
  rating: 4.37,
  thumbnail:
      'https://cdn.dummyjson.com/product-images/fragrances/calvin-klein-ck-one/thumbnail.webp',
);

// Tela da vitrine. Por enquanto mostra um produto fixo.
class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minha Loja')),
      body: const Center(
        // SizedBox: o card ganha o tamanho de um item da vitrine.
        child: SizedBox(
          width: 200,
          height: 300,
          child: ProductCard(product: sampleProduct),
        ),
      ),
    );
  }
}
