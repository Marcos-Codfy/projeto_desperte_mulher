// Tela "O que é AR PAX" — explica a metodologia em linguagem acessível.

import 'package:flutter/material.dart';

import 'package:desperte_mulher/common/app_dimensions.dart';
import 'package:desperte_mulher/common/app_theme.dart';
import 'package:desperte_mulher/presentation/widgets/layout/scaffold_acolhedor.dart';
import 'package:desperte_mulher/presentation/widgets/textos/textos.dart';

class AnalisePage extends StatelessWidget {
  const AnalisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldAcolhedor(
      conteudo: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TituloH1('O que é a *AR PAX*'),
          const SizedBox(height: AppDimensoes.e16),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppDimensoes.larguraMaximaTexto,
            ),
            child: const Paragrafo(
              'A Análise de Risco PAX é uma metodologia científica para '
              'transformar respostas a um questionário em uma estimativa '
              'objetiva de risco. Foi desenvolvida por Felipe Scarpelli '
              'de Andrade e publicada em 2024 na Revista Brasileira de '
              'Ciências Policiais.',
              grande: true,
            ),
          ),
          const SizedBox(height: AppDimensoes.e32),
          const TituloH2('Por que isso é diferente'),
          const SizedBox(height: AppDimensoes.e16),
          const _BlocoExplicativo(
            titulo: 'Risco = Vulnerabilidade × Ameaça',
            texto:
                'O método separa duas coisas: quanto a vítima está '
                'suscetível (Vulnerabilidade) e quanto o agressor tende '
                'a concretizar (Ameaça). Antes do AR PAX, isso era '
                'tratado como uma coisa só — perdia-se nuance.',
          ),
          SizedBox(height: AppDimensoes.e16),
          const _BlocoExplicativo(
            titulo: 'Seis critérios',
            texto:
                'Cada dimensão se decompõe em três critérios:\n\n'
                '• Vulnerabilidade: Atratibilidade, Exposição e Casuística\n'
                '• Ameaça: Motivação, Histórico e Tendência\n\n'
                'Os pesos vêm do trabalho de Andrade (2017, 2019) e foram '
                'validados teoricamente no artigo de Scarpelli (2024).',
          ),
          SizedBox(height: AppDimensoes.e16),
          const _BlocoExplicativo(
            titulo: 'Escala de 5 níveis',
            texto:
                'Cada critério é classificado em cinco níveis (Muito '
                'Baixa, Baixa, Média, Alta, Muito Alta). Escalas binárias '
                '(Sim/Não) perderiam informação. A escala de 5 níveis é '
                'padrão clássico de Likert em ciências sociais.',
          ),
          SizedBox(height: AppDimensoes.e16),
          const _BlocoExplicativo(
            titulo: 'Matriz 5×5',
            texto:
                'Os níveis de Vulnerabilidade e Ameaça se cruzam em uma '
                'matriz com 25 células, que devolve o grau final de risco: '
                'Muito Baixo, Baixo, Moderado, Alto ou Extremo.',
          ),
          const SizedBox(height: AppDimensoes.e32),
          const TituloH2('Como nossa plataforma faz isso'),
          const SizedBox(height: AppDimensoes.e16),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppDimensoes.larguraMaximaTexto,
            ),
            child: const Paragrafo(
              'As 27 perguntas do FONAR, instituídas pela Resolução '
              'Conjunta nº 5/2020 do CNJ e CNMP, são apresentadas em 5 '
              'etapas. Cada resposta positiva soma pontos nos critérios '
              'apropriados. No final, o motor matemático devolve o grau '
              'classificado de acordo com os Quadros 7 e 8 do artigo '
              'original.\n\n'
              'O cálculo acontece no seu próprio navegador. Nada é '
              'enviado para servidor algum. Quando você fecha a aba, '
              'tudo se apaga.',
            ),
          ),
          const SizedBox(height: AppDimensoes.e32),
        ],
      ),
    );
  }
}

class _BlocoExplicativo extends StatelessWidget {
  final String titulo;
  final String texto;
  const _BlocoExplicativo({required this.titulo, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensoes.e16),
      decoration: BoxDecoration(
        color: AppCores.primariaFundo,
        borderRadius: BorderRadius.circular(AppDimensoes.raioMedio),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TituloH3(titulo),
          const SizedBox(height: AppDimensoes.e8),
          Paragrafo(texto),
        ],
      ),
    );
  }
}
