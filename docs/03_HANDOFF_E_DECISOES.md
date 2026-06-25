# Handoff técnico e decisões — Desperte Mulher

> **Propósito deste documento:** servir como memória institucional do
> projeto. Foi escrito DEPOIS da implementação do MVP, captura o estado
> atual do código e o **porquê** de cada escolha — para que (a) o Codfy
> possa consultar quando esquecer, (b) um chat novo (Claude, outro LLM,
> outro dev) possa abrir o projeto e continuar SEM se perder, e (c)
> Davi, Silvano, Felipe Scarpelli e jurados acadêmicos consigam auditar
> as decisões.
>
> **Última atualização:** 25/06/2026
>
> **Documentos relacionados:**
> - [`01_COMPILACAO_DADOS_PROJETO.md`](01_COMPILACAO_DADOS_PROJETO.md) — metodologia AR PAX, perguntas FONAR, equipe, contexto institucional
> - [`02_PLANEJAMENTO_FRONTEND.md`](02_PLANEJAMENTO_FRONTEND.md) — plano original com paleta, microcopy, arquitetura proposta
> - **Este arquivo (03)** — o que efetivamente foi implementado e por quê. Quando 02 e 03 divergem, **03 é a fonte de verdade.**

---

## Índice

1. [Estado atual em uma página](#1-estado-atual-em-uma-página)
2. [Linha do tempo das entregas](#2-linha-do-tempo-das-entregas)
3. [Decisões de arquitetura](#3-decisões-de-arquitetura)
4. [A saga do renderer (HTML vs CanvasKit vs Skwasm)](#4-a-saga-do-renderer)
5. [UX e UI: princípios aplicados](#5-ux-e-ui-princípios-aplicados)
6. [Segurança da vítima — mecânicas](#6-segurança-da-vítima--mecânicas)
7. [Microcopy: o "bilhete de uma amiga"](#7-microcopy-o-bilhete-de-uma-amiga)
8. [Estrutura do projeto (mapa)](#8-estrutura-do-projeto-mapa)
9. [Componentes-chave](#9-componentes-chave)
10. [O motor AR PAX em uma olhada](#10-o-motor-ar-pax-em-uma-olhada)
11. [Bugs corrigidos (causa raiz)](#11-bugs-corrigidos-causa-raiz)
12. [Regras inegociáveis](#12-regras-inegociáveis)
13. [Roadmap pós-MVP](#13-roadmap-pós-mvp)
14. [Para continuar de onde paramos](#14-para-continuar-de-onde-paramos)

---

## 1. Estado atual em uma página

| Métrica | Valor |
| --- | --- |
| Branch principal | `main` (no GitHub: `Marcos-Codfy/projeto_desperte_mulher`) |
| Linguagem | Dart 3.7+ |
| Framework | Flutter 3.41.7 (stable, abr/2026) |
| Plataforma alvo | Web (Chrome / Edge / Safari mobile) — **exclusivamente** |
| Renderer Web | CanvasKit (default obrigatório no Flutter 3.27+) |
| State management | `setState` puro |
| Persistência | **Zero** (RAM apenas — escolha de segurança da vítima) |
| Cobertura de testes | **51 testes verdes** — motor AR PAX + walkthrough do fluxo |
| Lint | `flutter analyze` → No issues found |
| Build | `flutter build web --release` builda sem erros |
| Logo principal | 84 KB (comprimida de 2.2 MB original) |
| Status | MVP completo, em revisão visual pelo Codfy |

**Fluxo principal funciona ponta-a-ponta:** Home → Termos → Avaliação (5 etapas com 30 perguntas FONAR) → Resultado. Botão "Sair" funcional em toda página + `Esc`. Cards de "Falar com a rede" abrem o discador via `tel:` deeplink.

---

## 2. Linha do tempo das entregas

Branches e commits relevantes, em ordem cronológica:

```
main
├── 9d214fe  chore: bootstrap desperte_mulher Flutter Web project
├── 4948eb1  feat(domain): AR PAX calculation engine + tests
├── b6c6ca2  feat(data): JSON mocks for 30 FONAR questions
├── 04ce816  feat(design-system): theme, tokens, strings, widgets
├── 8fbbfeb  feat(pages): Home, Termos, Avaliacao stepper, Resultado
├── 1c9b8b5  feat(pages): Sobre, Analise, Apoios, Falar + tel: helper
├── c936758  feat(security): real saída rápida + history-aware modal
├── 0187827  chore(polish): conditional js_interop, smoke tests
├── 099bdf8  fix(ui): MedidorRisco Container crash + real assets
├── 9a9e901  fix(web): remove deprecated window.flutterConfiguration
├── 8865353  docs: portfolio-grade README
└── 81bccf8  Merge: ux/mobile-first-polish
    ├── 1d71210  chore(perf): compress hero logo 2.2 MB → 84 KB
    ├── b8e8a19  feat(avaliacao): mobile-first UX polish
    ├── 7b86e46  fix(avaliacao): caring overlay 6s + Material
    ├── 4ba6815  fix(ui): exit modal overflow + SafeArea + tel: + card
    └── d2a8ad9  fix(modal): exit dialog buttons stack full-width
```

**Convenção de commits**: [Conventional Commits](https://www.conventionalcommits.org/) (`feat`, `fix`, `chore`, `docs`, `perf`) em inglês para legibilidade internacional, **código e variáveis em português** por preferência do desenvolvedor.

---

## 3. Decisões de arquitetura

### 3.1 Clean Architecture em 3 camadas

```
┌──────────────────────────────────────────┐
│  presentation/  ← Flutter (telas, widgets, controllers)
├──────────────────────────────────────────┤
│  domain/        ← Dart puro (entidades, casos de uso)
├──────────────────────────────────────────┤
│  data/          ← Fonte de dados (DTOs, mappers, repository)
└──────────────────────────────────────────┘
        ↓ depende de ↓
```

**Regra única:** as setas só apontam **para dentro**. `presentation` depende de `domain`. `data` implementa interfaces de `domain`. O `domain` **não conhece** Flutter nem JSON — é Dart puro.

**Por quê:**
- O motor AR PAX precisa ser testável em milissegundos, sem subir emulador.
- Quando o backend Django ficar pronto, troca-se apenas `data/`; o resto continua intocado.
- Separar regra de negócio de UI é boa prática que impressiona em avaliação acadêmica.

**Onde está cada camada:**
- `lib/domain/entities/` — `Pergunta`, `OpcaoResposta`, `RespostaUsuaria`, `ResultadoArpax`, `CriterioArpax` (enum com pesos e tabelas Likert), `NivelVulnerabilidade`, `NivelAmeaca`, `GrauRisco`.
- `lib/domain/usecases/` — `CalcularRiscoArpax` (motor), `cruzarMatriz`.
- `lib/domain/repositories/` — `QuizRepository` (abstract).
- `lib/data/` — `QuizLocalDataSource` (lê JSONs), DTOs, mappers, `QuizRepositoryImpl`.
- `lib/presentation/pages/`, `lib/presentation/widgets/`, `lib/presentation/pages/avaliacao/controller/`.

### 3.2 `setState` puro vs state management externo

**Escolha:** `setState` puro. Sem Provider, sem Riverpod, sem Bloc.

**Por quê:**
- Mantém o estilo do template-base do Silvano Malfatti.
- O escopo (uma tela de quiz com estado em memória) **não justifica** máquina de estado distribuída.
- Bundle menor, curva de aprendizado zero para o aluno.
- Mais fácil de auditar academicamente.

**Como o estado vive:**
- `AvaliacaoController` em `lib/presentation/pages/avaliacao/controller/avaliacao_controller.dart` carrega o estado em RAM e expõe métodos. Não estende `ChangeNotifier`.
- A `AvaliacaoPage` instancia o controller no `initState` e chama `setState(() => _controller.algo())` em cada mudança.
- **Quando trocar:** se o MVP virar produto com múltiplas telas compartilhando estado. Mas é etapa futura.

### 3.3 Mocks JSON locais vs API real

**Escolha:** JSON local em `assets/mock/etapa_1.json` … `etapa_5.json` com **delay simulado de 600 ms** dentro do `QuizLocalDataSource`.

**Por quê:**
- O backend Django está em construção paralela por outra frente.
- Queremos demonstrar o sistema completo em horas, não dias.
- Trocar pela API real depois é alterar UMA linha (instanciar `QuizRemoteDataSource` em vez de `Local`).

**Formato dos JSONs:** espelha exatamente o que o backend Django vai devolver. Schema:
```json
{
  "etapa": 1,
  "totalEtapas": 5,
  "titulo": "Sobre o histórico",
  "subtitulo": "Vamos começar...",
  "perguntas": [
    {
      "id": "P1",
      "numero": "1",
      "texto": "O(A) agressor(a) já ameaçou...",
      "textoApoio": "...",         // opcional
      "sensivel": true,             // opcional, default false
      "modo": "unica" | "multipla",
      "criteriosAlimentados": ["exposicao", "casuistica", ...],
      "opcoes": [
        { "texto": "...", "ehNegativa": false },
        ...
      ]
    }
  ]
}
```

**Importante:** o `delaySimulado` de 600 ms é proposital. Sem ele, a UI nunca renderiza o `CircularProgressIndicator` de loading e o usuário acha que "não fez nada". Em produção (API real), a latência real cumpre esse papel.

### 3.4 Sem persistência (decisão de segurança)

**Escolha:** as respostas vivem **somente em RAM**. Nada vai pra `localStorage`, `sessionStorage`, `cookies`, IndexedDB ou servidor.

**Por quê:**
- Sigilo da vítima. Se ela fecha o navegador, tudo é apagado — protege contra agressor que pegue o celular dela e abra de novo o site.
- O template-base do Silvano usa `shared_preferences` para login, mas **para o quiz isso é antipattern de segurança**.

**Como o usuário sabe disso:**
- Página de Termos diz: *"Suas respostas ficam apenas no seu navegador. Nada é enviado para nenhum servidor. Se você fechar esta aba, tudo é apagado."*
- O `AvisoHistoricoModal` no primeiro acesso reforça o uso de aba anônima.

### 3.5 Conditional import para `dart:js_interop`

**Problema:** funções como `sairRapido()`, `ligarPara()` usam `dart:js_interop`, que **só existe em alvo web**. Em testes (`flutter test`) o alvo é VM, e o import quebra.

**Solução:** conditional import em `lib/web/browser_helpers.dart`:
```dart
export 'browser_helpers_stub.dart'
    if (dart.library.js_interop) 'browser_helpers_web.dart';
```
- `browser_helpers_web.dart` → implementação real (usa `dart:js_interop`).
- `browser_helpers_stub.dart` → stub que só dá `debugPrint` (usado em testes).

**Resultado:** os 51 testes rodam sem precisar de Chrome headless, e em produção a versão real é usada.

---

## 4. A saga do renderer

Esta é a história mais importante de "decisão técnica forçada por realidade externa". Se for perguntado em apresentação, conte assim:

### 4.1 O plano original

O [`02_PLANEJAMENTO_FRONTEND.md`](02_PLANEJAMENTO_FRONTEND.md) §2.2 pediu **HTML renderer**. A justificativa era forte:

- **Acessibilidade WCAG:** o HTML renderer traduz cada widget Flutter em DOM real (`<div>`, `<button>`, `<span>`). Leitores de tela e contraste do navegador funcionam de verdade.
- **VLibras** (avatar de Libras do governo brasileiro): só funciona com DOM.
- **SEO:** Google indexa o texto. A vítima encontra o site quando pesquisar em pânico.
- **Tamanho menor:** sem o motor CanvasKit de ~2 MB pra baixar antes da primeira renderização.

E na primeira tentativa nosso `web/index.html` tinha:
```html
<script>
  window.flutterConfiguration = { renderer: "html" };
</script>
```

### 4.2 O que mudou em Flutter 3.27+

**A Google removeu o HTML renderer.** A partir de Flutter 3.27, só restaram CanvasKit e Skwasm (WebAssembly). A flag `--web-renderer` foi removida do CLI.

Pior: o novo `flutter_bootstrap.js` **detecta** a presença do `window.flutterConfiguration` legado e **lança assertion fatal**:

```
Error: Assertion failed: configuration.dart:172:9
!_usedLegacyConfigStyle
"Use engineInitializer.initializeEngine(config) only..."
```

Resultado: tela branca no boot, sem erro visível pro usuário comum.

### 4.3 Decisão final

Removi o `window.flutterConfiguration` do `web/index.html` (commit `9a9e901`) e deixei um comentário longo explicando:

```html
<!-- NOTA TÉCNICA — RENDERER DO FLUTTER WEB
     O HTML renderer foi descontinuado no Flutter 3.27+.
     CanvasKit é o único caminho atual.
     Trade-offs:
       - SEO: páginas não são indexáveis (texto é pixel no canvas)
       - VLibras: precisa ser plugado via JS por fora; precisa testar
       - Screen readers: o SemanticsBinding nativo do Flutter ainda
         atende WCAG para a maioria dos leitores
-->
```

**O que isso significa para o projeto:**
- Acessibilidade ainda funciona via overlay semântico do Flutter (`Semantics` widget).
- SEO está prejudicado — mitigamos com `<meta name="description">` no `index.html` e o título da aba (que é "Site" por segurança da vítima, não importa pro SEO).
- VLibras está como **slot comentado** no `index.html` — precisa testar quando o Davi/Silvano aprovarem ativar.

**Como contar na apresentação:** "O plano original era HTML renderer, mas Flutter 3.27 removeu. Adaptamos pra CanvasKit mantendo a acessibilidade via SemanticsBinding."

---

## 5. UX e UI: princípios aplicados

### 5.1 Mobile-first real

**Premissa:** a vítima provavelmente acessa pelo celular, possivelmente em rede 3G, possivelmente em situação de tensão. O ponto de partida do design é o smartphone **mais limitado** (375×812 px), não o desktop.

**Aplicações concretas:**
- Áreas de toque ≥ 48 px (excede a recomendação WCAG de 44 px — mãos trêmulas em situação de emergência precisam de área generosa).
- **Bottom bar fixa** com Voltar/Próximo na `AvaliacaoPage` ([`barra_navegacao_etapa.dart`](../lib/presentation/widgets/feedback/barra_navegacao_etapa.dart)). Princípio: **ações primárias na zona acessível do polegar** (Steven Hoober, *Designing Mobile Interfaces*, O'Reilly 2013).
- A logo principal foi comprimida de **2.2 MB → 84 KB** (96% de redução) — em 3G isso é a diferença entre a vítima esperar 0.5s ou 8s pra ver a Home.
- Modais e cards **adaptam o layout** conforme a largura disponível. Ex: o modal de Saída empilha botões em coluna full-width quando ≤ 380 px.

### 5.2 Tom de voz: "amiga, não empresa"

**Regra de ouro** (originalmente em [`02_PLANEJAMENTO_FRONTEND.md`](02_PLANEJAMENTO_FRONTEND.md) §5.5, agora canônica):

> *"Se a frase soa como aviso de banco, está errada. Se soa como bilhete de uma amiga em quem ela confia, está certa."*

**Aplicações:**

| Frase do site atual (despertemulher.org) | Nossa frase | Por quê |
| --- | --- | --- |
| "ACEITO E QUERO INICIAR AVALIAÇÃO" | "Compreendi — quero continuar" | Caps lock + imperativo dispara o mesmo gatilho de autoridade que ela vive em casa |
| "Não Concordo com os Termos de Uso" | "Tenho dúvidas — quero ler com calma" | "Não concordo" empurra ao desistir; "Tenho dúvidas" oferece um caminho |
| "Atenção: é indispensável procurar..." | "Esta avaliação é um cuidado seu com você." | Sem ordem, sem cobrança |
| "Mesmo que o Risco seja Baixo, ele Existe!" | (removida) | Frase pressionadora — fonte de abandono |

**Princípio de não-imperatividade:**
- Verbos como "respira", "continue", "denuncie" **só aparecem se vierem com uma estrutura que devolve o controle**.
- ❌ Errado: *"Respira fundo e continue."*
- ✅ Certo: *"Se quiser respirar fundo, fica à vontade. Quando você decidir seguir, eu te acompanho."*

A diferença é sutil mas vital: a primeira é ordem; a segunda é convite com controle dela.

### 5.3 Psicologia das cores

**Base científica:** estados emocionais fragilizados respondem mal a cores ativadoras (vermelhos saturados disparam cortisol via sistema simpático), cores frias profundas (azul-marinho → distanciamento) e cores excitantes (amarelo neon → ansiedade). Respondem **bem** a tons quebrados, levemente acinzentados, com nuance — que comunicam "casa", "cuidado", "natureza" (Kassia St. Clair, *The Secret Lives of Color*; Karen Haller, *The Little Book of Colour*).

**Paleta escolhida — "Lavanda Acolhedora"** (em `lib/common/app_theme.dart`):

| Token | Hex | Uso |
| --- | --- | --- |
| `primaria` | `#8B6F9E` | Lavanda profunda — botões, links, destaques |
| `primariaClara` | `#B89BC9` | Hover, estado focado discreto |
| `primariaEscura` | `#6B5278` | Pressionado, headers internos |
| `primariaFundo` | `#EDE6F5` | Selos de logos, chips, fundo de cards sensíveis |
| `secundaria` | `#C99D9A` | Rosa empoeirado — acentos |
| `terciaria` | `#8AA89B` | Verde-sálvia — confirmações, "tudo certo" |
| `fundo` | `#FBF8F4` | Off-white quente — **NUNCA branco puro** |
| `textoPrincipal` | `#3A3536` | Grafite quente — **NUNCA preto puro** |
| `grauExtremo` | `#8B4A47` | Bordô maduro — **NUNCA vermelho neon**, mesmo no grau Extremo |

**Por que NÃO usamos vermelho neon nem no grau "Extremo":** estudos de UX em saúde mental indicam que vermelho-sangue/neon pode paralisar a usuária no momento exato em que ela mais precisa agir. Bordô maduro comunica gravidade **sem disparar pânico**. Acompanhamos com **ícone + texto explicativo** (princípio de acessibilidade: cor nunca é o único canal de informação).

**Contraste verificado contra WCAG 2.1 AA:** todos os pares texto/fundo passam. Tabela em [`02_PLANEJAMENTO_FRONTEND.md`](02_PLANEJAMENTO_FRONTEND.md) §5.2.

### 5.4 Trauma-informed UI (microcopy entre etapas)

**Pesquisa de referência:** Bryson & Stephens (2019) sobre design para populações em crise; Equity Design guides da IDEO; Trauma-Informed Care Implementation Resource Center (SAMHSA, Substance Abuse and Mental Health Services Administration, EUA).

**Aplicação concreta no app:** o widget [`OverlayMicrocopiaEtapa`](../lib/presentation/widgets/feedback/overlay_microcopia_etapa.dart) mostra uma frase grande, em itálico lavanda, sobre fundo off-white translúcido, entre uma etapa e outra da Avaliação.

**Duração: 6 segundos** (escolha clínica, não estética):
- **3.5 s** — tempo de leitura confortável de uma frase de 15-20 palavras em ritmo calmo (não estressado).
- **1 s** — pausa pra processar.
- **2 s** — uma respiração consciente curta (inspira pelo nariz, expira pela boca).
- **Faixa-segura** segundo a literatura: 4-8 s. Abaixo de 4 s o texto desaparece antes da leitura completa; acima de 8 s vira interrupção forçada.

**Toque para dispensar antes** sempre disponível — quem quer avançar mais rápido não fica preso.

**As 4 frases canônicas** (em `lib/common/app_strings.dart`):
- **E1 → E2** (após histórico de violência, bloco mais pesado): *"Você acabou de falar sobre coisas difíceis. Se quiser uma pausa, ela está aqui. Quando você decidir seguir, eu te acompanho."*
- **E2 → E3** (após perguntas sobre o agressor): *"A gente está no meio do caminho. Você está fazendo isso no seu tempo — e isso importa."*
- **E3 → E4** (após perguntas sobre a vítima e os filhos): *"Faltam só duas. Se precisar de um respiro, ele cabe aqui. Sem pressa."*
- **E4 → E5** (entrando na última): *"Última parte. Você chegou até aqui — isso já vale muito."*

**Não-imperatividade** verificada em cada frase: todas devolvem o controle para a usuária ("se quiser", "no seu tempo", "quando você decidir").

### 5.5 Pergunta 4 (violência sexual) com cuidado visual extra

A pergunta sobre relações sexuais forçadas tem peso emocional muito maior que as outras. Tratamento especial:

- Campo `sensivel: true` na entidade `Pergunta` (em `lib/domain/entities/pergunta.dart`).
- `CardPergunta` renderiza diferente quando `sensivel`: borda lavanda mais grossa (2 px sempre), fundo lavanda translúcido (`primariaFundo`), padding maior (24 px em vez de 16 px).
- `textoApoio` reforçado: *"Essa é uma das perguntas mais difíceis daqui. Você responde no seu tempo — e tudo bem se quiser respirar fundo antes. Não há nada que você precise explicar para ninguém."*

**Por que não mudamos o texto da pergunta:** o FONAR é regulamentado por CNJ/CNMP (Resolução Conjunta nº 5/2020). **O enunciado e as opções de resposta NÃO podem ser alterados**. Mudamos só o entorno (apresentação, texto de apoio, visual do card).

### 5.6 Outras decisões de UX

- **Barra de progresso linear + label "Etapa X · faltam ~Y min"**: previsibilidade reduz abandono. Estimativa conservadora de 3 min/etapa = ~15 min totais.
- **Botões Voltar/Próximo na bottom bar fixa**: princípio de Fitts' Law + Hoober's thumb zones — alvos primários na zona inferior central.
- **Cards de pergunta com 4 estados visuais distintos**: não respondida (borda divisor), respondida (borda verde-sálvia + check), em erro (borda terracota + microcopy acolhedora), sensível (borda lavanda extra).
- **MedidorRisco animado e sticky no rodapé**: feedback contínuo. **NÃO mostra o número bruto** durante o preenchimento (estudos de UX indicam que números no meio do fluxo aumentam abandono). Só revela na tela final, contextualizado.
- **`CardApoiador` (rede de apoio)** com 3 seções verticais: selo lavanda com a logo no topo (equaliza visual entre logos de proporções diferentes), título e descrição no meio, **CTA "Ligar agora · 180" preenchido lavanda no rodapé** para cards com telefone. Padrão de hierarquia visual claro: o usuário não precisa pensar onde clicar.

---

## 6. Segurança da vítima — mecânicas

Cada item desta seção é uma **mecânica concreta no código** — não um princípio abstrato.

### 6.1 Botão "Saída Rápida"

**Localização:** topo direito do `HeaderApp`, visível em **toda** página.

**Atalho de teclado:** `Esc` (registrado em `ScaffoldAcolhedor` via `Shortcuts` + `Actions`).

**Fluxo:**
1. Usuária clica no botão (ou pressiona `Esc`).
2. Abre `ConfirmacaoSaidaModal` (em `lib/presentation/widgets/seguranca/confirmacao_saida_modal.dart`).
3. Se confirma, chama `sairRapido()` de `lib/web/browser_helpers_web.dart`:
   - `window.history.replaceState(null, '', '/')` — sobrescreve a URL atual no histórico de navegação da aba (impede que o botão "Voltar" do navegador retorne pro site).
   - `window.sessionStorage.clear()` — limpa sessionStorage (envolvido em try/catch porque pode estar bloqueado em modo private).
   - `window.location.replace('https://www.google.com')` — redireciona para o Google **sem criar nova entrada no histórico**.

**Importante reconhecer:** isso reduz pegada digital mas **NÃO apaga o histórico permanente do navegador**. Nenhum site, em nenhum navegador, tem essa API por design — se tivesse, sites de phishing apagariam suas próprias evidências. A única forma real de não deixar rastro é usar **aba anônima desde o início**.

### 6.2 Aviso de aba anônima no primeiro acesso

`AvisoHistoricoModal` aparece **uma vez por sessão** na Home. Texto:

> **Cuidado com você**
>
> Para mais privacidade, sugerimos usar este site em uma **aba anônima** do navegador.
>
> Suas respostas nunca são salvas no nosso servidor. Mas o navegador pode guardar o endereço do site no histórico — usar aba anônima evita isso.
>
> Você pode sair rapidamente a qualquer momento clicando no botão "Sair" no topo da página.
>
> **[Entendi, vamos lá]**

**Flag de controle:** `homePageAvisoHistoricoJaMostrado` (variável module-level em `lib/presentation/pages/home/home_page.dart`). Não vai pra `localStorage` — vive só na RAM da sessão. Em testes, suprimida via `setUp(() => homePageAvisoHistoricoJaMostrado = true)`.

### 6.3 Manifest neutro (`web/manifest.json`)

```json
{
  "name": "Site",
  "short_name": "Site",
  "display": "browser",
  "background_color": "#FBF8F4",
  "theme_color": "#8B6F9E",
  ...
}
```

**Decisões críticas:**
- `display: "browser"` — **NUNCA standalone**. O Chrome ofereceria "Adicionar à tela inicial" e criaria um ícone "Desperte Mulher" no celular da vítima. Inaceitável.
- `name: "Site"`, `short_name: "Site"` — se ela salvar como atalho mesmo assim, aparece nome genérico.
- `prefer_related_applications: false` — nunca sugere "instalar como app".
- Removemos os ícones `maskable-*` que vieram do template (só fariam sentido para PWA standalone, que não queremos).

### 6.4 Headers de privacidade (`web/index.html`)

```html
<meta http-equiv="Cache-Control" content="no-store, no-cache, must-revalidate, private">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="0">
<meta name="referrer" content="no-referrer">
```

`Cache-Control: no-store` reduz a chance do navegador cachear páginas localmente. `referrer: no-referrer` impede que links externos (ex: "Ligue 180" via `tel:`) vazem a URL de origem.

Adicionalmente:
```css
@media print {
  body { display: none !important; }
}
```
Impede impressão acidental do questionário em andamento. Princípio: agressor não deve encontrar uma cópia impressa.

### 6.5 Título e ícone neutros

- `<title>Site</title>` na aba do navegador.
- Favicon = ícone neutro fornecido pelo Davi (`icone_da_aba.png`), **não** a logo principal.

### 6.6 Sem coleta de dados pessoais no MVP

A página de Resultado **NÃO** tem botão "Identificar-se para receber acompanhamento" nesta versão. O site atual coleta CPF sem máscara — vetor de ataque conhecido. Adiaremos esse fluxo para quando o backend Django estiver com infraestrutura LGPD-compliant.

---

## 7. Microcopy: o "bilhete de uma amiga"

Catalogamos aqui as decisões linguísticas para que qualquer pessoa (chat novo, Davi, revisora externa) consiga manter consistência.

### 7.1 Princípios

1. **Sem imperativos como ordem.** "Respire" não. "Se quiser respirar fundo, fica à vontade" sim.
2. **Sem caps lock.** Caps lock comunica gritaria.
3. **Sem pressão de tempo.** "No seu tempo" aparece com frequência.
4. **Sem culpabilização implícita.** Nunca "você deveria ter…", "você precisa…".
5. **Sem minimização.** Nunca "vai ficar tudo bem", "não foi tão grave assim".
6. **Frases curtas.** Cada frase carrega uma ideia.
7. **Devolver controle.** "Você decide", "se quiser", "quando estiver pronta" — quase sempre.

### 7.2 Frases canônicas (em `lib/common/app_strings.dart`)

**Hero da Home:**
> *"Conhecimento é o primeiro passo para a liberdade"*
> *"Você não precisa ter certeza de nada para começar. Aqui você decide o ritmo, sem julgamentos."*

**Termos (Antes de começar):**
> *"Esta avaliação é um cuidado seu com você. Quando quiser conversar com alguém da rede de apoio, estaremos aqui."*

**Botões de Termos:**
> *"Compreendi — quero continuar"* (primário)
> *"Tenho dúvidas — quero ler com calma"* (secundário)

**Medidor de risco (durante o quiz):**
> *"Você está construindo seu mapa de segurança."*

**Erro inline (pergunta sem resposta):**
> *"Quando estiver pronta, escolha uma opção para continuar."*

**Rodapé sutil acima do medidor (durante o quiz):**
> *"Sem pressa. Você decide o ritmo."*

**Microcopias entre etapas:** ver §5.4 acima.

**Resultado (microcopy contextual por grau):** em `lib/domain/entities/grau_risco.dart` — cada `GrauRisco` carrega seu próprio `microcopyAcolhedor`. Princípio: validar o que ela viveu sem apavorar nem minimizar.

### 7.3 O que NÃO mudamos

**As 27 perguntas do FONAR** (texto literal + opções de resposta) **não podem ser alteradas**. Regulamentadas pela Resolução Conjunta nº 5/2020 do CNJ e CNMP. Podemos mudar:
- A apresentação (UI do card)
- A ordem em que blocos aparecem (etapas)
- Microcopy AO REDOR (texto de apoio, mensagens entre etapas)

**Não podemos** mudar:
- O enunciado da pergunta
- O texto literal das opções de resposta

Se um dia o Davi pedir pra reescrever uma pergunta, **bloquear e consultar o Felipe Scarpelli antes**.

---

## 8. Estrutura do projeto (mapa)

```
desperte_mulher/
├── lib/
│   ├── main.dart                              5 linhas — só chama criarMaterialApp()
│   │
│   ├── common/                                # Tokens e factories globais
│   │   ├── app_routes.dart                    Constantes de rota (AppRotas.home, etc)
│   │   ├── route_manager.dart                 Factory createMaterialApp() — todas as rotas e tema
│   │   ├── app_theme.dart                     AppCores, AppTipografia, AppSombras
│   │   ├── app_dimensions.dart                Espaçamentos (e4..e64), raios, breakpoints
│   │   ├── app_strings.dart                   TODAS as strings em PT-BR (i18n-ready)
│   │   └── app_assets.dart                    Caminhos de PNG/SVG
│   │
│   ├── domain/                                # Dart puro — testável sem Flutter
│   │   ├── entities/                          Entidades de negócio
│   │   ├── repositories/                      Contratos abstratos (QuizRepository)
│   │   └── usecases/                          CalcularRiscoArpax, cruzarMatriz
│   │
│   ├── data/                                  # Substituível: hoje JSON, amanhã API
│   │   ├── datasources/                       QuizLocalDataSource
│   │   ├── models/                            DTOs (espelham o JSON)
│   │   ├── mappers/                           DTO → Entity
│   │   └── repositories/                      QuizRepositoryImpl
│   │
│   ├── presentation/                          # UI
│   │   ├── pages/                             Telas
│   │   │   ├── home/
│   │   │   ├── termos/
│   │   │   ├── avaliacao/
│   │   │   │   ├── avaliacao_page.dart
│   │   │   │   └── controller/
│   │   │   │       └── avaliacao_controller.dart
│   │   │   ├── resultado/
│   │   │   ├── sobre/
│   │   │   ├── analise/
│   │   │   ├── apoios/
│   │   │   ├── falar/
│   │   │   └── nao_encontrada/                404
│   │   │
│   │   └── widgets/                           # Design System
│   │       ├── botoes/                        BotaoPrimario, Secundario, Texto, SaidaRapida
│   │       ├── cards/                         CardPergunta, CardApoiador, CardResultado
│   │       ├── feedback/                      MedidorRisco, ProgressoEtapas, BadgeSeguranca,
│   │       │                                  BarraNavegacaoEtapa, OverlayMicrocopiaEtapa
│   │       ├── layout/                        HeaderApp, FooterApp, ScaffoldAcolhedor
│   │       ├── textos/                        TituloH1, H2, H3, Paragrafo, TextoApoio
│   │       └── seguranca/                     AvisoHistoricoModal, ConfirmacaoSaidaModal
│   │
│   └── web/                                   # Helpers JS — conditional import
│       ├── browser_helpers.dart               Fachada (escolhe entre stub e web)
│       ├── browser_helpers_web.dart           Real (usa dart:js_interop)
│       └── browser_helpers_stub.dart          Stub para testes/VM
│
├── assets/
│   ├── mock/                                  etapa_1..5.json + mapeamento_criterios.json
│   ├── images/
│   │   ├── logo_desperte_mulher.png           600×400, 84 KB (otimizada)
│   │   ├── logo_desperte_mulher.original.png  Backup 1536×1024 — .gitignored
│   │   └── parceiros/                         13 logos institucionais
│   └── fonts/
│       ├── Lato-{Regular,Bold,Italic}.ttf
│       └── PlayfairDisplay-{Regular,Bold,Italic}.ttf  (Bold é a Variable c/ wght axis)
│
├── test/
│   ├── domain/                                Motor AR PAX (37+ testes)
│   └── presentation/                          Walkthrough (Home → Termos → Avaliação)
│
├── web/
│   ├── index.html                             Cache headers, manifest link, VLibras slot
│   ├── manifest.json                          display: browser, short_name "Site"
│   ├── favicon.png
│   └── icons/
│
├── docs/
│   ├── 01_COMPILACAO_DADOS_PROJETO.md         Metodologia AR PAX + FONAR + equipe
│   ├── 02_PLANEJAMENTO_FRONTEND.md            Plano pré-implementação
│   └── 03_HANDOFF_E_DECISOES.md               Este arquivo
│
├── pubspec.yaml                               Sem state mgmt externo. Sem dio/http.
├── analysis_options.yaml
└── README.md                                  Portfolio-grade
```

### 8.1 Convenções

| Tipo | Padrão | Exemplo |
| --- | --- | --- |
| Arquivos Dart | `snake_case.dart` | `card_pergunta.dart` |
| Classes | `PascalCase` | `class CardPergunta` |
| Variáveis/funções | `camelCase` | `void onPerguntaRespondida()` |
| Constantes | `lowerCamelCase` | `static const corPrimaria` |
| Métodos privados | `_` no início | `void _validarEntrada()` |
| Enums | `PascalCase` tipo, `lowerCamelCase` valores | `enum CriterioArpax { atratibilidade, ... }` |
| Pastas | `snake_case` | `presentation/widgets/cards/` |

**Imports são sempre absolutos** via `package:desperte_mulher/...`. Nunca `../../../`.

### 8.2 Como adicionar coisa nova

| O que adicionar | Onde mora |
| --- | --- |
| Uma string nova | `lib/common/app_strings.dart` |
| Uma cor nova | `lib/common/app_theme.dart` → classe `AppCores` |
| Um widget reusável | `lib/presentation/widgets/<categoria>/` |
| Uma tela nova | `lib/presentation/pages/<nome>/` + rota em `app_routes.dart` + entry em `route_manager.dart` |
| Uma regra de negócio | `lib/domain/usecases/` |
| Uma entidade nova | `lib/domain/entities/` |
| Um DTO novo | `lib/data/models/` + mapper em `lib/data/mappers/` |
| Um helper de browser | `lib/web/browser_helpers_web.dart` + stub em `_stub.dart` |
| Um teste | `test/domain/` (regra de negócio) ou `test/presentation/` (UI) |

---

## 9. Componentes-chave

Documenta os widgets que tomam decisões não-óbvias.

### 9.1 `ScaffoldAcolhedor` (`lib/presentation/widgets/layout/`)

Substitui o `Scaffold` padrão em **toda** página. Garante consistência sem repetição.

**Parâmetros importantes:**
- `conteudo: Widget` — conteúdo principal.
- `rodapeFixo: Widget?` — widget abaixo do scroll (usado pelo MedidorRisco + BarraNavegacaoEtapa na Avaliação).
- `scrollController: ScrollController?` — quando informado, a página controla o scroll do scaffold (essencial para "reset scroll ao trocar de etapa").
- `mostrarFooter: bool` — esconde o FooterApp em telas onde queremos o foco total (ex: Avaliação).
- `aoSair: AoSairCallback` — default é `web.sairRapido` (vem do conditional import).

**Mecânicas internas:**
- Aplica `SafeArea(top: true, bottom: false)` — status bar do dispositivo não cobre o header.
- Aplica largura máxima do conteúdo (`larguraMaximaConteudo` = 1200 px).
- Registra atalho de teclado `Esc` para Saída Rápida via `Shortcuts` + `Actions`.

### 9.2 `AvaliacaoPage` + `AvaliacaoController`

A tela mais complexa do app.

**Por que essa estrutura específica:**
- O `_scrollController` é **da página** e é passado pro `ScaffoldAcolhedor`. Isso resolve o bug de "etapa nova abre na mesma posição de scroll" (ver §11.3).
- Reset de scroll usa `postFrameCallback` para garantir que rola **depois** do rebuild com a etapa nova.
- O `Stack` no nível da página acomoda o `OverlayMicrocopiaEtapa` por cima do conteúdo.

**Fluxo de avançar etapa:**
1. Usuária clica em Próximo (na `BarraNavegacaoEtapa`).
2. `_avancarOuFinalizar()` chama `_controller.validarEtapa()`.
3. Se inválido → `setState` rebuilda com `mostrarErro` nos cards + scroll pro topo.
4. Se for última etapa → `Navigator.pushReplacementNamed(AppRotas.resultado)`.
5. Caso contrário → `_controller.irParaProximaEtapa()` + escolhe a microcopia da transição + agenda scroll pro topo.

### 9.3 `CardPergunta` — 4 estados visuais + modo sensível

Renderiza qualquer uma das 30 perguntas do FONAR.

**Estados visuais:**
| Estado | Borda | Fundo |
| --- | --- | --- |
| Não respondida | `divisor` 1 px | `fundoCard` |
| Respondida | `terciaria` 2 px | `fundoCard` |
| Com erro | `erro` 2 px | `erroFundo` + microcopy "Quando estiver pronta…" |
| **Sensível** | `primariaClara` 2 px (mesmo antes de responder) | `primariaFundo` |

Padding também muda no modo sensível (24 px em vez de 16 px). Estados se combinam — pergunta sensível respondida fica com borda `terciaria` (resposta tem prioridade visual).

### 9.4 `MedidorRisco`

Persistente no rodapé da Avaliação. Mostra barra animada do percentual preenchido.

**Decisões:**
- **NUNCA mostra o número bruto** durante o quiz. Estudos mostram que números no meio do fluxo aumentam abandono.
- Cor da barra **NÃO é a cor do grau projetado** durante o quiz (anti-pânico). Só na tela de Resultado a cor expressa o grau.
- Animação suave de 600 ms entre estados (Tween) — sensação de progresso fluido.

### 9.5 `ProgressoEtapas`

Topo da Avaliação. Três camadas:
1. **Label**: "Etapa 2 de 5 · faltam ~9 min" (estimativa de 3 min/etapa).
2. **Barra linear** (`LinearProgressIndicator`) com lavanda.
3. **5 círculos** conectados por linhas (concluído / atual / pendente).

A barra é redundante com os círculos, mas o sistema duplo serve a diferentes leitores: glance rápido → barra; leitura precisa → círculos.

### 9.6 `BarraNavegacaoEtapa`

Bottom bar **fixa** com Voltar (esquerda, secundário) e Próximo (direita, primário). Em `SafeArea(top: false)` para não duplicar com o SafeArea do scaffold.

**Por que existe:** princípio mobile-first de "ações primárias na zona do polegar". Antes, esses botões estavam dentro do scroll do conteúdo — usuária tinha que rolar até o final pra avançar.

### 9.7 `OverlayMicrocopiaEtapa`

Já documentado em §5.4. Pontos técnicos:
- Envolvido em `Material(color: Colors.transparent)` — necessário para o `Text` não cair no decorador de debug "yellow underline" do Flutter (faltava `Material` ancestor).
- Fade in/out de 280 ms via `AnimationController`.
- Auto-dismiss em 6 s via `Timer`; toque dispensa antes.

### 9.8 `CardApoiador`

Já documentado em §5.6. Três seções: selo da logo no topo (80 px contido), corpo (título + descrição), rodapé adaptativo (CTA "Ligar agora" se tem telefone, "Saiba mais →" caso contrário). InkWell envolve o card inteiro — área de toque generosa.

---

## 10. O motor AR PAX em uma olhada

Está documentado em detalhe em `01_COMPILACAO_DADOS_PROJETO.md` §3-4. Aqui só o que precisa pra retomar o trabalho:

### Fluxo do cálculo

1. **Contar marcações positivas por critério.** Cada opção marcada (que não seja `ehNegativa`) soma 1 ponto em cada critério alimentado pela pergunta.
2. **Classificar contagem em nível Likert (1-5).** Cada critério tem uma tabela própria (em `CriterioArpax.classificarLikert`).
3. **Aplicar pesos** → `V_final` e `A_final`:
   - V = VC1×(1/3) + VC2×(1/2) + VC3×(1/4)
   - A = AC1×1 + AC2×(1/3) + AC3×(1/2)
4. **Categorizar** V e A em níveis Likert (faixas do Quadro 7 do Scarpelli).
5. **Cruzar na matriz 5×5** → `GrauRisco` final (MB/BA/MO/AL/EX).

### Cenários de validação verificados

| Cenário | V_final | A_final | Grau |
| --- | --- | --- | --- |
| Vazio | 0.00 | 0.00 | MB |
| Canário do Silvano (P1+P2tapa+soco+P3) | 2.00 | 1.167 | **MB** ✓ |
| Apenas VC1 saturada (7 marcações) | 5/3 ≈ 1.67 | 0.00 | MB |
| Máximo teórico (todos os critérios em 5) | 5.4166 | 9.1666 | **EX** ✓ |

Todos passam em `flutter test`. 51 testes verdes.

### Arquivos canônicos

- `lib/domain/entities/criterio_arpax.dart` — enum + pesos + tabelas Likert
- `lib/domain/entities/nivel_dimensao.dart` — `NivelVulnerabilidade`, `NivelAmeaca` + faixas
- `lib/domain/entities/grau_risco.dart` — enum + microcopy contextual por grau
- `lib/domain/usecases/calcular_risco_arpax.dart` — o motor (5 passos)
- `lib/domain/usecases/cruzar_matriz_risco.dart` — matriz 5×5 do Quadro 8
- `test/domain/` — testes que provam tudo

**Se o Felipe Scarpelli pedir mudança de peso ou faixa:** edita `criterio_arpax.dart` ou `nivel_dimensao.dart`, roda testes, atualiza este doc.

---

## 11. Bugs corrigidos (causa raiz)

Esta seção é importante para chat novo — se você vir um sintoma parecido, **provavelmente é a causa raiz que já documentamos**.

### 11.1 Container com `color` e `decoration` ao mesmo tempo

**Sintoma:** tela vermelha do Flutter com assertion `'color == null || decoration == null'` ao abrir a Avaliação.

**Causa:** `MedidorRisco` tinha `Container(color: AppCores.fundoCard, ..., decoration: BoxDecoration(color: AppCores.fundoCard, ...))`. O `color` direto do `Container` é redundante quando você passa `decoration` com `BoxDecoration` — Flutter sobe assertion fatal.

**Fix:** removi o `color:` direto. `flutter analyze` **não** pega isso porque é assertion de runtime, não erro estático.

**Prevenção:** existe um teste de walkthrough (`test/presentation/walkthrough_avaliacao_test.dart`) que monta a app de verdade até a Avaliação. Se outro Container quebrar nesse mesmo padrão, esse teste falha em ~3 segundos.

**Commit:** `099bdf8`.

### 11.2 Tela branca no boot (`window.flutterConfiguration` deprecated)

**Sintoma:** `flutter run -d chrome` sobe, abre o navegador, **tela 100% branca sem nenhuma mensagem de erro visível** ao usuário.

**Causa:** o `web/index.html` tinha `window.flutterConfiguration = { renderer: "html" }`. Em Flutter 3.27+ esse mecanismo virou ilegal — o `bootstrap.js` faz assertion `!_usedLegacyConfigStyle` e mata o boot ANTES de chamar `runApp()`.

**Fix:** removi o script legacy do `index.html` e deixei um comentário longo explicando.

**Detecção:** quando der tela branca no Flutter Web, **sempre primeiro olhar `flutter run` no terminal** — a assertion fica lá. Erros de boot não aparecem na tela.

**Commit:** `9a9e901`.

### 11.3 Scroll não resetava ao trocar de etapa

**Sintoma:** clicar em "Próximo" na etapa 2 abria a etapa 3 já scrollada no meio (mesma posição vertical que estava antes).

**Causa raiz:** o `ScaffoldAcolhedor` tinha um `SingleChildScrollView` interno envolvendo conteúdo + footer. A `AvaliacaoPage` montava **outro** `SingleChildScrollView` com seu próprio `_scrollController`. O scroll visível acontecia no externo (do scaffold), mas o `jumpTo(0)` controlava o interno — que nem rolava.

**Fix:** removi o `SingleChildScrollView` interno da `AvaliacaoPage`. O `ScaffoldAcolhedor` ganhou parâmetro `scrollController: ScrollController?`. A `AvaliacaoPage` agora passa o seu controller pro scaffold. Reset via `WidgetsBinding.instance.addPostFrameCallback((_) => _scrollController.jumpTo(0))` — garante que rola depois do rebuild.

**Lição geral:** se você vir `_scrollController.jumpTo(...)` sem efeito em Flutter, **provavelmente o ScrollView controlado não é o que está realmente rolando**. Procure por ScrollViews aninhados.

**Commit:** parte de `b8e8a19`.

### 11.4 Sublinhado amarelo no overlay de microcopia

**Sintoma:** o `OverlayMicrocopiaEtapa` renderizava o texto com um sublinhado amarelo grosso de debug.

**Causa:** é o decorador "missing Material ancestor" do Flutter. Quando um `Text` é desenhado dentro de um widget que não tem `Material` como ancestor (no caso, o `Container` colorido do overlay cobria o `Material` do scaffold na árvore), o framework compensa com aquele sublinhado pra avisar.

**Fix:** envolver o `Container` colorido com `Material(color: Colors.transparent, ...)`. Zero impacto visual, restaura a árvore Material.

**Prevenção:** quando criar um overlay ou widget que sobrepõe o scaffold, **sempre incluir um `Material` ancestor** antes de qualquer `Text`.

**Commit:** parte de `7b86e46`.

### 11.5 Modal "Sair agora?" overflow 39 px

**Sintoma:** o botão "Sim, sair agora" ultrapassava a borda do modal com a faixa amarela-preta de debug em mobile estreito.

**Causa:** o `Row` com `Cancelar` + `Sim, sair agora` não tinha `Flexible/Expanded`. Em telas ≤ 375 px, os dois botões + spacing + ícone não cabiam.

**Fix evolutivo (3 tentativas):**
1. Primeiro tentei `Wrap` — quebrou para coluna mas os botões ficaram "soltos" alinhados à direita (visualmente bagunçado).
2. Segundo, `LayoutBuilder`: se `maxWidth < 380` → `Column` com botões; senão `Row`.
3. Finalmente, adicionei `largura100: empilhar` nos botões quando empilhados — full-width visualmente limpo (padrão de modais mobile do WhatsApp/Telegram/iOS sheets).

**Resultado final:**
- Mobile estreito: coluna com botões 100% largura, secundário em cima, primário embaixo (zona do polegar).
- Desktop: linha com primário à direita (padrão Material).

**Commits:** `4ba6815` (tentativa 1-2), `d2a8ad9` (final com `largura100`).

### 11.6 Status bar do dispositivo cobrindo o header

**Sintoma:** em celulares com edge-to-edge (gesture navigation no Android), o relógio/wifi/bateria do sistema **ficavam sobrepostos** ao "Desperte Mulher" no topo.

**Causa:** o `web/index.html` tem `viewport-fit=cover` (necessário para iPhones com notch). Sem `SafeArea`, o conteúdo se estende abaixo da status bar.

**Fix:** envolvi o `Column` interno do `ScaffoldAcolhedor` em `SafeArea(top: true, bottom: false, left: false, right: false)`. `bottom: false` é proposital — a `BarraNavegacaoEtapa` tem seu próprio `SafeArea` inferior, evitando padding duplo.

**Commit:** `4ba6815`.

### 11.7 `tel:` deeplink usando `location.replace` (undefined behavior)

**Sintoma:** o botão "Ligar agora · 180" funcionava em alguns navegadores mobile e falhava em outros (Edge mobile, alguns Safari iOS) — às vezes a página travava em estado quebrado.

**Causa:** `window.location.replace('tel:180')` foi especificado para URLs http(s). Para schemes especiais como `tel:` o comportamento é undefined — cada navegador implementa diferente.

**Fix:** trocar para `window.open('tel:...', '_self')` — o equivalente programático de clicar em `<a href="tel:...">`. Comportamento padronizado em todos os navegadores que suportam o scheme.

**Commit:** `4ba6815`.

---

## 12. Regras inegociáveis

Essa lista é o "framework moral" do projeto. **Qualquer mudança que viole alguma destas precisa de discussão explícita.**

### 12.1 Plataforma

1. **Flutter Web exclusivamente.** Nunca APK/IPA distribuído em loja. A vítima não pode ter ícone "Desperte Mulher" no celular.
2. **Sigilo do preenchimento.** Nada vai pra disco, cookie, localStorage, sessionStorage ou servidor.
3. **Manifest neutro.** `display: browser`, `short_name: "Site"`.

### 12.2 Comunicação

4. **Anonimato por padrão.** Identificação só é oferecida APÓS o resultado, e é totalmente opcional. **No MVP atual, essa funcionalidade NÃO foi implementada** — só viria com o backend Django LGPD-compliant.
5. **Tom de amiga, não empresa.** Sem imperativo, sem caps lock, sem pressão.
6. **Feedback visual contínuo.** MedidorRisco, ProgressoEtapas, microcopia entre etapas.

### 12.3 Visual

7. **Paleta acolhedora.** Sem vermelho neon, sem azul-marinho frio, sem amarelo saturado. Off-white em vez de branco. Grafite quente em vez de preto.
8. **Cor nunca é único canal.** Sempre acompanhada de ícone e/ou texto.
9. **Áreas de toque ≥ 48 px.**

### 12.4 Conteúdo

10. **As 27 perguntas do FONAR não podem ser alteradas.** Apenas a apresentação, a ordem em blocos e o microcopy AO REDOR.
11. **Mudanças em pesos ou matriz AR PAX** exigem consulta ao Felipe Scarpelli e atualização de testes + deste documento.

### 12.5 Código

12. **Conditional import** sempre que usar `dart:js_interop` — para que testes rodem.
13. **Sem libs de state management externas.** `setState` puro.
14. **Sem persistência** (`shared_preferences`, IndexedDB, etc).
15. **Commits em inglês**, código em português (decisão do dev).

---

## 13. Roadmap pós-MVP

Itens **fora do MVP atual** mas com arquitetura preparada:

### 13.1 Integração com backend Django

- Status: Django em construção paralela por outra frente da equipe.
- Trabalho aqui: criar `QuizRemoteDataSource implements QuizDataSource` em `lib/data/datasources/` com `Dio` ou `http`. Trocar a instância em `QuizRepositoryImpl`. **Os 51 testes do domain continuam passando intactos** porque o motor não muda.
- Estimativa: 4-6 horas de trabalho quando o endpoint estiver pronto.

### 13.2 VLibras

- Slot já reservado no `web/index.html` (bloco comentado).
- Trabalho aqui: descomentar o bloco, testar se renderiza por cima do canvas do Flutter (CanvasKit), confirmar comportamento em mobile.
- Risco: o avatar VLibras pode ficar visualmente sobre conteúdo importante — precisa testar com Davi/Silvano.

### 13.3 Multi-idioma PT/ES/EN

- Strings já centralizadas em `lib/common/app_strings.dart`.
- Trabalho aqui: migrar para `flutter_localizations` + arquivos `.arb`. **A reescrita é mínima** porque as chaves já existem.

### 13.4 Página de Observatório

- Custo alto (gráficos interativos + mapa Leaflet espelhando o site atual).
- Por enquanto, manter como link externo no menu.

### 13.5 Sistema Acolhe

- Área restrita para profissionais. Espelha `/login` do site atual.
- Depende do backend Django e do esquema de autenticação. Adiado.

### 13.6 Dark mode

- Discutido na branch `ux/mobile-first-polish` mas não implementado.
- Valor real: vítima usando à noite no escuro — tela branca denuncia mais.
- Trabalho: ~2 horas (paleta dark + segundo `ThemeData` + toggle no header).

### 13.7 Ideias rejeitadas (para evitar revisitar sem motivo novo)

- **"Uma pergunta por tela"** (estilo Typeform): considerei na branch ux/mobile-first-polish. Trade-off é o trabalho de 27 telas vs 5 etapas. Mantivemos 5 etapas. Se voltar a discussão: o argumento NÃO é estético ("fica mais bonito"), tem que ser dado de pesquisa que mostre menor abandono.
- **Salvar link com estado das respostas**: criptografia + URL longa + risco de o link sobreviver no histórico (anula o sigilo). Não vale o trade-off.
- **Apagar histórico do navegador via JS**: tecnicamente impossível. Nenhum site, em nenhum navegador, tem essa API por design.
- **Janela de "pausa formal"**: também rejeitada — a única forma de pausar é fechar a aba. Documentamos isso com clareza pra ela; uma "pausa formal" criaria uma falsa sensação de retomada que choca com o sigilo.

---

## 14. Para continuar de onde paramos

Se você é um chat novo, ou o Codfy voltando depois de tempo, leia esta seção.

### 14.1 Antes de tocar em código

1. **Leia este documento (03)** inteiro. Ele é a fonte de verdade do estado atual.
2. **Não confie 100% no 02** — ele tem o plano original, não o que foi implementado. Sempre que 02 e 03 divergem, **03 ganha**.
3. **Não altere os textos das 27 perguntas do FONAR**. Verifique se a mudança que vai fazer toca neles — se sim, pare e converse com o Felipe Scarpelli.
4. **Verifique que `flutter test` está verde** (`51 passed`) antes de começar e depois de cada mudança grande.

### 14.2 Comandos essenciais

```bash
# Setup
flutter pub get

# Desenvolvimento
flutter run -d chrome

# Acesso do celular na mesma Wi-Fi
flutter run -d chrome --web-hostname=0.0.0.0 --web-port=8080
# (descobrir IP com `ipconfig` e acessar do celular em http://<ip>:8080)

# Testes (sempre verde antes de commit)
flutter test

# Análise estática
flutter analyze

# Build de produção
flutter build web --release
# (saída em build/web/ — pode subir em Vercel/Firebase Hosting/GitHub Pages)
```

### 14.3 Workflow de mudança

1. **Criar branch:** `git checkout -b <tipo>/<descricao>` (ex: `feat/dark-mode`, `fix/bug-x`).
2. **Implementar** seguindo as convenções (§8.1).
3. **Testar localmente:**
   - `flutter analyze` deve dizer "No issues found".
   - `flutter test` deve mostrar `+51` (ou mais, se você adicionou testes — bem-vindo).
   - **Se mexeu em UI, rodar `flutter run -d chrome` e testar visualmente**. Os testes não pegam tudo.
4. **Commit** em inglês, formato Conventional Commits.
5. **Atualizar este documento (03)** se a mudança altera algo desta seção (regras inegociáveis, decisão importante, novo componente).
6. **Merge na `main`** com `--no-ff` se for um conjunto coeso de commits — preserva o agrupamento no histórico.
7. **Push** para `origin/main` no GitHub.

### 14.4 Onde está o que (cheatsheet)

| "Preciso mexer em…" | Vá em… |
| --- | --- |
| Microcopy / strings | `lib/common/app_strings.dart` |
| Cor, fonte, tipografia | `lib/common/app_theme.dart` |
| Espaçamento, raio, breakpoint | `lib/common/app_dimensions.dart` |
| Rotas | `lib/common/app_routes.dart` + `lib/common/route_manager.dart` |
| Tela específica | `lib/presentation/pages/<nome>/` |
| Widget reusável | `lib/presentation/widgets/<categoria>/` |
| Motor de cálculo | `lib/domain/usecases/calcular_risco_arpax.dart` |
| Peso ou faixa de critério | `lib/domain/entities/criterio_arpax.dart` ou `nivel_dimensao.dart` |
| Matriz 5×5 | `lib/domain/usecases/cruzar_matriz_risco.dart` |
| Microcopy contextual do grau de risco | `lib/domain/entities/grau_risco.dart` |
| Texto literal de perguntas | `assets/mock/etapa_<n>.json` (mas **NÃO ALTERAR sem aval do Scarpelli**) |
| Helper JS (saída rápida, tel:) | `lib/web/browser_helpers_web.dart` |
| Cabeçalho HTML / cache / meta | `web/index.html` |
| Manifest PWA | `web/manifest.json` |

### 14.5 Quando suspeitar que algo é regressão

- **Tela branca no boot** → §11.2. Olha o `flutter run` no terminal primeiro.
- **Sublinhado amarelo no Text** → §11.4. Falta `Material` ancestor.
- **Container vermelho de assertion** → §11.1. `color` + `decoration` no mesmo widget.
- **Scroll que não vai pra onde você manda** → §11.3. Há ScrollViews aninhados.
- **Overflow em mobile** → veja se o widget usa `LayoutBuilder` ou `Wrap` em vez de `Row` fixa.
- **Status bar cobrindo o header** → §11.6. Confira o `SafeArea`.
- **`tel:` que não abre o discador** → §11.7. Use `window.open(_, '_self')`, não `location.replace`.

### 14.6 Quem perguntar

| Dúvida | Pessoa |
| --- | --- |
| Metodologia AR PAX (peso, faixa, mapeamento) | **Felipe Scarpelli de Andrade** |
| Validação institucional / aprovação | **Davi** (idealizador) |
| Orientação acadêmica / aprovação do trabalho | **Silvano Malfatti** (professor orientador) |
| Implementação concreta | **Marcos Vinicius (Codfy)** — o desenvolvedor |

---

## Apêndice — Lista de "se viu, é proposital"

Coisas que parecem bugs mas são intencionais:

- **Título da aba é "Site", não "Desperte Mulher".** §6.5.
- **`short_name` no manifest é "Site".** §6.3.
- **A logo é renderizada num `Container` com fundo lavanda translúcido no header.** Para destacar contra fundos diferentes.
- **O grau "Extremo" usa bordô (`#8B4A47`), não vermelho.** §5.3.
- **MedidorRisco esconde o número durante o quiz.** §9.4.
- **A pergunta 4 tem borda lavanda diferente das outras.** §5.5.
- **O overlay entre etapas demora 6 segundos.** §5.4.
- **`logo_desperte_mulher.original.png` não está versionado.** É o backup local não comprimido.
- **`.claude/` está no `.gitignore`.** É a pasta de configuração do harness do Claude Code.
- **Os textos das 27 perguntas têm "(A) agressor(a)" com parênteses estranhos.** É o texto literal do FONAR — não pode mexer.
- **`Future.delayed(600ms)` no QuizLocalDataSource.** Simula latência para que o loading state seja visível em desenvolvimento. Em produção (API real) a latência real cumpre esse papel.

---

**Fim do handoff.**

> *Se você é um chat novo e leu até aqui: parabéns, agora você está armado para continuar o trabalho sem fazer besteira. Bem-vindo ao projeto.*
>
> *Se você é o Codfy voltando depois de tempo: respira. Está tudo aqui, está tudo testado, está tudo documentado. Você consegue.*
