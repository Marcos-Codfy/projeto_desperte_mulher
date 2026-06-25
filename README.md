<h1 align="center">Desperte Mulher</h1>

<p align="center">
  Plataforma web de <strong>autoavaliação de risco de violência doméstica</strong><br/>
  baseada na metodologia científica <strong>AR PAX</strong> (Análise de Risco PAX).
</p>

<p align="center">
  <img alt="Flutter" src="https://img.shields.io/badge/Flutter-3.41-02569B?logo=flutter&logoColor=white">
  <img alt="Dart" src="https://img.shields.io/badge/Dart-3.7+-0175C2?logo=dart&logoColor=white">
  <img alt="Platform" src="https://img.shields.io/badge/platform-web-1f6feb">
  <img alt="Tests" src="https://img.shields.io/badge/tests-51%20passing-2ea44f">
  <img alt="License" src="https://img.shields.io/badge/license-MIT-lightgrey">
</p>

---

## Sobre o projeto

O **Desperte Mulher** é a primeira versão funcional (MVP) do front-end da plataforma `despertemulher.org`, reescrita em **Flutter Web** com qualidade de produção. Atualmente o site oficial roda em PHP/Laravel com débito técnico relevante; este repositório é a proposta de substituição que minha equipe acadêmica está apresentando ao idealizador para virar a próxima versão oficial.

A plataforma aplica a metodologia **AR PAX** — publicada por *Scarpelli, Silva & Pona (2024)* na **Revista Brasileira de Ciências Policiais** e adotada pelo **Tribunal de Justiça do Tocantins** — sobre as **27 perguntas do FONAR** (Formulário Nacional de Avaliação de Risco, instituído pela Resolução Conjunta nº 5/2020 do CNJ e CNMP). O resultado é uma classificação objetiva do risco em 5 níveis (Muito Baixo → Extremo).

### O problema que ele resolve

O FONAR é um instrumento padronizado de **coleta** de informação, mas não **calcula** o risco — a leitura ficava na intuição de quem aplicava o formulário. A AR PAX é o motor matemático que converte as 27 respostas em um grau de risco reproduzível e auditável.

---

## Stack e decisões técnicas

| Decisão | O que escolhi | Por quê |
|---|---|---|
| Plataforma | **Flutter Web** (exclusivamente) | A vítima **não pode** ter ícone "Desperte Mulher" no celular — o agressor veria. Por isso, web acessada pelo navegador, **nunca** APK/IPA. |
| Renderer | CanvasKit | O HTML renderer foi descontinuado no Flutter 3.27+; CanvasKit é o único caminho atual, e o overlay semântico do próprio Flutter ainda atende WCAG. |
| Estado | `setState` puro | Sem Provider/Riverpod/Bloc. O escopo (uma tela de quiz + estado em memória) não justifica máquina de estado distribuída. |
| Arquitetura | **Clean Architecture** em 3 camadas | `presentation` → `domain` → `data`. O motor AR PAX é Dart puro, testável sem Flutter, e pode ser substituído pela API Django (em construção paralela) trocando UM arquivo. |
| Persistência | **Zero** | Nenhuma resposta vai para localStorage, cookies ou servidor. Fechou a aba, apagou tudo. Isso é proteção da vítima — não preguiça de implementação. |
| Fonte de dados | JSON local com latência simulada | Mocks em `assets/mock/` com `Future.delayed(600ms)` simulando rede. Trocar pelo backend real é trivial. |
| Microcopy | Reescrita acolhedora | Sem "é indispensável", sem "Mesmo que o Risco seja Baixo, ele Existe!". Linguagem de convite, nunca de cobrança. |

---

## Arquitetura

