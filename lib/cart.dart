import 'package:flutter/material.dart';

import 'package:loja/product.dart';

// Estado do carrinho, compartilhado por todas as telas.
// ValueNotifier guarda um valor e avisa quem está escutando quando ele muda.
final cart = ValueNotifier<List<Product>>([]);

// Sempre uma lista nova: o ValueNotifier só avisa quando o valor troca.
// (cart.value.add(...) mudaria a lista por dentro e ninguém saberia.)
void addToCart(Product product) {
  cart.value = [...cart.value, product];
}

// A lista guarda uma cópia do produto para cada unidade: 2 kiwis = 2 itens.
// Tirar uma unidade = tirar a última vez que o produto aparece.
void removeOneFromCart(Product product) {
  final index = cart.value.lastIndexWhere((p) => p.id == product.id);
  cart.value = [...cart.value]..removeAt(index);
}

// Cada produto uma vez só, na ordem em que entrou no carrinho.
List<Product> uniqueProducts(List<Product> items) {
  final unique = <Product>[];
  for (final product in items) {
    if (!unique.any((p) => p.id == product.id)) unique.add(product);
  }
  return unique;
}

// Quantas vezes o produto está no carrinho.
int quantityOf(List<Product> items, Product product) =>
    items.where((p) => p.id == product.id).length;

// Ícone do carrinho com o contador. Vai na AppBar da vitrine e do detalhe.
class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder redesenha só este pedaço quando o carrinho muda.
    return ValueListenableBuilder<List<Product>>(
      valueListenable: cart,
      builder: (context, items, child) => IconButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CartPage()),
        ),
        // Badge: a bolinha com o número de itens.
        icon: Badge(
          label: Text('${items.length}'),
          child: const Icon(Icons.shopping_cart),
        ),
      ),
    );
  }
}

// Tela do carrinho: lista os produtos e mostra o total.
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carrinho')),
      // Os botões de menos e mais mudam o carrinho com a tela aberta,
      // então agora ela também escuta o carrinho.
      body: ValueListenableBuilder<List<Product>>(
        valueListenable: cart,
        builder: (context, items, child) {
          // fold soma os preços: começa em 0 e vai somando item por item.
          final total = items.fold(0.0, (sum, product) => sum + product.price);
          return ListView(
            children: [
              if (items.isEmpty)
                const ListTile(title: Text('Seu carrinho está vazio')),
              // Uma linha por produto, mesmo que ele esteja lá várias vezes.
              for (final product in uniqueProducts(items))
                ListTile(
                  title: Text(product.name),
                  // "2× R$ 9,99": quantidade e preço de uma unidade.
                  subtitle: Text(
                    '${quantityOf(items, product)}× ${formatPrice(product.price)}',
                  ),
                  // mainAxisSize.min: a Row fica só do tamanho dos botões.
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Menos',
                        icon: const Icon(Icons.remove),
                        onPressed: () => removeOneFromCart(product),
                      ),
                      IconButton(
                        tooltip: 'Mais',
                        icon: const Icon(Icons.add),
                        onPressed: () => addToCart(product),
                      ),
                    ],
                  ),
                ),
              ListTile(
                title: Text(
                  'Total: ${formatPrice(total)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
