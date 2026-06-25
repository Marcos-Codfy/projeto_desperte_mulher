// DTO da etapa do quiz — espelha o JSON cru de assets/mock/etapa_N.json.

import 'pergunta_dto.dart';

class EtapaDto {
  final int etapa;
  final int totalEtapas;
  final String titulo;
  final String subtitulo;
  final List<PerguntaDto> perguntas;

  const EtapaDto({
    required this.etapa,
    required this.totalEtapas,
    required this.titulo,
    required this.subtitulo,
    required this.perguntas,
  });

  factory EtapaDto.fromJson(Map<String, dynamic> json) {
    return EtapaDto(
      etapa: json['etapa'] as int,
      totalEtapas: json['totalEtapas'] as int,
      titulo: json['titulo'] as String,
      subtitulo: json['subtitulo'] as String,
      perguntas: (json['perguntas'] as List<dynamic>)
          .map((e) => PerguntaDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