```
lib/
├── common/                    Tema, strings, dimensões, rotas (centralizados)
│
├── domain/                    Dart puro — sem Flutter, 100% testável
│   ├── entities/              Pergunta, OpcaoResposta, RespostaUsuaria, ResultadoArpax,
│   │                          CriterioArpax (com pesos e tabelas Likert), NivelDimensao, GrauRisco
│   ├── repositories/          Contratos abstratos (interfaces)
│   └── usecases/              CalcularRiscoArpax (o motor) + cruzarMatriz (5×5)
│
├── data/                      Substituível: hoje JSON, amanhã API Django
│   ├── datasources/           QuizLocalDataSource (Future.delayed + rootBundle)
│   ├── models/                DTOs (espelham o JSON)
│   ├── mappers/               DTO ↔ Entity
│   └── repositories/          Implementações concretas
│
├── presentation/              Toda a UI
│   ├── pages/                 Home, Sobre, Análise, Apoios, Termos, Falar,
│   │                          Avaliação (5 etapas), Resultado, 404
│   └── widgets/               Design System reutilizável
│       ├── botoes/            Primário, Secundário, Texto, Saída Rápida
│       ├── cards/             CardPergunta (single+multiple), CardApoiador, CardResultado
│       ├── feedback/          MedidorRisco animado, ProgressoEtapas, BadgeSegurança
│       ├── layout/            HeaderApp, FooterApp, ScaffoldAcolhedor responsivo
│       └── seguranca/         AvisoHistoricoModal, ConfirmacaoSaidaModal
│
└── web/                       Helpers JS (saída rápida, deeplink tel:)
                               com conditional import para funcionar em testes
```

A regra é simples: **as setas só apontam para dentro**. `presentation` depende de `domain`. `data` implementa interfaces de `domain`. Quando o backend Django ficar pronto, apenas `data` muda. Quando redesenharmos a UI, apenas `presentation` muda. O motor AR PAX fica eterno.

---

## Motor AR PAX (o coração matemático)

A AR PAX modela `Risco = Probabilidade × Impacto`, mas como o impacto da violência doméstica grave é **inegociável** (envolve a vida da mulher), ele vira constante: **100% do cálculo concentra-se na Probabilidade**, que se decompõe em duas dimensões com três critérios cada:

| Dimensão | Critérios | Pesos |
|---|---|---|
| **Vulnerabilidade** | VC1 Atratibilidade, VC2 Exposição, VC3 Casuística | `1/3`, `1/2`, `1/4` |
| **Ameaça** | AC1 Motivação, AC2 Histórico, AC3 Tendência | `1`, `1/3`, `1/2` |

O motor executa 5 passos:

1. Conta opções **positivas** marcadas por critério (opções como "Não" / "Não sei" / "Nenhuma" não somam).
2. Converte contagem em **nível Likert (1-5)** via tabela específica por critério (com regra de saturação no teto).
3. Aplica pesos → **V_final** e **A_final**.
4. Classifica V_final e A_final em níveis Likert das dimensões.
5. Cruza Vulnerabilidade × Ameaça na **matriz 5×5** → grau final (MB / BA / MO / AL / EX).

### Validação matemática

O motor passa por três provas de fé verificadas em teste:

| Verificação | Esperado | Status |
|---|---|---|
| V_max = 5 × (1/3 + 1/2 + 1/4) = 5 × 13/12 | **5.4166…** | ✓ bate com Quadro 7 do artigo |
| A_max = 5 × (1 + 1/2 + 1/3) = 5 × 11/6 | **9.1666…** | ✓ bate com Quadro 7 do artigo |
| Cenário canônico do Silvano: P1 + P2(tapa+soco) + P3 | V=2.00, A=1.167 → **Muito Baixo** | ✓ bate com a planilha autoritativa |

São **51 testes** no total: motor, classificação por critério, todos os 25 cruzamentos da matriz e um walkthrough de widget que simula o usuário navegando Home → Termos → Avaliação para garantir que nada quebra em runtime.

---

## Decisões de UX e segurança da vítima

Algumas decisões não vieram da Apple HIG nem do Material Design — vieram da pesquisa sobre populações vulneráveis e dos princípios não-negociáveis do projeto:

