import 'package:flutter_test/flutter_test.dart';
import 'package:loja/product.dart';

void main() {
  test('preço com vírgula e R\$', () {
    expect(formatPrice(9.99), 'R\$ 9,99');
    expect(formatPrice(1999.99), 'R\$ 1999,99');
    expect(formatPrice(10), 'R\$ 10,00');
    expect(formatPrice(0.5), 'R\$ 0,50');
  });

  test('fromJson lê os campos da DummyJSON', () {
    final p = Product.fromJson(ckOneJson);
    expect(p.id, 6);
    expect(p.name, 'Calvin Klein CK One');
    expect(p.price, 49.99);
    expect(p.rating, 4.37);
    expect(p.thumbnail, 'https://cdn.dummyjson.com/ck/thumbnail.webp');
  });

  test('preço e nota inteiros viram double', () {
    final p = Product.fromJson({...ckOneJson, 'price': 10, 'rating': 5});
    expect(p.price, 10.0);
    expect(p.rating, 5.0);
  });

  test('productsFromJson lê products', () {
    const body =
        '{"products":[{"id":1,"title":"A","description":"","price":1,"rating":1,"thumbnail":"t"},'
        '{"id":2,"title":"B","description":"","price":2.5,"rating":3,"thumbnail":"t"}],'
        '"total":194,"skip":0,"limit":30}';
    final list = productsFromJson(body);
    expect(list.length, 2);
    expect(list[1].name, 'B');
  });
}

const ckOneJson = {
  'id': 6,
  'title': 'Calvin Klein CK One',
  'description': 'CK One by Calvin Klein is a classic unisex fragrance.',
  'price': 49.99,
  'rating': 4.37,
  'thumbnail': 'https://cdn.dummyjson.com/ck/thumbnail.webp',
};
