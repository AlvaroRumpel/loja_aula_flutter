import 'package:http/http.dart' as http;

import 'package:loja/product.dart';

// Serviço: a única classe do app que conversa com a DummyJSON.
// As telas pedem os dados para ele e não sabem nada de URL, HTTP ou JSON.
class DummyJsonService {
  // Busca os produtos da vitrine (a API devolve 30 por padrão).
  Future<List<Product>> fetchProducts() => _get('/products');

  // Busca pelo texto, ex.: /products/search?q=phone
  // encodeQueryComponent deixa espaço e acento num formato que a URL aceita.
  Future<List<Product>> searchProducts(String query) =>
      _get('/products/search?q=${Uri.encodeQueryComponent(query)}');

  // GET usado por todos os métodos: checa o status num lugar só.
  // async/await: "await" espera a resposta chegar sem travar a tela.
  Future<List<Product>> _get(String path) async {
    final url = Uri.parse('https://dummyjson.com$path');
    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('A API respondeu ${response.statusCode}');
    }
    return productsFromJson(response.body);
  }
}
