import 'package:flutter/material.dart';

import 'package:loja/cart.dart';
import 'package:loja/dummyjson_service.dart';
import 'package:loja/product.dart';
import 'package:loja/product_detail_page.dart';

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

// Categorias dos chips. A lista completa da API está em
// https://dummyjson.com/products/category-list
const categories = [
  'beauty',
  'fragrances',
  'furniture',
  'groceries',
  'smartphones',
  'laptops',
];

// Tela da vitrine: busca os produtos na internet e mostra numa grade.
class ProductListPage extends StatefulWidget {
  // O serviço vem de fora: nos testes dá para trocar por um falso.
  const ProductListPage({super.key, required this.service});

  final DummyJsonService service;

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  // Future = um valor que ainda vai chegar (a resposta da internet).
  // late: só é calculado no primeiro uso, quando já existe acesso a widget.
  late Future<List<Product>> _future = widget.service.fetchProducts();

  String? _category; // categoria escolhida; null = todas

  // O controller deixa o código limpar o texto do campo de busca.
  final _searchController = TextEditingController();

  // setState avisa o Flutter: "algo mudou, desenhe a tela de novo".
  // Sem categoria busca tudo; com categoria, só os produtos dela.
  // Busca e categoria não se misturam: escolher um chip limpa a busca.
  void _selectCategory(String? category) {
    _searchController.clear();
    setState(() {
      _category = category;
      _future = category == null
          ? widget.service.fetchProducts()
          : widget.service.fetchCategory(category);
    });
  }

  // trim tira os espaços das pontas: "  phone " vira "phone".
  // Campo vazio volta a mostrar todos os produtos.
  // A busca da API olha a loja toda, então o chip volta para "Todas".
  void _search(String text) {
    final query = text.trim();
    setState(() {
      _category = null;
      _future = query.isEmpty
          ? widget.service.fetchProducts()
          : widget.service.searchProducts(query);
    });
  }

  // A tela criou o controller, então ela o descarta quando sai.
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Loja'),
        actions: const [CartButton()],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Buscar produtos',
                prefixIcon: Icon(Icons.search),
              ),
              // Busca ao apertar Enter (ou a lupa do teclado do celular).
              textInputAction: TextInputAction.search,
              onSubmitted: _search,
            ),
          ),
          // Uma linha de chips que rola para o lado quando não cabe.
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
            child: Row(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Todas'),
                  selected: _category == null,
                  onSelected: (_) => _selectCategory(null),
                ),
                // "for" dentro da lista: um chip para cada categoria.
                for (final category in categories)
                  ChoiceChip(
                    label: Text(category),
                    selected: _category == category,
                    onSelected: (_) => _selectCategory(category),
                  ),
              ],
            ),
          ),
          // Expanded: a grade ocupa o resto da tela.
          Expanded(
            // FutureBuilder redesenha conforme o estado do Future:
            // carregando, erro ou com dados.
            child: FutureBuilder<List<Product>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Erro ao carregar os produtos'),
                  );
                }
                final products = snapshot.data!;
                if (products.isEmpty) {
                  return const Center(child: Text('Nenhum produto encontrado'));
                }
                // GridView.builder monta só os cards que aparecem na tela.
                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  // Cada card tem no máximo 220 de largura: quanto mais larga
                  // a janela, mais colunas cabem.
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, i) => GestureDetector(
                    // Navigator.push empilha uma nova tela sobre a atual.
                    // Passamos o produto tocado para a tela de detalhe.
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailPage(product: products[i]),
                      ),
                    ),
                    child: ProductCard(product: products[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
