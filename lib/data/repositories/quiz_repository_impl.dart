// Implementação concreta do QuizRepository (contrato definido em domain/).
//
// Pega DTOs do datasource e devolve Entities para o domain — quem chama
// nunca toca em DTO.

import 'package:desperte_mulher/data/datasources/quiz_local_datasource.dart';
import 'package:desperte_mulher/data/mappers/pergunta_mapper.dart';
import 'package:desperte_mulher/domain/repositories/quiz_repository.dart';

class QuizRepositoryImpl implements QuizRepository {
  const QuizRepositoryImpl({QuizLocalDataSource? datasource})
      : _datasource = datasource ?? const QuizLocalDataSource();

  final QuizLocalDataSource _datasource;

  @override
  Future<EtapaQuiz> carregarEtapa(int numeroEtapa) async {
    final dto = await _datasource.carregarEtapa(numeroEtapa);
    return PerguntaMapper.etapaFromDto(dto);
  }

  @override
  Future<List<EtapaQuiz>> carregarTodas() async {
    final futures = List.generate(5, (i) => carregarEtapa(i + 1));
    return Future.wait(futures);
  }
}
