import 'package:flutter/material.dart';

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
      home: Scaffold(
        appBar: AppBar(title: const Text('Minha Loja')),
        // Dica: com "flutter run", salve o arquivo e aperte "r" (hot reload)
        // para ver a mudança na hora, sem reiniciar o app.
        body: const Center(
          child: Text('Olá, Flutter!', style: TextStyle(fontSize: 24)),
        ),
      ),
    );
  }
}
