// DTO da pergunta — espelha o JSON cru.

import 'opcao_dto.dart';

class PerguntaDto {
  final String id;
  final String numero;
  final String texto;
  final String? textoApoio;

  /// "unica" ou "multipla" no JSON; convertido para enum no mapper.
  final String modo;

  /// Lista das chaves dos critérios alimentados (lowerCamelCase).
  /// Ex: ["exposicao", "casuistica", "historico"]
  final List<String> criteriosAlimentados;

  final List<OpcaoDto> opcoes;

  const PerguntaDto({
    required this.id,
    required this.numero,
    required this.texto,
    required this.modo,
    required this.criteriosAlimentados,
    required this.opcoes,
    this.textoApoio,
  });

  factory PerguntaDto.fromJson(Map<String, dynamic> json) {
    return PerguntaDto(
      id: json['id'] as String,
      numero: json['numero'] as String,
      texto: json['texto'] as String,
      textoApoio: json['textoApoio'] as String?,
      modo: json['modo'] as String,
      criteriosAlimentados: (json['criteriosAlimentados'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      opcoes: (json['opcoes'] as List<dynamic>)
          .map((e) => OpcaoDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
