# Minha Loja: aula de Flutter

App de loja feito durante uma aula de introdução ao Flutter. A primeira tela é uma vitrine com produtos vindos da internet. Tocando num produto, abre o detalhe, e dali dá para colocar o produto no carrinho, que mostra o total.

## Requisitos

- Flutter 3.32 ou mais novo (Dart 3.8+) para as etapas 1 a 5.
- A etapa 0 é a saída pura do `flutter create` e precisa de Flutter 3.47+.
- Confira com `flutter --version` nas máquinas antes da aula.

## Como rodar

```bash
flutter pub get
flutter run -d chrome
```

## Etapas (branches)

Cada branch parte da anterior. Se você se perder, troque para a branch da etapa atual.

| Branch | O que você aprende |
|---|---|
| `etapa-0-projeto-base` | Projeto criado e rodando no Chrome |
| `etapa-1-primeiro-widget` | `StatelessWidget`, hot reload, mudar texto e cor |
| `etapa-2-card-produto` | Classe `Product` e um card com dados fixos |
| `etapa-3-vitrine-api` | Pacote `http`, serviço `DummyJsonService`, `FutureBuilder` e grade com dados reais |
| `etapa-4-tela-detalhe` | `Navigator.push` e a tela de detalhe do produto |
| `etapa-5-carrinho` | `ValueNotifier`, contador no ícone e carrinho com total |
| `main` | Versão final do app |

Para trocar de etapa:

```bash
git checkout <branch-da-etapa>
```

## Links úteis

- Documentação do Flutter: https://docs.flutter.dev
- API de produtos (DummyJSON): https://dummyjson.com
- Testar código Dart no navegador: https://dartpad.dev