- **Botão "Saída Rápida"** em toda página (com atalho `Esc`): limpa `sessionStorage`, sobrescreve a URL via `history.replaceState`, e redireciona pra `google.com` via `location.replace` — sem deixar entrada no histórico de navegação da aba.
- **Aviso de privacidade no primeiro acesso**: orienta o uso de aba anônima (que é a única forma real de não deixar rastro no histórico do navegador).
- **Manifest neutro** (`display: browser`, `short_name: "Site"`): impede instalação como PWA e disfarça atalhos.
- **Headers no `index.html`**: `Cache-Control: no-store`, `referrer: no-referrer`.
- **Microcopy reescrita**: substitui "Aceito e Quero Iniciar Avaliação" por "Compreendi — quero continuar"; substitui "Não Concordo" por "Tenho dúvidas — quero ler com calma".
- **Paleta acolhedora baseada em psicologia das cores**: lavanda + sálvia + terracota. Vermelho neon NÃO é usado nem no grau Extremo (bordô maduro `#8B4A47`) — vermelho saturado dispara cortisol em populações fragilizadas.
- **Áreas de toque ≥ 48px** (excede a WCAG de 44px).
- **Cor nunca é único canal de informação**: toda mensagem que depende de cor também tem ícone e texto.
- **Perguntas 2, 6 e 14 são checkbox** (no site atual estão como radio único — perda grave de dado clínico).

---

## Como rodar

Requisitos: **Flutter SDK 3.27+** e **Chrome**.

```bash
flutter pub get
flutter run -d chrome
```

Para acessar do celular na mesma Wi-Fi:

```bash
flutter run -d chrome --web-hostname=0.0.0.0 --web-port=8080
# Descubra o IP do PC com ipconfig e acesse http://<seu-ip>:8080 do celular
```

### Testes

```bash
flutter test
```

51 testes verdes cobrem motor AR PAX, classificação por critério, todos os 25 cruzamentos da matriz, leitura dos JSONs do FONAR e um walkthrough do fluxo principal.

### Build de produção

```bash
flutter build web --release
```

Saída em `build/web/`, pronta para Vercel, Firebase Hosting, GitHub Pages etc.

---

## Documentação

A pasta `docs/` carrega a especificação completa do projeto — sentí que era importante deixar isso versionado no repo:

- [`01_COMPILACAO_DADOS_PROJETO.md`](docs/01_COMPILACAO_DADOS_PROJETO.md) — metodologia AR PAX, texto literal das 27 perguntas do FONAR, mapeamento pergunta × critério, equipe e referências bibliográficas.
- [`02_PLANEJAMENTO_FRONTEND.md`](docs/02_PLANEJAMENTO_FRONTEND.md) — decisões técnicas justificadas, paleta, tipografia, microcopy, UML, plano de execução.

---

## Roadmap

Itens fora do escopo deste MVP, mas com arquitetura preparada:

- [ ] Integração com backend Django (atualmente em construção paralela). O `QuizRepository` é uma interface — basta trocar o `QuizLocalDataSource` por um `QuizRemoteDataSource` com Dio.
- [ ] **VLibras** integrado via plugin JS (slot já reservado no `index.html`).
- [ ] **Internacionalização** real PT/ES/EN (strings já centralizadas em `app_strings.dart`).
- [ ] Página de **Observatório** com gráficos e mapa, espelhando funcionalidade atual.
- [ ] Sistema **Acolhe** (área restrita para profissionais).

---

## Equipe e referências

- **Felipe Scarpelli de Andrade** — autor da metodologia AR PAX
- **Priscila A. M. Silva**, **Flavia Bueno Pona** — coautoras do artigo
- **Davi** — idealizador da plataforma e ponte institucional
- **Silvano Malfatti** — arquitetura técnica de referência
- **Codfy (eu)** — implementação deste MVP

**Citação acadêmica:**
> SCARPELLI DE ANDRADE, F.; SILVA, P. A. M.; PONA, F. B. Análise de Risco Pax e as Medidas Protetivas de Urgência: a conformação metodológica. *Revista Brasileira de Ciências Policiais*, Brasília, v. 15, n. 1, p. 17-51, jan-abr 2024.

---

## Licença

MIT.

---

<p align="center">
  feito com muito 💜 muito ☕ e com Claude<br/>
  <sub><em>(Spec-Driven Development — primeiro escrevo a especificação, depois o código segue a spec)</em></sub>
</p>
