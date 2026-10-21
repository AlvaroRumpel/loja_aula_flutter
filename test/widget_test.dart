import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:loja/cart.dart';
import 'package:loja/dummyjson_service.dart';
import 'package:loja/product.dart';
import 'package:loja/product_detail_page.dart';
import 'package:loja/product_list_page.dart';

// Serviço falso: devolve o que o teste mandar, sem internet.
class FakeDummyJsonService extends DummyJsonService {
  FakeDummyJsonService(this.onFetchProducts);

  final Future<List<Product>> Function() onFetchProducts;
  String? requestedCategory; // última categoria pedida

  @override
  Future<List<Product>> fetchProducts() => onFetchProducts();

  @override
  Future<List<Product>> fetchCategory(String category) async {
    requestedCategory = category;
    return [productNamed(1, 'Mascara')];
  }
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
  // O carrinho é global: cada teste começa com ele vazio.
  setUp(() => cart.value = []);

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

  testWidgets('detalhe mostra dados', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: ProductDetailPage(product: productNamed(1, 'Kiwi'))),
    );
    await tester.pumpAndSettle();
    expect(find.text('Kiwi'), findsOneWidget); // na AppBar
    expect(find.text('Adicionar ao carrinho'), findsOneWidget);
    expect(find.text('R\$ 9,99'), findsOneWidget);
    expect(find.text('Descrição de Kiwi'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tocar no card abre detalhe', (tester) async {
    await tester.pumpWidget(app(() async => [productNamed(1, 'Kiwi')]));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kiwi'));
    await tester.pumpAndSettle();
    expect(find.byType(ProductDetailPage), findsOneWidget);
  });

  testWidgets('adicionar no detalhe sobe o contador', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: ProductDetailPage(product: productNamed(1, 'Kiwi'))),
    );
    expect(find.text('0'), findsOneWidget);
    await tester.tap(find.text('Adicionar ao carrinho'));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('carrinho mostra itens e total', (tester) async {
    addToCart(productNamed(1, 'Kiwi'));
    addToCart(productNamed(2, 'Apple'));
    await tester.pumpWidget(const MaterialApp(home: CartPage()));
    expect(find.text('Kiwi'), findsOneWidget);
    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('Total: R\$ 19,98'), findsOneWidget);
  });

  testWidgets('carrinho vazio', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CartPage()));
    expect(find.text('Seu carrinho está vazio'), findsOneWidget);
    expect(find.text('Total: R\$ 0,00'), findsOneWidget);
  });

  testWidgets('ícone do carrinho abre a tela do carrinho', (tester) async {
    await tester.pumpWidget(app(() async => [productNamed(1, 'Kiwi')]));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(CartButton));
    await tester.pumpAndSettle();
    expect(find.byType(CartPage), findsOneWidget);
  });

  testWidgets('chip de categoria mostra só a categoria', (tester) async {
    final service = FakeDummyJsonService(() async => [productNamed(2, 'Kiwi')]);
    await tester.pumpWidget(
      MaterialApp(home: ProductListPage(service: service)),
    );
    await tester.pumpAndSettle();
    expect(find.text('Kiwi'), findsOneWidget);

    await tester.tap(find.text('beauty'));
    await tester.pumpAndSettle();
    expect(service.requestedCategory, 'beauty');
    expect(find.text('Mascara'), findsOneWidget);
    expect(find.text('Kiwi'), findsNothing);
  });

  testWidgets('mesmo produto vira uma linha com quantidade', (tester) async {
    addToCart(productNamed(1, 'Kiwi'));
    addToCart(productNamed(1, 'Kiwi'));
    await tester.pumpWidget(const MaterialApp(home: CartPage()));
    expect(find.text('Kiwi'), findsOneWidget);
    expect(find.text('2× R\$ 9,99'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('3× R\$ 9,99'), findsOneWidget);
    expect(find.text('Total: R\$ 29,97'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.remove));
    await tester.tap(find.byIcon(Icons.remove));
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();
    expect(find.text('Seu carrinho está vazio'), findsOneWidget);
  });
}
