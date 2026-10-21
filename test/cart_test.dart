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

  test('menos tira uma unidade só daquele produto', () {
    const apple = Product(
      id: 16,
      name: 'Apple',
      description: '',
      price: 1.99,
      rating: 4,
      thumbnail: '',
    );
    addToCart(kiwi);
    addToCart(apple);
    addToCart(kiwi);
    removeOneFromCart(kiwi);
    expect(cart.value.map((p) => p.id), [30, 16]);
    expect(uniqueProducts(cart.value).map((p) => p.id), [30, 16]);
    expect(quantityOf([kiwi, apple, kiwi], kiwi), 2);
  });
}
