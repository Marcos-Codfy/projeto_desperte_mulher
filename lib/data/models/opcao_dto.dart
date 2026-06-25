// DTO da opção de resposta — espelha o JSON cru da etapa.
// Esta camada existe para isolar mudanças de formato do JSON: se o backend
// Django amanhã usar snake_case, só o mapper muda; o domain segue intacto.

class OpcaoDto {
  final String texto;
  final bool ehNegativa;
  final bool requerInputAdicional;

  const OpcaoDto({
    required this.texto,
    this.ehNegativa = false,
    this.requerInputAdicional = false,
  });

  factory OpcaoDto.fromJson(Map<String, dynamic> json) {
    return OpcaoDto(
      texto: json['texto'] as String,
      ehNegativa: (json['ehNegativa'] as bool?) ?? false,
      requerInputAdicional: (json['requerInputAdicional'] as bool?) ?? false,
    );
  }
}
