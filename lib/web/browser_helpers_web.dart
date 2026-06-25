// Implementação real (web) dos helpers do navegador.
// Use sempre via lib/web/browser_helpers.dart — ele faz o conditional
// import correto entre esta versão e o stub não-web.

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
void ligarPara(String numero) {
  final limpo = numero.replaceAll(RegExp(r'[^\d+]'), '');
  _locationReplace('tel:$limpo');
}

/// Abre uma URL externa em nova aba.
void abrirExternoEmNovaAba(String url) {
  _windowOpen(url, '_blank');
}
