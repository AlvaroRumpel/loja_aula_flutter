import 'package:flutter_test/flutter_test.dart';

import 'package:loja/main.dart';

void main() {
  testWidgets('mostra título Minha Loja e saudação', (tester) async {
    await tester.pumpWidget(const StoreApp());
    expect(find.text('Minha Loja'), findsOneWidget);
    expect(find.text('Olá, Flutter!'), findsOneWidget);
  });
}
