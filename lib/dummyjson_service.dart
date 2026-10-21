import 'package:http/http.dart' as http;

import 'package:loja/product.dart';

// Serviço: a única classe do app que conversa com a DummyJSON.
// As telas pedem os dados para ele e não sabem nada de URL, HTTP ou JSON.
class DummyJsonService {
  // Busca os produtos da vitrine (a API devolve 30 por padrão).
  Future<List<Product>> fetchProducts() => _get('/products');

  // Só os produtos de uma categoria, ex.: /products/category/beauty
  Future<List<Product>> fetchCategory(String category) =>
      _get('/products/category/$category');

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
