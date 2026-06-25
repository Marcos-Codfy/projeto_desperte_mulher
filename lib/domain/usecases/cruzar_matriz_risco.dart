// Cruza Nível de Vulnerabilidade × Nível de Ameaça → Grau de Risco final.
//
// FONTE: Quadro 8 do artigo de Scarpelli et al. (2024).
//
// Matriz literal (mantida em texto para revisão visual):
//
//                  Insign.  Pequena  Moderada  Signif.  Extrema
// Muito Baixa        MB       MB       BA        AL       AL
// Baixa              MB       BA       MO        AL       AL
// Média              BA       BA       MO        EX       EX
// Alta               BA       MO       AL        EX       EX
// Muito Alta         MO       MO       AL        EX       EX

import '../entities/grau_risco.dart';
import '../entities/nivel_dimensao.dart';

/// Mapa estático com os 25 cruzamentos da matriz oficial 5×5.
const Map<NivelVulnerabilidade, Map<NivelAmeaca, GrauRisco>> _matriz = {
  NivelVulnerabilidade.muitoBaixa: {
    NivelAmeaca.insignificante: GrauRisco.muitoBaixo,
    NivelAmeaca.pequena: GrauRisco.muitoBaixo,
    NivelAmeaca.moderada: GrauRisco.baixo,
    NivelAmeaca.significante: GrauRisco.alto,
    NivelAmeaca.extrema: GrauRisco.alto,
  },
  NivelVulnerabilidade.baixa: {
    NivelAmeaca.insignificante: GrauRisco.muitoBaixo,
    NivelAmeaca.pequena: GrauRisco.baixo,
    NivelAmeaca.moderada: GrauRisco.moderado,
    NivelAmeaca.significante: GrauRisco.alto,
    NivelAmeaca.extrema: GrauRisco.alto,
  },
  NivelVulnerabilidade.media: {
    NivelAmeaca.insignificante: GrauRisco.baixo,
    NivelAmeaca.pequena: GrauRisco.baixo,
    NivelAmeaca.moderada: GrauRisco.moderado,
    NivelAmeaca.significante: GrauRisco.extremo,
    NivelAmeaca.extrema: GrauRisco.extremo,
  },
  NivelVulnerabilidade.alta: {
    NivelAmeaca.insignificante: GrauRisco.baixo,
    NivelAmeaca.pequena: GrauRisco.moderado,
    NivelAmeaca.moderada: GrauRisco.alto,
    NivelAmeaca.significante: GrauRisco.extremo,
    NivelAmeaca.extrema: GrauRisco.extremo,
  },
  NivelVulnerabilidade.muitoAlta: {
    NivelAmeaca.insignificante: GrauRisco.moderado,
    NivelAmeaca.pequena: GrauRisco.moderado,
    NivelAmeaca.moderada: GrauRisco.alto,
    NivelAmeaca.significante: GrauRisco.extremo,
    NivelAmeaca.extrema: GrauRisco.extremo,
  },
};

/// Cruza Vulnerabilidade × Ameaça e devolve o Grau de Risco final.
///
/// Todos os 25 cruzamentos estão definidos — não há fallback.
/// Se algum dia o `_matriz` ficar incompleto, o `!` aqui faz quebrar
/// na hora (preferível a esconder um bug científico).
GrauRisco cruzarMatriz(NivelVulnerabilidade v, NivelAmeaca a) {
  return _matriz[v]![a]!;
}
