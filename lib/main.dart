import 'package:flutter/material.dart';

import 'package:loja/dummyjson_service.dart';
import 'package:loja/product_list_page.dart';

void main() => runApp(const StoreApp());

// Tudo no Flutter é widget: o app, a tela, o texto e até o espaçamento.
// Por isso o app inteiro começa com uma classe "widget" como esta.
class StoreApp extends StatelessWidget {
  const StoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minha Loja',
      debugShowCheckedModeBanner: false,
      // Tema: define as cores e o estilo de todo o app de uma vez só.
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFFE8572A),
        scaffoldBackgroundColor: const Color(0xFFFFF8F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE8572A),
          foregroundColor: Colors.white,
        ),
      ),
      // A primeira tela do app. Ela recebe o serviço que busca os produtos.
      home: ProductListPage(service: DummyJsonService()),
    );
  }
}
