import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:loja/dummyjson_service.dart';
import 'package:loja/product.dart';
import 'package:loja/product_list_page.dart';

// Serviço falso: devolve o que o teste mandar, sem internet.
class FakeDummyJsonService extends DummyJsonService {
  FakeDummyJsonService(this.onFetchProducts);

  final Future<List<Product>> Function() onFetchProducts;

  @override
  Future<List<Product>> fetchProducts() => onFetchProducts();
}

Product productNamed(int id, String name) => Product(
  id: id,
  name: name,
  description: 'Descrição de $name',
  price: 9.99,
  rating: 4.5,
  thumbnail: '',
);

Widget app(Future<List<Product>> Function() fetch) =>
    MaterialApp(home: ProductListPage(service: FakeDummyJsonService(fetch)));

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
  testWidgets('card mostra nome, preço e nota', (tester) async {
    await tester.pumpWidget(cardWith(productNamed(6, 'Calvin Klein CK One')));
    await tester.pumpAndSettle();
    expect(find.text('Calvin Klein CK One'), findsOneWidget);
    expect(find.text('R\$ 9,99'), findsOneWidget);
    expect(find.text('4.5'), findsOneWidget);
    // Sem rede no teste, a foto cai no ícone do errorBuilder.
    expect(find.byIcon(Icons.image_not_supported), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('nome longo não estoura o card', (tester) async {
    await tester.pumpWidget(
      cardWith(productNamed(2, 'Nome muito comprido ' * 12)),
    );
    await tester.pumpAndSettle();
    expect(tester.widget<Text>(find.textContaining('Nome')).maxLines, 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('mostra carregando', (tester) async {
    await tester.pumpWidget(app(() => Completer<List<Product>>().future));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('mostra a vitrine', (tester) async {
    await tester.pumpWidget(
      app(
        () async => [productNamed(1, 'Red Lipstick'), productNamed(2, 'Kiwi')],
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Red Lipstick'), findsOneWidget);
    expect(find.text('Kiwi'), findsOneWidget);
    expect(find.byType(GridView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('mostra o erro', (tester) async {
    await tester.pumpWidget(
      app(() => Future<List<Product>>.error(Exception('sem internet'))),
    );
    await tester.pumpAndSettle();
    expect(find.text('Erro ao carregar os produtos'), findsOneWidget);
  });
}
