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
    // O carrinho não muda com esta tela aberta: basta ler o valor.
    final items = cart.value;
    // fold soma os preços: começa em 0 e vai somando item por item.
    final total = items.fold(0.0, (sum, product) => sum + product.price);
    return Scaffold(
      appBar: AppBar(title: const Text('Carrinho')),
      body: ListView(
        children: [
          if (items.isEmpty)
            const ListTile(title: Text('Seu carrinho está vazio')),
          // "for" dentro da lista: uma linha para cada produto.
          for (final product in items)
            ListTile(
              title: Text(product.name),
              trailing: Text(formatPrice(product.price)),
            ),
          ListTile(
            title: Text(
              'Total: ${formatPrice(total)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
