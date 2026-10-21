import 'package:flutter_test/flutter_test.dart';
import 'package:loja/product.dart';

void main() {
  test('preço com vírgula e R\$', () {
    expect(formatPrice(9.99), 'R\$ 9,99');
    expect(formatPrice(1999.99), 'R\$ 1999,99');
    expect(formatPrice(10), 'R\$ 10,00');
    expect(formatPrice(0.5), 'R\$ 0,50');
  });
}
