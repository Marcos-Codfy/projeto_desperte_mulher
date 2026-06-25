# Desperte Mulher — MVP em Flutter Web

Plataforma de autoavaliação de risco de violência doméstica baseada na
metodologia **AR PAX** (Análise de Risco PAX) de Felipe Scarpelli de
Andrade et al. (2024), aplicada às 27 perguntas do **FONAR** (Resolução
Conjunta nº 5/2020 do CNJ e CNMP).

## Como rodar

Requer Flutter SDK 3.27+ instalado e Chrome.

```bash
flutter pub get
flutter run -d chrome
```

Pra rodar também acessível do celular na mesma Wi-Fi:

```bash
flutter run -d chrome --web-hostname=0.0.0.0 --web-port=8080
```

E acessar do celular em `http://<seu-ip>:8080` (descobrir IP com `ipconfig`).

## Como testar

```bash
flutter test
```

50 testes verdes cobrem o motor AR PAX, a leitura dos JSONs do FONAR e
um smoke test do fluxo Home → Termos.

## Como buildar pra produção

```bash
flutter build web --release
```

Saída em `build/web/`. Pode subir em Vercel, Firebase Hosting, GitHub
Pages, etc.

## Estrutura

```
lib/
├── common/            — tokens (tema, strings, dimensões, rotas)
├── domain/            — motor AR PAX (Dart puro, testável)
├── data/              — JSON mocks + DTOs + mappers + repository
├── presentation/      — telas + widgets reutilizáveis
└── web/               — helpers JS para saída rápida e deeplink tel:
```

A documentação completa do projeto está em `docs/`:
- `01_COMPILACAO_DADOS_PROJETO.md` — metodologia AR PAX, perguntas do
  FONAR, mapeamento pergunta×critério, equipe.
- `02_PLANEJAMENTO_FRONTEND.md` — decisões técnicas, paleta, microcopy,
  arquitetura, plano de execução.

## Princípios não-negociáveis

1. **Web, não app de loja.** Vítima não pode ter ícone "Desperte Mulher"
   no celular. Por isso `display: browser` no `manifest.json`.
2. **Sigilo do preenchimento.** Nada é salvo em localStorage, cookies
   ou servidor. Fechou a aba, apagou tudo.
3. **Acolhimento sobre alerta.** Paleta acolhedora (lavanda + sálvia +
   terracota), nunca vermelho neon — mesmo no resultado Extremo.
4. **Não alterar o FONAR.** Texto literal das 27 perguntas é
   regulamentação CNJ/CNMP.
5. **Cor nunca é único canal.** Toda mensagem que depende de cor
   também tem ícone ou texto.
6. **Saída rápida** sempre à mão (botão no header + tecla `Esc`).

## Validação científica do motor

O motor AR PAX é validado matematicamente por testes:
- V_max = 5 × (1/3 + 1/2 + 1/4) = **5.42** ✓ (bate com Quadro 7)
- A_max = 5 × (1 + 1/2 + 1/3) = **9.17** ✓ (bate com Quadro 7)
- Canário do Silvano: P1 + P2(tapa+soco) + P3 → V=2.00, A=1.167 → MB ✓

## Tecnologia

- **Flutter Web** com renderer HTML (não CanvasKit) — necessário pra
  acessibilidade real (WCAG, screen readers, VLibras futuro).
- **State management:** `setState` puro. Sem Provider/Riverpod/Bloc.
- **Persistência:** zero. RAM apenas.
- **Arquitetura:** Clean Architecture em 3 camadas
  (`presentation` → `domain` → `data`).
- **HTTP:** nenhum por enquanto (JSON local). O `QuizRepository` é
  uma interface — substituir por API Django futura troca 1 arquivo.

## Coautores

- **Felipe Scarpelli de Andrade** — metodologia AR PAX
- **Priscila A. M. Silva**, **Flavia Bueno Pona** — coautoria do artigo
- **Davi** — idealizador e ponte institucional
- **Silvano Malfatti** — arquitetura técnica de referência
- **Codfy** — implementação do MVP (este repositório)
