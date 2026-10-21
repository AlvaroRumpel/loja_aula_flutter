import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:loja/dummyjson_service.dart';

// runWithClient troca o http de verdade por um falso, só dentro do teste.
Future<T> withFakeApi<T>(
  Future<T> Function() body,
  Future<http.Response> Function(http.Request request) respond,
) => http.runWithClient(body, () => MockClient(respond));

void main() {
  test('fetchProducts chama a URL certa e lê a lista', () async {
    Uri? requestedUrl;
    final products = await withFakeApi(DummyJsonService().fetchProducts, (
      request,
    ) async {
      requestedUrl = request.url;
      return http.Response(
        '{"products":[{"id":6,"title":"Calvin Klein CK One","description":"","price":49.99,"rating":4.37,"thumbnail":"t"}]}',
        200,
      );
    });

    expect(requestedUrl.toString(), 'https://dummyjson.com/products');
    expect(products.single.name, 'Calvin Klein CK One');
  });

  test('fetchCategory chama a URL da categoria', () async {
    Uri? requestedUrl;
    await withFakeApi(() => DummyJsonService().fetchCategory('beauty'), (
      request,
    ) async {
      requestedUrl = request.url;
      return http.Response('{"products":[]}', 200);
    });

    expect(
      requestedUrl.toString(),
      'https://dummyjson.com/products/category/beauty',
    );
  });

  test('status diferente de 200 vira Exception', () async {
    expect(
      withFakeApi(
        DummyJsonService().fetchProducts,
        (request) async => http.Response('erro', 500),
      ),
      throwsException,
    );
  });
}
