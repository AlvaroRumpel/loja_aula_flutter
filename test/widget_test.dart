import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:loja/main.dart';
import 'package:loja/product.dart';
import 'package:loja/product_list_page.dart';

// Card com o tamanho de um item da vitrine (como numa grade).
Widget cardWith(Product product) => MaterialApp(
  home: Scaffold(
    body: Center(
      child: SizedBox(
        width: 200,
        height: 300,
        child: ProductCard(product: product),
      ),
    ),
  ),
);

void main() {
  testWidgets('mostra título Minha Loja e o card do CK One', (tester) async {
    await tester.pumpWidget(const StoreApp());
    expect(find.text('Minha Loja'), findsOneWidget);
    expect(find.text('Calvin Klein CK One'), findsOneWidget);
  });

  testWidgets('card mostra nome, preço e nota', (tester) async {
    await tester.pumpWidget(cardWith(sampleProduct));
    await tester.pumpAndSettle();
    expect(find.text('Calvin Klein CK One'), findsOneWidget);
    expect(find.text('R\$ 49,99'), findsOneWidget);
    expect(find.text('4.37'), findsOneWidget);
    // Sem rede no teste, a foto cai no ícone do errorBuilder.
    expect(find.byIcon(Icons.image_not_supported), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('nome longo não estoura o card', (tester) async {
    await tester.pumpWidget(
      cardWith(
        Product(
          id: 2,
          name: 'Nome muito comprido ' * 12,
          description: '',
          price: 1,
          rating: 1,
          thumbnail: '',
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.widget<Text>(find.textContaining('Nome')).maxLines, 2);
    expect(tester.takeException(), isNull);
  });
}
