/// Constantes de rotas da aplicação.
/// Centralizar como `static const String` permite que o IDE auto-complete,
/// que renomeações sejam seguras e que typos virem erro de compilação
/// em vez de "página em branco" em runtime.
///
/// Estilo seguido: estilo Silvano Malfatti (template `quiz_flutter`).
class AppRotas {
  AppRotas._();

  static const String home = '/';
  static const String sobre = '/sobre';
  static const String analise = '/analise';
  static const String apoios = '/apoios';
  static const String termos = '/termos';
  static const String falar = '/falar';
  static const String avaliacao = '/avaliacao';
  static const String resultado = '/resultado';
  static const String naoEncontrada = '/404';
}
