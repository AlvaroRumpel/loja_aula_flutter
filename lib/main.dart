import 'package:flutter/material.dart';

import 'package:loja/brand.dart';
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
      title: brandName,
      debugShowCheckedModeBanner: false,
      // Tema: define as cores e o estilo de todo o app de uma vez só.
      // O fundo das telas sai da cor da marca, bem clarinho.
      theme: ThemeData(
        colorSchemeSeed: brandColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: brandColor,
          foregroundColor: Colors.white,
        ),
      ),
      // A primeira tela do app. Ela recebe o serviço que busca os produtos.
      home: ProductListPage(service: DummyJsonService()),
    );
  }
}
