// Fachada que escolhe entre a implementação real (web) e o stub
// não-web (testes Flutter, dart analyze sem alvo web).
//
// O Dart resolve esse import condicional em tempo de compilação:
//   - Se o ambiente alvo tem `dart:js_interop` → usa browser_helpers_web.dart
//   - Se não tem (VM, testes) → usa browser_helpers_stub.dart
//
// Quem importa, importa apenas este arquivo. As funções `sairRapido`,
// `ligarPara`, `abrirExternoEmNovaAba` são iguais nos dois lados.

export 'browser_helpers_stub.dart'
    if (dart.library.js_interop) 'browser_helpers_web.dart';
