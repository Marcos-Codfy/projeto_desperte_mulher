// Stub das funções do browser_helpers para plataformas que NÃO são web
// (testes Flutter, ferramentas como dart analyze sem alvo web).
//
// Cada função vira no-op com um debugPrint. Nenhum efeito colateral
// real acontece — então testes podem chamar essas funções sem crash.
//
// Em produção (web), o conditional export em browser_helpers.dart
// usa browser_helpers_web.dart no lugar deste arquivo.

import 'package:flutter/foundation.dart';

void sairRapido() {
  debugPrint('[stub] sairRapido — sem efeito (não-web)');
}

void ligarPara(String numero) {
  debugPrint('[stub] ligarPara($numero) — sem efeito (não-web)');
}

void abrirExternoEmNovaAba(String url) {
  debugPrint('[stub] abrirExternoEmNovaAba($url) — sem efeito (não-web)');
}
