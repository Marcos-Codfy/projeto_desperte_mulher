// Converte DTOs (forma do JSON) em Entities (forma que o domain consome).
//
// É AQUI que traduzimos:
//   - "unica" / "multipla" (string) → ModoSelecao (enum)
//   - "exposicao", "casuistica" (strings) → CriterioArpax (enum)
//   - List<OpcaoDto> → List<OpcaoResposta>
//
// Se algum dia o backend Django usar nomes diferentes (snake_case,
// inglês, etc), só esta camada muda.

import 'package:desperte_mulher/data/models/etapa_dto.dart';
import 'package:desperte_mulher/data/models/opcao_dto.dart';
import 'package:desperte_mulher/data/models/pergunta_dto.dart';
import 'package:desperte_mulher/domain/entities/criterio_arpax.dart';
import 'package:desperte_mulher/domain/entities/opcao_resposta.dart';
import 'package:desperte_mulher/domain/entities/pergunta.dart';
import 'package:desperte_mulher/domain/repositories/quiz_repository.dart';

class PerguntaMapper {
  const PerguntaMapper._();

  static OpcaoResposta opcaoFromDto(OpcaoDto dto) {
    return OpcaoResposta(
      texto: dto.texto,
      ehNegativa: dto.ehNegativa,
      requerInputAdicional: dto.requerInputAdicional,
    );
  }

  static ModoSelecao _modoFromString(String raw) {
    switch (raw) {
      case 'unica':
        return ModoSelecao.unica;
      case 'multipla':
        return ModoSelecao.multipla;
      default:
        throw FormatException('ModoSelecao desconhecido: "$raw"');
    }
  }

  static Pergunta perguntaFromDto(PerguntaDto dto) {
    final criterios = <CriterioArpax>{};
    for (final chave in dto.criteriosAlimentados) {
      final c = CriterioArpax.deString(chave);
      if (c == null) {
        throw FormatException(
          'Critério desconhecido em "${dto.id}": "$chave"',
        );
      }
      criterios.add(c);
    }
    return Pergunta(
      id: dto.id,
      numero: dto.numero,
      texto: dto.texto,
      textoApoio: dto.textoApoio,
      modo: _modoFromString(dto.modo),
      criteriosAlimentados: criterios,
      opcoes: dto.opcoes.map(opcaoFromDto).toList(growable: false),
    );
  }

  static EtapaQuiz etapaFromDto(EtapaDto dto) {
    return EtapaQuiz(
      numero: dto.etapa,
      totalEtapas: dto.totalEtapas,
      titulo: dto.titulo,
      subtitulo: dto.subtitulo,
      perguntas:
          dto.perguntas.map(perguntaFromDto).toList(growable: false),
    );
  }
}
