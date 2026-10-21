import 'package:flutter_test/flutter_test.dart';

import 'package:loja/cart.dart';
import 'package:loja/product.dart';

const kiwi = Product(
  id: 30,
  name: 'Kiwi',
  description: '',
  price: 2.49,
  rating: 4,
  thumbnail: '',
);

void main() {
  // O carrinho é global: cada teste começa com ele vazio.
  setUp(() => cart.value = []);

  test('mesmo produto duas vezes vira dois itens', () {
    addToCart(kiwi);
    addToCart(kiwi);
    expect(cart.value.length, 2);
  });

  test('adicionar avisa quem está escutando', () {
    var calls = 0;
    cart.addListener(() => calls++);
    addToCart(kiwi);
    expect(calls, 1);
  });
}
