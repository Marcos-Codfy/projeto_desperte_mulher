// TODAS as strings da UI vivem aqui — em PT-BR.
//
// Por quê:
//   1. Prepara multi-idioma futuro (basta trocar este arquivo).
//   2. Permite revisão de microcopy pelo Davi/Felipe sem abrir 10 telas.
//   3. Aplica de uma vez as reescritas acolhedoras planejadas em §5.5.
//
// Princípio de microcopy: se a frase soa como aviso de banco, está errada.
// Se soa como bilhete de uma amiga em quem ela confia, está certa.

class AppStrings {
  AppStrings._();

  // ── App ───────────────────────────────────────────────────────────────
  static const String tituloApp = 'Site';
  static const String nomeProduto = 'Desperte Mulher';

  // ── Header / navegação ────────────────────────────────────────────────
  static const String navHome = 'Início';
  static const String navSobre = 'Sobre';
  static const String navAnalise = 'O que é AR PAX';
  static const String navApoios = 'Apoios';
  static const String navFalar = 'Falar com a rede';
  static const String saidaRapida = 'Sair';
  static const String saidaRapidaTooltip =
      'Sair do site rapidamente para uma página neutra';

  // ── Home ──────────────────────────────────────────────────────────────
  // Marcador *palavra* indica trecho que vai ser pintado com ênfase
  // itálica lavanda (renderizado pelo widget de texto).
  static const String homeHeroTitulo =
      'Conhecimento é o primeiro passo para a *liberdade*';
  static const String homeHeroSubtitulo =
      'Você não precisa ter certeza de nada para começar. '
      'Aqui você decide o ritmo, sem julgamentos.';
  static const String homeCTA = 'Quero me avaliar';
  static const String homeBadgeAnonimo = '100% anônimo';
  static const String homeBadgeGratuito = 'Gratuito';
  static const String homeBadgeCientifico = 'Base científica';
  static const String homePorQueImportaTitulo = 'Por que isso importa';
  static const String homeCard1Titulo = 'O que é a AR PAX';
  static const String homeCard1Texto =
      'Uma metodologia científica, validada pelo TJ-TO, que transforma '
      'as 27 perguntas oficiais do FONAR em um grau de risco objetivo.';
  static const String homeCard2Titulo = 'Quem está por trás';
  static const String homeCard2Texto =
      'A plataforma é apoiada por CNJ, CNMP, Secretaria da Mulher, '
      'Polícia Civil, Patrulha Maria da Penha, OAB-TO, entre outros.';
  static const String homeCard3Titulo = 'Como usar com segurança';
  static const String homeCard3Texto =
      'Suas respostas ficam só com você. Sugerimos usar uma aba '
      'anônima do navegador. Há um botão "Sair" sempre à mão.';

  // ── Termos ────────────────────────────────────────────────────────────
  static const String termosTitulo = 'Antes de começar';
  static const String termosSubtitulo =
      'Esta avaliação é um cuidado seu com você. Quando quiser '
      'conversar com alguém da rede de apoio, estaremos aqui.';
  static const String termosCorpo = '''
Esta plataforma é uma ferramenta de autoavaliação baseada na metodologia AR PAX (Análise de Risco PAX), publicada na Revista Brasileira de Ciências Policiais e adotada pelo Tribunal de Justiça do Tocantins.

As perguntas a seguir são as 27 perguntas oficiais do FONAR — Formulário Nacional de Avaliação de Risco — instituído pela Resolução Conjunta nº 5/2020 do CNJ e do CNMP.

O que você precisa saber:

• Suas respostas ficam apenas no seu navegador. Nada é enviado para nenhum servidor.
• Se você fechar esta aba, tudo é apagado.
• O resultado é uma orientação — não substitui acompanhamento de profissionais.
• Você pode sair a qualquer momento clicando no botão "Sair" no topo.

Você não precisa responder tudo de uma vez. Não há prazos. Não há julgamentos.''';
  static const String termosBotaoVoltar = 'Tenho dúvidas — quero ler com calma';
  static const String termosBotaoContinuar = 'Compreendi — quero continuar';

  // ── Avaliação ─────────────────────────────────────────────────────────
  static const String avaliacaoCarregando = 'Carregando…';
  static const String avaliacaoEtapaLabel = 'Etapa';
  static const String avaliacaoDe = 'de';
  static const String avaliacaoVoltar = 'Voltar';
  static const String avaliacaoProximo = 'Próximo';
  static const String avaliacaoVerResultado = 'Ver resultado';
  static const String avaliacaoMedidorTexto =
      'Você está construindo seu mapa de segurança.';
  static const String avaliacaoErroFaltam =
      'Quando estiver pronta, escolha uma opção para continuar.';
  static const String avaliacaoEntreEtapas =
      'Você está indo bem. Se precisar pausar, é só fechar a página.';

  // ── Resultado ─────────────────────────────────────────────────────────
  static const String resultadoTitulo = 'Você concluiu sua avaliação.';
  static const String resultadoSubtitulo = 'Aqui está o que ela mostra:';
  static const String resultadoVulnerabilidadeLabel = 'Vulnerabilidade';
  static const String resultadoAmeacaLabel = 'Ameaça';
  static const String resultadoProximosPassosTitulo = 'Próximos passos';
  static const String resultadoCTAFalar = 'Falar com a rede de apoio';
  static const String resultadoCTAApoios = 'Conhecer parceiros';
  static const String resultadoRefazer = 'Refazer a avaliação';
  static const String resultadoNenhumResultadoTitulo =
      'Nenhuma avaliação encontrada';
  static const String resultadoNenhumResultadoTexto =
      'Parece que você chegou aqui sem ter respondido a avaliação. '
      'Você pode começar a qualquer momento.';

  // ── Footer ────────────────────────────────────────────────────────────
  static const String footerEmergenciaTitulo = 'Em emergência, ligue:';
  static const String footer180 = '180 — Central de Atendimento à Mulher';
  static const String footer190 = '190 — Polícia Militar';
  static const String footerCreditos =
      'Metodologia AR PAX: Scarpelli, Silva & Pona (2024)';

  // ── Modais de segurança ───────────────────────────────────────────────
  static const String modalAvisoTitulo = 'Cuidado com você';
  static const String modalAvisoTexto =
      'Para mais privacidade, sugerimos usar este site em uma aba '
      'anônima do navegador.\n\n'
      'Suas respostas nunca são salvas no nosso servidor. Mas o '
      'navegador pode guardar o endereço do site no histórico — '
      'usar aba anônima evita isso.\n\n'
      'Você pode sair rapidamente a qualquer momento clicando no '
      'botão "Sair" no topo da página.';
  static const String modalAvisoBotao = 'Entendi, vamos lá';

  static const String modalSaidaTitulo = 'Sair agora?';
  static const String modalSaidaTexto =
      'Suas respostas serão apagadas e você será levada para uma '
      'página neutra. Você pode voltar quando quiser.';
  static const String modalSaidaConfirmar = 'Sim, sair agora';
  static const String modalSaidaCancelar = 'Cancelar';

  // ── 404 ───────────────────────────────────────────────────────────────
  static const String paginaNaoEncontradaTitulo = 'Página não encontrada';
  static const String paginaNaoEncontradaTexto =
      'Parece que esse endereço não existe mais. Você pode voltar '
      'para o início e tentar de novo.';
  static const String paginaNaoEncontradaBotao = 'Voltar para o início';
}
