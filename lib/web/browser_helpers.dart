// Helpers do navegador via dart:js_interop.
//
// Usados para:
//   1. Sair rapidamente (Fase 6): limpa storage e redireciona pra google.com
//   2. Abrir um número de telefone em deeplink `tel:` (FalarPage)
//   3. Abrir uma URL externa em nova aba
//
// Como é dart:js_interop, este arquivo só funciona em ambientes Web.
// Em testes unitários, não importe direto — use o callback.

import 'dart:js_interop';

@JS('window.location.replace')
external void _locationReplace(String url);

@JS('window.history.replaceState')
external void _historyReplaceState(JSAny? data, String unused, String url);

@JS('window.sessionStorage.clear')
external void _sessionStorageClear();

@JS('window.open')
external void _windowOpen(String url, String target);

/// Saída rápida: limpa sessionStorage, sobrescreve URL atual no histórico
/// (para que o "voltar" do navegador não traga a usuária de volta), e
/// redireciona para google.com via `window.location.replace` (que
/// substitui em vez de empilhar).
void sairRapido() {
  _historyReplaceState(null, '', '/');
  try {
    _sessionStorageClear();
  } catch (_) {
    // sessionStorage pode estar bloqueado em modo private — ignoramos.
  }
  _locationReplace('https://www.google.com');
}

/// Abre um número de telefone como deeplink (`tel:`).
/// No celular, dispara o discador. No desktop, comportamento depende
/// do navegador e do app default.
void ligarPara(String numero) {
  // Remove caracteres não-numéricos para evitar quebras.
  final limpo = numero.replaceAll(RegExp(r'[^\d+]'), '');
  _locationReplace('tel:$limpo');
}

/// Abre uma URL externa em nova aba. Para os "Conhecer mais" da home etc.
void abrirExternoEmNovaAba(String url) {
  _windowOpen(url, '_blank');
}
