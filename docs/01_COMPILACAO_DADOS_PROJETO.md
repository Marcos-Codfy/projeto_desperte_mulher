# Compilação de Dados — Projeto Desperte Mulher

> **Propósito deste arquivo:** consolidar TUDO que foi descoberto sobre o projeto até agora, em um único documento, para servir de contexto rápido em futuras conversas e como referência da equipe.
>
> **Última atualização:** 24/06/2026  
> **Etapa do projeto:** pré-implementação do front-end (Etapas 1-3 já entregues como prova de conceito)

---

## Índice

1. [Visão geral do projeto](#1-visão-geral-do-projeto)
2. [Equipe e papéis](#2-equipe-e-papéis)
3. [Metodologia AR PAX — explicação completa](#3-metodologia-ar-pax--explicação-completa)
4. [Fórmula do cálculo de risco (validada com a planilha)](#4-fórmula-do-cálculo-de-risco-validada-com-a-planilha)
5. [As 27 perguntas oficiais do FONAR (texto integral)](#5-as-27-perguntas-oficiais-do-fonar-texto-integral)
6. [Mapeamento pergunta × critério](#6-mapeamento-pergunta--critério)
7. [Princípios não-negociáveis](#7-princípios-não-negociáveis)
8. [Análise do site atual (despertemulher.org)](#8-análise-do-site-atual-despertemulhorg)
9. [Repositório de referência do Silvano Malfatti](#9-repositório-de-referência-do-silvano-malfatti)
10. [Anotações da reunião de 18/06/2026](#10-anotações-da-reunião-de-18062026)
11. [Inventário de assets disponíveis](#11-inventário-de-assets-disponíveis)
12. [Stack do site legado e plano de migração da equipe Django](#12-stack-do-site-legado-e-plano-de-migração-da-equipe-django)
13. [Pendências e issues abertos](#13-pendências-e-issues-abertos)

---

## 1. Visão geral do projeto

**Desperte Mulher** é uma plataforma web pública de **autoavaliação de risco de violência doméstica**, voltada principalmente a mulheres em situação de vulnerabilidade. Atualmente está em operação em `https://despertemulher.org` (PHP/Laravel com bastante débito técnico).

A plataforma aplica a metodologia científica **AR PAX (Análise de Risco PAX)**, criada por **Felipe Scarpelli de Andrade** e publicada em artigo na *Revista Brasileira de Ciências Policiais* (v. 15, n. 1, jan-abr/2024). A metodologia já é adotada pelo **TJ-TO** e tem institucionalização pela **Secretaria da Mulher do Tocantins**, com parcerias confirmadas com Casa da Mulher Brasileira, Casa da Mulher Tocantinense (Gurupi), CNJ, CNMP, Polícia Civil/Militar, Patrulha Maria da Penha, OAB-TO, Lions Club, entre outros.

**O problema que ela resolve:** o FONAR (Formulário Nacional de Avaliação de Risco, instituído pela Resolução Conjunta nº 5/2020 do CNJ e CNMP) é um instrumento padronizado de **coleta**, mas não **calcula** risco. Antes da AR PAX, a interpretação ficava na intuição do profissional que aplicava o formulário. A AR PAX é o motor matemático que transforma as 27 respostas em um grau de risco objetivo classificado em 5 níveis (Muito Baixo, Baixo, Moderado, Alto, Extremo).

**O escopo deste trabalho acadêmico:** construir um **MVP em Flutter** do front-end completo, espelhando o site atual mas com qualidade técnica e UX/UI superior. Se aprovado por Davi (idealizador e ponte institucional), o código vira a base oficial da próxima versão. Backend Django/DRF está em planejamento paralelo por outra frente; nosso MVP simula o cálculo localmente até a API existir.

---

## 2. Equipe e papéis

| Pessoa | Papel | O que ele entrega ao projeto |
| --- | --- | --- |
| **Davi** | Idealizador e ponte institucional | Articulou as parcerias (Secretaria da Mulher, instituições, polícia, justiça). Não é programador. Vai avaliar o resultado e, se aprovado, adotar nosso código no projeto oficial. **Tem que entregar:** logotipo em alta resolução e elementos gráficos. |
| **Felipe Scarpelli de Andrade** | Autor da metodologia AR PAX | Define o "como calcular" o risco. Toda dúvida sobre interpretação da fórmula passa por ele. Coautores do artigo: Priscila Aparecida de Macedo e Silva, Flavia Bueno Pona. |
| **Silvano Malfatti** | Arquiteto técnico de referência | Criou o repositório-template `github.com/malfattito/quiz_flutter` em 13/06/2026. Defende: aplicação web (não app), anonimato por padrão, feedback visual contínuo, paleta acolhedora, mobile-first, performance, acessibilidade séria (VLibras avatar feminino, alto contraste, daltonismo). Estilo técnico: Material puro, sem libs externas de state management. |
| **Codfy (eu/usuário)** | Desenvolvedor do MVP em Flutter | Implementação completa do front-end. Estudante. Conhecimento básico em Flutter/Dart. Trabalha em PT-BR. Ambiente: Win11 + Android Studio Quail 1 / 2026.1.1 Patch 2, em `C:\dev\projeto_desperte_mulher`. Testa em Chrome e em celular via cabo USB. |

---

## 3. Metodologia AR PAX — explicação completa

### 3.1 Princípio fundamental

A AR PAX parte da equação clássica de gestão de risco:

> **Risco = Probabilidade × Impacto**

Mas faz uma escolha metodológica forte: como o impacto da violência doméstica grave é **inegociável** (envolve a vida da mulher), ele vira uma **constante** — não é parâmetro do cálculo. Isso significa que **100% do cálculo concentra-se na Probabilidade**.

### 3.2 A Probabilidade é decomposta em duas dimensões

A Probabilidade é definida como o cruzamento entre:

- **VULNERABILIDADE** da vítima — quanto ela está suscetível a sofrer
- **AMEAÇA** do agressor — quanto ele tende a concretizar

Cada uma é composta de **três critérios**:

#### Vulnerabilidade (3 critérios)

- **VC1 — Atratibilidade**  
  Características intrínsecas da vítima que aumentam a fragilidade explorável. Inclui: gravidez atual/recente, idade avançada, dependência financeira, deficiência/doença degenerativa, raça/cor/etnia, doença mental, diferenças culturais com o agressor, migração/refúgio, orientação sexual/identidade de gênero, residência em local de risco.

- **VC2 — Exposição**  
  Atitudes, comportamentos e situações da vítima que aumentam a suscetibilidade. Inclui: ato sexual forçado, ocorrência policial prévia, separação recente, conflito sobre bens/guarda/pensão, violência na gravidez, filhos como testemunhas, novo relacionamento.

- **VC3 — Casuística**  
  Eventos danosos ou hostis anteriores perpetrados contra a vítima ou seus familiares. Inclui: agressão prévia, atos sexuais forçados, registros policiais anteriores, ameaças recentes, violência na gravidez.

#### Ameaça (3 critérios)

- **AC1 — Motivação**  
  O pretexto ou estado que induziu o agressor a ameaçar. Inclui: ausência de referência familiar/social, transtorno/doença mental comprovada, vaidade/vingança/ciúme/possessividade/machismo/controle, dificuldades financeiras, violência sexual, uso de medicação controlada, álcool/drogas, ideação suicida.

- **AC2 — Histórico**  
  Registros pretéritos de ameaças e ações concretizadas pelo agressor. Inclui: eventos danosos anteriores, descumprimento de medidas protetivas, ameaça recente (últimos 6 meses), stalking, violência sexual, álcool/drogas, ideação suicida, ameaças a filhos/familiares/colegas/animais.

- **AC3 — Tendência**  
  Capacidade do agressor concretizar a ameaça (oportunidade, acesso, inclinação). Inclui: acesso a arma branca/fogo, recursos financeiros, planejamento, conluio, possibilidade de deslocamento, antecedentes criminais, coabitação com a vítima, fácil acesso a locais frequentados pela vítima, continuidade delitiva, recrudescimento das ameaças, ameaças a terceiros, ações preparatórias.

### 3.3 Por que esses 6 critérios e não outros

Eles vêm do trabalho de Andrade (2017, 2019) e foram validados teoricamente no artigo de Scarpelli et al. (2024). A grande inovação metodológica é **separar matematicamente** a Vulnerabilidade da Ameaça — sem isso, o FONAR tradicional só tem listas binárias sem capacidade de gradação.

### 3.4 Por que uma escala Likert de 5 níveis

Porque escalas binárias (Sim/Não) ou de 3 níveis perdem nuance. A escala de 5 níveis (Muito Baixa, Baixa, Média, Alta, Muito Alta para Vulnerabilidade; Insignificante, Pequena, Moderada, Significante, Extrema para Ameaça) é o padrão clássico de Likert validado em ciências sociais, e permite distribuir as respostas em uma normal aproximada (14%/20%/25%/20%/14%).

### 3.5 Por que uma matriz 5×5

Porque ela cruza as duas dimensões (V × A) em apenas 25 células, suficientes para uma classificação final em 5 graus (MB, BA, MO, AL, EX) sem explosão combinatória. É a forma padrão de gestão de risco em segurança institucional.

---

## 4. Fórmula do cálculo de risco (validada com a planilha)

> **Fonte autoritativa desta fórmula:** aba `NÍVEL CRITÉRIO` do arquivo `Planilha Ajustada.xlsm`, validada cruzando com o Quadro 7 e Quadro 8 do artigo de Scarpelli (2024).

### 4.1 Passo 1 — Contar marcações por critério

Cada uma das 27 perguntas do FONAR alimenta **um ou mais critérios** (ver mapeamento na seção 6). Quando a usuária responde **positivamente** a uma opção, esse "ponto" é contabilizado em cada critério que a pergunta alimenta.

Exemplo: a pergunta 21 ("Se você está em um novo relacionamento, as ameaças ou as agressões físicas aumentaram em razão disso?") alimenta **5 critérios**: VC2, VC3, AC1, AC2, AC3. Se a resposta for "Sim", todos os 5 contadores ganham 1.

**Importante — perguntas com múltiplas opções:** perguntas como a 2 ("dessas agressões físicas, quais...?") têm 14 opções. Cada opção marcada conta como 1 marcação no(s) critério(s) alimentado(s) pela pergunta. **Não é "1 ponto por pergunta", é "1 ponto por opção marcada".**

### 4.2 Passo 2 — Converter contagem em Nível Likert (1 a 5)

Cada critério tem sua própria tabela de faixas, conforme o número de marcações:

#### VULNERABILIDADE

**VC1 — Atratibilidade** (máximo 7 marcações possíveis)

| Marcações | Nível | Valor Likert |
| --- | --- | --- |
| 1 | Muito Baixa | 1 |
| 2 a 3 | Baixa | 2 |
| 4 | Média | 3 |
| 5 a 6 | Alta | 4 |
| 7 | Muito Alta | 5 |

**VC2 — Exposição** (máximo 8 marcações possíveis)

| Marcações | Nível | Valor Likert |
| --- | --- | --- |
| 0 a 1 | Muito Baixa | 1 |
| 2 a 3 | Baixa | 2 |
| 4 | Média | 3 |
| 5 a 6 | Alta | 4 |
| 7 a 8 | Muito Alta | 5 |

**VC3 — Casuística** (máximo 14 marcações possíveis)

| Marcações | Nível | Valor Likert |
| --- | --- | --- |
| 1 a 2 | Muito Baixa | 1 |
| 3 a 5 | Baixa | 2 |
| 6 a 7 | Média | 3 |
| 8 a 10 | Alta | 4 |
| 11 a 14 | Muito Alta | 5 |

#### AMEAÇA

**AC1 — Motivação** (máximo 12 marcações possíveis)

| Marcações | Nível | Valor Likert |
| --- | --- | --- |
| 1 a 2 | Insignificante | 1 |
| 3 a 5 | Pequena | 2 |
| 6 a 7 | Moderada | 3 |
| 8 a 10 | Significante | 4 |
| 11 a 12 | Extrema | 5 |

**AC2 — Histórico** (máximo 14 marcações possíveis)

| Marcações | Nível | Valor Likert |
| --- | --- | --- |
| 1 a 2 | Insignificante | 1 |
| 3 a 5 | Pequena | 2 |
| 6 a 7 | Moderada | 3 |
| 8 a 10 | Significante | 4 |
| 11 a 14 | Extrema | 5 |

**AC3 — Tendência** (máximo 16 marcações possíveis)

| Marcações | Nível | Valor Likert |
| --- | --- | --- |
| 1 a 3 | Insignificante | 1 |
| 4 a 6 | Pequena | 2 |
| 7 a 9 | Moderada | 3 |
| 10 a 12 | Significante | 4 |
| 13 a 16 | Extrema | 5 |

> **Observação importante (lógica de saturação):** quando um critério atinge o nível máximo (5), o sistema para de contar nele. Marcações adicionais não somam — o objetivo é evitar inflação por redundância nas perguntas. Essa regra foi citada por Silvano Malfatti em reunião e está implícita na natureza da tabela (faixas truncadas no topo).

### 4.3 Passo 3 — Aplicar os pesos de precedência

Cada critério tem um peso de precedência diferente, refletindo sua importância relativa dentro da dimensão. **Os pesos foram extraídos diretamente da aba `NÍVEL CRITÉRIO` da planilha (células K3 a K5 e N3 a N5):**

#### Pesos da VULNERABILIDADE

| Critério | Peso (fração) | Peso (decimal) |
| --- | --- | --- |
| **VC2 — Exposição** | 1/2 | 0.500 |
| **VC1 — Atratibilidade** | 1/3 | 0.333 |
| **VC3 — Casuística** | 1/4 | 0.250 |

#### Pesos da AMEAÇA

| Critério | Peso (fração) | Peso (decimal) |
| --- | --- | --- |
| **AC1 — Motivação** | 1 | 1.000 |
| **AC3 — Tendência** | 1/2 | 0.500 |
| **AC2 — Histórico** | 1/3 | 0.333 |

> **Nota:** os pesos das duas dimensões seguem padrões matemáticos distintos. Na Vulnerabilidade, os denominadores são 2, 3, 4 (1 + soma 6/12 + 4/12 + 3/12). Na Ameaça, são 1, 2, 3. Isso é o que faz a escala da Ameaça ir até 9.17 (maior que 5.42 da Vulnerabilidade). O Felipe Scarpelli é quem desenhou essa proporção propositalmente: dá um peso maior à Ameaça porque, na prática, a Ameaça é o que "puxa o gatilho" do risco extremo.

### 4.4 Passo 4 — Calcular Vulnerabilidade Final e Ameaça Final

**Fórmulas:**

```
V_final = (Nivel_VC1 × 1/3) + (Nivel_VC2 × 1/2) + (Nivel_VC3 × 1/4)

A_final = (Nivel_AC1 × 1)   + (Nivel_AC2 × 1/3) + (Nivel_AC3 × 1/2)
```

**Validação matemática (prova de que a fórmula está correta):**

- V_máximo = 5 × (1/3 + 1/2 + 1/4) = 5 × (4/12 + 6/12 + 3/12) = 5 × 13/12 = **5.4166...** → bate exatamente com o limite superior `5.42` do Quadro 7 do Scarpelli ✓
- A_máximo = 5 × (1 + 1/2 + 1/3) = 5 × (6/6 + 3/6 + 2/6) = 5 × 11/6 = **9.1666...** → bate exatamente com o limite superior `9.17` do Quadro 7 do Scarpelli ✓
- V_mínimo (com 1 marcação só em Atratibilidade) = 1 × 1/3 = **0.333...** → bate com o limite inferior `0.33` ✓
- A_mínimo = 0 (nenhuma marcação) → bate com o limite inferior `0.00` ✓

### 4.5 Passo 5 — Classificar V_final e A_final em níveis Likert (Quadro 7 do artigo)

#### Faixas da Vulnerabilidade

| V_final | Nível |
| --- | --- |
| 0.33 a 1.09 | Muito Baixa |
| 1.10 a 2.21 | Baixa |
| 2.22 a 3.58 | Média |
| 3.59 a 4.65 | Alta |
| 4.66 a 5.42 | Muito Alta |

#### Faixas da Ameaça

| A_final | Nível |
| --- | --- |
| 0.00 a 1.32 | Insignificante |
| 1.33 a 3.20 | Pequena |
| 3.21 a 6.04 | Moderada |
| 6.05 a 7.84 | Significante |
| 7.85 a 9.17 | Extrema |

> **Proporções aproximadas em cada banda:** 14% – 20% – 25% – 20% – 14%. Essa é uma distribuição com cauda nas extremidades, típica do Likert ajustado.

### 4.6 Passo 6 — Cruzar na Matriz de Risco 5×5 (Quadro 8 do artigo)

A célula resultante da matriz é o **grau final de risco**, em uma escala de 5 níveis:

| | INSIGNIFICANTE | PEQUENA | MODERADA | SIGNIFICANTE | EXTREMA |
| --- | :---: | :---: | :---: | :---: | :---: |
| **MUITO BAIXA** | MB | MB | BA | AL | AL |
| **BAIXA** | MB | BA | MO | AL | AL |
| **MÉDIA** | BA | BA | MO | EX | EX |
| **ALTA** | BA | MO | AL | EX | EX |
| **MUITO ALTA** | MO | MO | AL | EX | EX |

Legenda:
- **MB** = Muito Baixo
- **BA** = Baixo
- **MO** = Moderado
- **AL** = Alto
- **EX** = Extremo

### 4.7 Exemplo numérico de validação ponta-a-ponta

Cenário fictício: usuária responde positivamente apenas às perguntas 1 ("já ameaçou"), 2 (marcou "tapa" e "soco") e 3 ("sim, atendimento médico").

Aplicando o mapeamento (seção 6):

- Pergunta 1 → marca VC2, VC3, AC2, AC3
- Pergunta 2 com 2 opções marcadas → marca VC2 (×2), VC3 (×2), AC2 (×2), AC3 (×2)
- Pergunta 3 → marca VC2, AC2

**Contadores:**
- VC1 = 0
- VC2 = 1 + 2 + 1 = **4 marcações** → nível 3 (Média)
- VC3 = 1 + 2 + 0 = **3 marcações** → nível 2 (Baixa)
- AC1 = 0
- AC2 = 1 + 2 + 1 = **4 marcações** → nível 2 (Pequena)
- AC3 = 1 + 2 + 0 = **3 marcações** → nível 1 (Insignificante)

**Aplicando pesos:**
- V_final = (0 × 1/3) + (3 × 1/2) + (2 × 1/4) = 0 + 1.5 + 0.5 = **2.00** → **Baixa**
- A_final = (0 × 1) + (2 × 1/3) + (1 × 1/2) = 0 + 0.667 + 0.5 = **1.167** → **Insignificante**

**Cruzando na matriz:**
- Linha "Baixa" × Coluna "Insignificante" = **MB (Muito Baixo)**

Esse resultado bate com o exemplo cenário da planilha (cenário V=0.5/A=1.167 → MB).

---

## 5. As 27 perguntas oficiais do FONAR (texto integral)

> **Fonte:** aba `QUESTIONÁRIO` do arquivo `Planilha Ajustada.xlsm`, conferida contra o Quadro 6 do artigo do Scarpelli (2024).
>
> **ATENÇÃO LEGAL:** este texto **não pode ser alterado**. O FONAR é instrumento oficial instituído pela Resolução Conjunta nº 5/2020 do CNJ e CNMP. Podemos mudar a apresentação (UI), a ordem em que cada bloco aparece, microcopy de apoio AO REDOR das perguntas — mas o enunciado da pergunta e o texto das opções de resposta devem permanecer literais.

### BLOCO I — Sobre o histórico de violência

**1.** O(A) agressor(a) já ameaçou você ou algum familiar com a finalidade de atingi-la?
- ( ) Sim, utilizando arma de fogo
- ( ) Sim, utilizando faca
- ( ) Sim, de outra forma
- ( ) Não

**2.** O(A) agressor(a) já praticou alguma(s) dessas agressões físicas contra você?
- ( ) Queimadura
- ( ) Enforcamento
- ( ) Sufocamento
- ( ) Estrangulamento
- ( ) Tiro
- ( ) Afogamento
- ( ) Facada
- ( ) Paulada
- ( ) Soco
- ( ) Chute
- ( ) Tapa
- ( ) Empurrão
- ( ) Puxão de Cabelo
- ( ) Outra. Especificar: __________________________________
- ( ) Nenhuma agressão física

**3.** Você necessitou de atendimento médico e/ou internação após algumas dessas agressões?
- ( ) Sim, atendimento médico
- ( ) Sim, internação
- ( ) Não

**4.** O(A) agressor(a) já obrigou você a ter relações sexuais ou praticar atos sexuais contra a sua vontade?
- ( ) Sim
- ( ) Não
- ( ) Não sei

**5.** O(A) agressor(a) persegue você, demonstra ciúme excessivo, tenta controlar sua vida e as coisas que você faz? (aonde você vai, com quem conversa, o tipo de roupa que usa etc.)
- ( ) Sim
- ( ) Não
- ( ) Não sei

**6.** O(A) agressor(a) já teve algum destes comportamentos?
- ( ) Disse algo parecido com a frase: "se não for minha, não será de mais ninguém"
- ( ) Perturbou, perseguiu ou vigiou você nos locais que frequenta
- ( ) Proibiu você de visitar familiares ou amigos
- ( ) Proibiu você de trabalhar ou estudar
- ( ) Fez telefonemas, enviou mensagens pelo celular ou e-mails de forma insistente
- ( ) Impediu você de ter acesso a dinheiro, conta bancária ou outros bens (como documentos pessoais, carro)
- ( ) Teve outros comportamentos de ciúme excessivo e de controle sobre você
- ( ) Nenhum dos comportamentos acima listados

**7.a** Você já registrou ocorrência policial ou formulou pedido de medida protetiva de urgência envolvendo esse(a) mesmo(a) agressor(a)?
- ( ) Sim
- ( ) Não

**7.b** O(A) agressor(a) já descumpriu medida protetiva anteriormente?
- ( ) Sim
- ( ) Não
- ( ) Não sei

**8.** As agressões ou ameaças do(a) agressor(a) contra você se tornaram mais frequentes ou mais graves nos últimos meses?
- ( ) Sim
- ( ) Não
- ( ) Não sei

### BLOCO II — Sobre o(a) agressor(a)

**9.** O(A) agressor(a) faz uso abusivo de álcool ou de drogas ou medicamentos?
- ( ) Sim, de álcool
- ( ) Sim, de drogas
- ( ) Sim, de medicamentos
- ( ) Não
- ( ) Não sei

**10.** O(A) agressor(a) tem alguma doença mental comprovada por avaliação médica?
- ( ) Sim e faz uso de medicação
- ( ) Sim e não faz uso de medicação
- ( ) Não
- ( ) Não sei

**11.** O(A) agressor(a) já tentou suicídio ou falou em suicidar-se?
- ( ) Sim
- ( ) Não
- ( ) Não sei

**12.** O(A) agressor(a) está com dificuldades financeiras, está desempregado ou tem dificuldade de se manter no emprego?
- ( ) Sim
- ( ) Não
- ( ) Não sei

**13.** O(A) agressor(a) já usou, ameaçou usar arma de fogo contra você ou tem fácil acesso a uma arma?
- ( ) Sim, usou
- ( ) Sim, ameaçou usar
- ( ) Tem fácil acesso
- ( ) Não
- ( ) Não sei

**14.** O(A) agressor(a) já ameaçou ou agrediu seus filhos, outros familiares, amigos, colegas de trabalho, pessoas desconhecidas ou animais?
- ( ) Sim, filhos
- ( ) Sim, outros familiares
- ( ) Sim, amigos
- ( ) Sim, colegas de trabalho
- ( ) Sim, outras pessoas
- ( ) Sim, animais
- ( ) Não
- ( ) Não sei

### BLOCO III — Sobre você

**15.** Você se separou recentemente do(a) agressor(a), tentou ou manifestou intenção de se separar?
- ( ) Sim
- ( ) Não

**16.a** Você tem filhos?
- ( ) Sim, com o(a) agressor(a). Quantos? ____
- ( ) Sim, de outro relacionamento. Quantos? ____
- ( ) Não

**16.b** Qual a faixa etária de seus filhos? (Se tiver mais de um filho, pode assinalar mais de uma opção)
- ( ) 0 a 11 anos
- ( ) 12 a 17 anos
- ( ) A partir de 18 anos

**16.c** Algum de seus filhos é pessoa com deficiência?
- ( ) Sim
- ( ) Não

**17.** Estão vivendo algum conflito com relação à guarda dos filhos, visitas ou pagamento de pensão pelo agressor?
- ( ) Sim
- ( ) Não
- ( ) Não sei

**18.** Seu(s) filho(s) já presenciaram ato(s) de violência do(a) agressor(a) contra você?
- ( ) Sim
- ( ) Não

**19.** Você sofreu algum tipo de violência durante a gravidez ou nos três meses posteriores ao parto?
- ( ) Sim
- ( ) Não

**20.** Você está grávida ou teve bebê nos últimos 18 meses?
- ( ) Sim
- ( ) Não

**21.** Se você está em um novo relacionamento, as ameaças ou as agressões físicas aumentaram em razão disso?
- ( ) Sim
- ( ) Não

**22.** Você possui alguma deficiência ou doença degenerativa que acarretam condição limitante ou de vulnerabilidade física ou mental?
- ( ) Sim. Qual(is)? ____
- ( ) Não

**23.** Com qual cor/raça você se identifica:
- ( ) Branca
- ( ) Preta
- ( ) Parda
- ( ) Amarela/oriental
- ( ) Indígena

### BLOCO IV — Outras informações importantes

**24.** Você considera que mora em bairro, comunidade, área rural ou local de risco de violência?
- ( ) Sim
- ( ) Não
- ( ) Não sei

**25.** Qual sua situação de moradia?
- ( ) Própria
- ( ) Alugada
- ( ) Cedida ou "de favor". Por quem? ____

**26.** Você se considera dependente financeiramente do(a) agressor(a)?
- ( ) Sim
- ( ) Não

**27.** Você quer e aceita abrigamento temporário?
- ( ) Sim
- ( ) Não

---

## 6. Mapeamento pergunta × critério

> **Fonte:** combinação da aba `CRITÉRIOS` da planilha (lista por critério quais quesitos alimentam) com o Quadro 6 do artigo de Scarpelli (2024).
>
> **Status:** consolidado, mas com **2 divergências de baixa criticidade** entre a planilha e o artigo. Marcadas como ⚠️ na tabela abaixo. Tratamento: implementação seguirá o **artigo do Scarpelli** como autoritativo, e a divergência fica como issue para ser confirmada com o Felipe Scarpelli.

Tabela completa (✓ = pergunta alimenta esse critério):

| Pergunta | VC1 Atrat. | VC2 Expos. | VC3 Casu. | AC1 Motiv. | AC2 Hist. | AC3 Tend. |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| 1 | | ✓ | ✓ | | ✓ | ✓ |
| 2 | | ✓ | ✓ | | ✓ | ✓ |
| 3 | | ✓ | ✓ | | ✓ | ✓ |
| 4 | | ✓ | ✓ | | ✓ | |
| 5 | | | | ✓ | ✓ | |
| 6 | | | | ✓ | ✓ | |
| 7.a | | ✓ | ✓ | | | ✓ |
| 7.b | | | | | ✓ | |
| 8 | | ✓ | ✓ | | ✓ | ✓ |
| 9 | | | | ✓ | ✓ | |
| 10 | | | | ✓ | | |
| 11 | | | | ✓ | ✓ | |
| 12 | | | | ✓ | | |
| 13 | | ✓ | ✓ | | ✓ | ✓ |
| 14 | | | | | ✓ | ✓ |
| 15 | | ✓ | | | | |
| 16.a | ✓ | | | | | |
| 16.b ⚠️ | (retirar — planilha) | | | | | |
| 16.c ⚠️ | (retirar — planilha) | | | | | |
| 17 | | ✓ | | | | |
| 18 | | ✓ | ✓ | | | |
| 19 | ✓ | | ✓ | ✓ | | |
| 20 | ✓ | | | | | |
| 21 | | ✓ | ✓ | ✓ | ✓ | ✓ |
| 22 | ✓ | | | | | |
| 23 | ✓ | | | | | |
| 24 | ✓ | ✓ | | | | |
| 25 | | ✓ | | | | |
| 26 | ✓ | ✓ | | ✓ | | |
| 27 | | ✓ | | | | |

**Totais por critério (somando todas as ✓):**
- VC1 Atratibilidade: 7 perguntas
- VC2 Exposição: 12 perguntas
- VC3 Casuística: 10 perguntas
- AC1 Motivação: 10 perguntas
- AC2 Histórico: 10 perguntas
- AC3 Tendência: 9 perguntas

> **Atenção:** estes totais somam **perguntas**, mas o cálculo real é em **opções marcadas**. Como várias perguntas têm múltiplas opções positivas (notadamente a 2 com 14, a 6 com 7, e a 14 com 6), o total real de "marcações possíveis" por critério é maior, batendo com os máximos das tabelas de classificação: VC1=7, VC2=8, VC3=14, AC1=12, AC2=14, AC3=16. O bater desses números entre a planilha e o artigo é a evidência forte de que o mapeamento está correto.

---

## 7. Princípios não-negociáveis

Compilados a partir das anotações da reunião com Silvano Malfatti (18/06/2026) e da documentação do projeto:

### 7.1 Plataforma

1. **É WEB, não app nativo de loja.** O agressor não pode ver um ícone "Desperte Mulher" no celular da vítima. Por isso é Flutter Web, **nunca** APK/IPA distribuído. PWA opcional, mas com extremo cuidado para não criar ícone na home.

2. **Sigilo do preenchimento incompleto.** Se a pessoa fecha o navegador antes de finalizar, nada é persistido. Protege a vítima.

3. **Limpeza de cache/histórico** como ponto de atenção. Botão "saída rápida + limpar rastros" é uma boa prática neste tipo de site.

### 7.2 Comunicação

4. **Anonimato por padrão.** Identificação só é oferecida APÓS o resultado, e é totalmente opcional.

5. **Não exigir nada da vítima.** Linguagem nunca imperativa, nunca cobrança, nunca culpabilização. **Convite, não ordem.**

6. **Feedback visual contínuo** durante o preenchimento. Medidor de risco evoluindo, barra de progresso, microinterações — a vítima precisa ver "algo acontecendo" ou abandona antes do fim.

7. **Foco em "pessoa", não em "mulher".** Embora o público principal seja mulher, a comunicação deve acolher também outros perfis (homem-homem, idoso, etc.).

### 7.3 Visual

8. **Psicologia das cores acolhedora.** Evitar vermelhos saturados, alaranjados agressivos, contrastes excitantes. Tons que acalmam: lilás/lavanda, rosa empoeirado, verde-sálvia, off-white, cinza-quente. Vermelho **só no resultado Extremo**, e mesmo assim em tom terroso, não neon.

9. **Responsividade obrigatória, mobile-first.** A vítima provavelmente só tem o celular. Mínimo 1024×768 para desktop, mas o ponto de partida é o smartphone (375×812).

### 7.4 Performance e acesso

10. **Performance.** Rápido, leve, sem travamento. Uma página que demora pode ser a página que ela fechou e nunca mais abriu.

11. **Acessibilidade séria.** VLibras com avatar feminino, alto contraste, daltonismo, screen reader. Nem todo surdo lê texto fluente — daí o Libras importar de verdade. **O VLibras não entra no MVP, mas a arquitetura deve facilitar plugar depois.**

### 7.5 Conteúdo

12. **Não alterar o formulário.** O conteúdo FONAR é rígido (CNJ/CNMP). Pode mudar o **como** se apresenta, nunca o **que** se pergunta.

---

## 8. Análise do site atual (despertemulher.org)

> **Fonte:** auditoria técnica via Claude MCP Browser realizada em 24/06/2026, em viewports mobile (375×812) e desktop (1280×800).

### 8.1 Páginas do site

`/` · `/sobre` · `/apoios` · `/analise` · `/termosuso` · `/avaliacao` (5 etapas) · `/observatorio` · `/atendimento` · `/falar` · `/login`

### 8.2 Paleta de cores atual (extraída das CSS custom properties)

| Variável | Hex | Uso |
| --- | --- | --- |
| `--rose` | `#C2527A` | Botões ativos, círculos de step, bordas |
| `--rose-deep` | `#8B2F52` | Títulos, links, botão "Voltar" |
| `--rose-light` | `#F7E6ED` | Fundos suaves de hover |
| `--lavender` | `#9B7BAF` | Acentos secundários |
| `--lavender-light` | `#EDE6F5` | Fundos de seção alternada |
| `--sage` | `#7BAE8C` | Ícones de positivo, badges |
| `--sage-light` | `#E6F2EA` | Fundo de cards positivos |
| `--warm-cream` | `#FDF8F5` | Fundo geral |
| `--warm-beige` | `#F5EDE8` | Fundo alternativo |
| `--text-dark` | `#3A2535` | Texto principal |
| `--text-mid` | `#6B4E5E` | Texto secundário, labels |
| `--text-light` | `#9D7A8A` | Placeholders |
| Vermelho erro | `#DC3545` | Borda de validação |

### 8.3 Tipografia atual

- **Body:** Lato 400, 16px
- **H1 hero:** Playfair Display 600-700 serif, 48-64px (com itálico rosa nos termos de empoderamento: "liberdade!", "Vida!", "Verdade!")
- **H2:** Playfair Display 600 serif, ~29px
- **Labels formulário:** Lato 500, 16px
- **Botões:** Lato 600, 15-16px

### 8.4 Problemas identificados (priorizados)

**Críticos:**
- ❌ Pergunta 2 usa `radio` (seleção única) quando deveria ser `checkbox` (15 opções de tipos de agressão, vítima pode ter sofrido várias). **Perda grave de dado clínico.**
- ❌ Mesmo problema nas perguntas 6 (comportamentos do agressor, 7 opções) e 14 (ameaças a terceiros, 8 opções).
- ❌ Saltos graves na hierarquia de headings (H2 → H5 → H6 sem passar pelos níveis intermediários).
- ❌ Alt-text genérico em logos de parceiros (`alt="logodoc"`) — inútil para leitores de tela.
- ❌ Validação puramente visual (borda vermelha) sem mensagem de texto nem `aria-invalid`.
- ❌ Não há botão de "saída rápida".
- ❌ Não há aviso sobre histórico do navegador.
- ❌ Botão "Imprimir Avaliação" disponível na etapa 5 sem alerta de segurança (agressor pode encontrar a impressão).
- ❌ Página `/atendimento` coleta CPF sem máscara visível — dado sensível.

**Médios:**
- ⚠️ Contraste do botão `#C2527A` sobre branco fica em ~4.1:1 (borderline WCAG AA para texto pequeno).
- ⚠️ Placeholder `#9D7A8A` sobre branco em ~3.1:1 (falha WCAG AA).
- ⚠️ Em mobile (375px), os círculos do step indicator ficam apertados.
- ⚠️ Áreas de toque dos radios nativos em ~18×18px (mínimo WCAG é 44×44).
- ⚠️ Microcopy do banner do formulário: "Mesmo que o Risco seja Baixo, ele Existe!" — pressiona a usuária.
- ⚠️ Erro tipográfico em `/sobre`: "criaram **jutos** essa ferramenta" (deveria ser "juntos").

**Pontos positivos a preservar:**
- ✅ Microcopy boa em vários lugares: "Você não precisa ter certeza de nada para começar", "Você decide o ritmo", "Não há julgamentos, prazos ou obrigações", "100% de Anonimato — você só se identifica se quiser!".
- ✅ Estrutura do formulário em 5 etapas com circle indicator.
- ✅ Placar em tempo real ao final do formulário (Vulnerabilidade / Ameaça / Grau / Classificação).
- ✅ Banner institucional com logos (CNJ, CNMP, UniCatólica, Nostradamus Risk).
- ✅ VLibras já presente como widget flutuante.
- ✅ Bandeiras BR/ES/EN no topo (i18n preparado).
- ✅ Observatório com gráficos interativos e mapa Leaflet.

### 8.5 Estrutura institucional visível

- **Hospedagem:** TO Host Data Center
- **Apoiadores diretos:** TO Host, 63 Uniformes, UniCatólica do Tocantins
- **Parcerias:** OAB-TO (Comissão Feminicídio), SSP-TO/Polícia Civil, Lions Club, Secretaria da Mulher do Estado do Tocantins, Ouvidoria da Mulher do Estado do Tocantins, Secretaria da Mulher de Palmas, Casa da Mulher Brasileira, Casa da Mulher Tocantinense (Gurupi), Patrulha Maria da Penha PMTO, Polícia Militar TO, Delegacia Virtual SINESP.
- **Origem:** encontro entre policial civil e policial federal em Brasília em 2024 (registrado em `/sobre`).

---

## 9. Repositório de referência do Silvano Malfatti

**URL:** `https://github.com/malfattito/quiz_flutter`  
**Package:** `troca_contexto`  
**Data de criação:** 13/06/2026  
**Estado:** projeto didático/sandbox, esqueleto técnico para o tema da disciplina

### 9.1 Estrutura

```
quiz_flutter/
├── lib/
│   ├── main.dart                        # runApp(createMaterialApp())
│   ├── common/
│   │   ├── app_routes.dart              # rotas como String const
│   │   ├── route_manager.dart           # factory createMaterialApp()
│   │   └── storage_keys.dart            # chaves SharedPreferences
│   ├── Models/                          # PascalCase (não-convencional)
│   │   ├── answer.dart                  # title + score(int) + ==/hashCode
│   │   ├── question.dart                # title + answers + selectedAnswer
│   │   └── quiz_page.dart               # page/lastPage/questions
│   └── Screens/                         # PascalCase
│       ├── demo_page/
│       │   └── demo_page.dart           # ⭐ OptionCard reusable component
│       ├── login/login_page.dart
│       ├── photo/photo_page.dart
│       ├── profile/profile_page.dart
│       ├── quiz/
│       │   ├── quiz_page.dart           # ListView.builder com paginação
│       │   ├── quiz_server.dart         # Future.delayed(1s) + JSON bundle
│       │   └── question_widget.dart     # RadioListTile
│       ├── registration/register_page.dart
│       └── result/result_page.dart
├── assets/Mock/
│   ├── page1.json                       # 6 perguntas mock genéricas
│   ├── page2.json                       # idêntica à page1
│   └── page3.json                       # idêntica à page1
└── pubspec.yaml                         # apenas image_picker + shared_preferences
```

### 9.2 Convenções a manter

1. Cabeçalho `/* Nome / Descrição / Autor: Silvano Malfatti / Data */` em cada arquivo
2. Rotas como `static const String` em `AppRoutes`
3. `MaterialApp` em factory `createMaterialApp()` separado do `main.dart`
4. Models com `fromJson` / `toJson`; `Answer` implementa `==` e `hashCode` manualmente
5. Métodos privados `_build...` (widgets) e `_on...` (handlers)
6. Mocks JSON em `assets/Mock/page{N}.json` com schema `{page, lastPage, questions[]}`
7. Sem state management externo — só `setState`

### 9.3 Componente-chave: `OptionCard`

No arquivo `lib/Screens/demo_page/demo_page.dart`, o Silvano criou um cartão de pergunta capaz de operar em dois modos:

- **`OptionCardSelectionMode.single`** — radio buttons (seleção única)
- **`OptionCardSelectionMode.multiple`** — checkboxes (múltipla seleção)

Com `OptionCardController` mantendo:
- `_selectedValue: double` (modo single)
- `_selectedValues: List<double>` (modo multiple)
- Getter `totalValue` (soma das múltiplas)
- Método `isSelected(value, mode)` para renderização

**As duas perguntas exemplo do demo são literalmente as primeiras do FONAR** (pergunta 1 ameaça com 4 opções em single, pergunta 2 agressões físicas com 15 opções em multiple). Esse é o ponto-base do nosso trabalho.

### 9.4 Limitações do esqueleto

1. `Answer.score` é `int`, mas o cálculo AR PAX exige score por critério (`Map<Critério, double>`)
2. Sem `ThemeData` custom — está com Material default
3. Sem internacionalização
4. Sem `Semantics`, sem hook VLibras
5. Sem motor de cálculo isolado — score acumulado em `_totalScore: int`
6. Scroll infinito (`ScrollController.addListener`) — incompatível com stepper desejado
7. Divergência interna: `Answer.score` é `int`, mas `OptionCard.value` é `double`

---

## 10. Anotações da reunião de 18/06/2026

**Participantes:** Silvano Malfatti, Davi, equipe acadêmica

### 10.1 Resumo
- Sistema usa 30 perguntas (na verdade 27 com subitens) com pesos variados por critério.
- O cálculo é interrompido ao atingir o teto numérico de cada critério (lógica de saturação).
- Vulnerabilidade definida como situação em que a pessoa não consegue se manter/defender.
- Atratividade refere-se à propensão do agressor a buscar o mal para obter satisfação.
- Análise considera complexidade psíquica do comportamento humano.

### 10.2 Diretrizes de interface
- Aplicação web focada em anonimato.
- Proteção de dados sensíveis.
- Interface acolhedora e responsiva.
- Evitar vestígios no histórico do navegador.

### 10.3 Acessibilidade e impacto social
- Recursos de Libras e alto contraste.
- Qualidade do código fundamental para sustentar impacto social.

### 10.4 Próximas etapas combinadas
- **Grupo:** desenvolver interface responsiva e acessível com paleta acolhedora e medidor de risco em tempo real.
- **Grupo:** apresentar proposta de interface e arquitetura.
- **Davi:** avaliar apresentação e fornecer feedback técnico.
- **Davi:** enviar logotipo e elementos gráficos em alta resolução (PENDENTE).
- **Equipe:** elaborar novas propostas de design e submeter para validação dos órgãos competentes.

---

## 11. Inventário de assets disponíveis

> Estão em `/mnt/project/` (no Drive original do projeto).

### 11.1 Documentos

- `DOCUMENTAÇÃO_PADRÃO_DE_DIAGNOSTICO.docx` — diagnóstico técnico do sistema atual
- `DOCUMENTAÇÃO_PADRÃO_DE_REQUISITOS.docx` — requisitos funcionais e não-funcionais, glossário completo
- `Analise_de_Risco_Pax__Metodologia.pdf` — apresentação institucional da metodologia (slide deck)
- `Artigo__Analise_de_Risco_Pax_e_as_Medidas_Protetivas_de_Urgencia.pdf` — artigo acadêmico de Scarpelli et al. (2024) na Revista Brasileira de Ciências Policiais, v. 15, n. 1
- `DESPERTEMULHER.pdf` — material de apresentação da plataforma
- `Planilha_Ajustada.xlsm` — **fonte autoritativa do cálculo**, com 6 abas:
  - `QUESTIONÁRIO` — texto integral das 27 perguntas
  - `CRITÉRIOS` — descrição dos 6 critérios e quesitos que alimentam cada um
  - `Quest X Critérios FINAL` — matriz pergunta × critério
  - `Quest X Crit X Pesos` — pesos de precedência
  - `Para testes` — cenários de validação
  - `NÍVEL CRITÉRIO` — tabelas de classificação e faixas (fonte autoritativa final)
- `Planilha_Ajustada.pdf` — versão impressa da planilha
- `Mini_bios.docx` — mini biografias dos envolvidos
- `Davi_-_Explanação_em_aula` — transcrição da reunião de 18/06/2026
- `Links.txt` (vazio)

### 11.2 Logos institucionais (todos PNG/JPEG)

- `63_LOGOPNG.png` — 63 Uniformes
- `acolhetofundobranco.jpeg` — Acolhe (Secretaria da Mulher TO)
- `bandeirapalmas.png` — Bandeira de Palmas
- `brasaopctotransparente.png` — Brasão Polícia Civil TO
- `brasil.jpeg` — Bandeira do Brasil
- `casadamulhertogurupi.jpeg` — Casa da Mulher Tocantinense (Gurupi)
- `casamulherbrasileira.jpeg` / `casamulherbrasileira.png` / `logocasamulherbrasileira.png` — Casa da Mulher Brasileira
- `circulosseguranca.png` — Círculos de Segurança
- `cnj.png` / `cnjbranco.png` — Conselho Nacional de Justiça
- `cnmp.png` — Conselho Nacional do Ministério Público
- `comissaofeminicidio.jpeg` — Comissão de Feminicídio
- `delegaciavirtual.png` — Delegacia Virtual SINESP
- `escalagrauderisco.png` — Escala visual de graus de risco
- `espanha.png` / `eua.png` — Bandeiras ES/EN para i18n
- `gcmp.png` — GCM Palmas
- `govto.png` / `togov.png` / `tohosts.png` / `tohosttrans.png` — Governo do Tocantins e TO Host
- `icone.png` — Ícone genérico
- `lionsclub.png` / `logolionsalberto.png` — Lions Club
- `logocatolica.png` — UniCatólica do Tocantins
- `matrizrisco.png` — Imagem da matriz 5×5
- `notascustoreposicao.png` — Notas de custo
- `nudem.jpg` — NUDEM (Núcleo de Defesa da Mulher)
- `oabto.jpeg` — OAB Tocantins
- `ouvidoriamulhertotrans.png` / `ouvidoriato.jpeg` — Ouvidoria da Mulher TO
- `patrulhamariadapenha.png` / `Patrulha_da_Mulher_Segura.png` — Patrulha Maria da Penha
- `pmto.png` — Polícia Militar TO
- `protjetotodasfortes.jpeg` / `todasfortes.png` — Projeto Todas Fortes
- `redeintegrada.jpeg` — Rede Integrada de Proteção
- `secmulherpalmas.png` — Secretaria da Mulher de Palmas
- `secretariadamulhertocantins.png` — Secretaria da Mulher TO
- `senappen.png` — SENAPPEN
- `tabelareferenciaares.png` — Tabela de referência da AR PAX
- `180.jpeg` — Campanha Ligue 180
- `ameacaativoacao.png` — Ameaça/Ativo/Ação (esquema da metodologia)

### 11.3 Assets pendentes (PRECISAM SER ENVIADOS pelo Davi)

- **Logo "Desperte Mulher" em alta resolução** (SVG ou PNG ≥2x)
- Manual de identidade visual (se existir)
- Mascote Nostradamus (ilustração amarela com escudo e gráfico — usada no banner do formulário atual)

---

## 12. Stack do site legado e plano de migração da equipe Django

### 12.1 Site atual

- **Backend:** PHP/Laravel monolítico (controllers gordos: `ARPAXController.php`, `AtendimentosController.php`, `ChatRedeController.php`)
- **Frontend:** Blade templates
- **Banco:** MySQL com modelagem fragmentada (tabela por categoria de resposta: `frida_resposta_ameaca`, `frida_resposta_ciumes`, etc.)
- **Débito técnico identificado:** Fat Controllers, `exec('ffmpeg')` dentro de controllers, ausência de Service Layer/motor de regras centralizado

### 12.2 Plano oficial de migração (paralelo ao nosso MVP)

- **Backend novo:** Django + DRF + Celery + Redis, com Clean Architecture e Service Layers separando a lógica AR PAX em camada própria
- **Frontend novo:** Next.js (planejado pela equipe Django) — **mas o nosso Flutter pode substituir esta camada se for aprovado**
- **Arquitetura:** API-first, contratos REST bem definidos

### 12.3 Como nosso MVP se conecta

- Implementamos o motor AR PAX **isolado** em `domain/usecases/calcular_risco_arpax.dart`, com mesma assinatura conceitual do `Service Layer` planejado pelo Django
- A fonte das perguntas e do mapeamento pergunta×critério fica em **JSON externo** (`assets/Mock/perguntas_arpax.json`)
- Quando o backend Django ficar pronto, basta:
  1. Apontar o `QuizServer` para a URL real
  2. Validar que o JSON de resposta segue o mesmo schema
  3. Manter o motor de cálculo local (redundância de segurança) ou desligá-lo se o backend devolver o resultado pronto

---

## 13. Pendências e issues abertos

### 13.1 Bloqueadores externos (não dependem da equipe técnica)

- 🔴 **Logo em alta resolução** — bloqueia o branding final. Workaround: usar um logo placeholder bonito até o Davi enviar.
- 🟡 **Confirmação do Felipe Scarpelli sobre 2 divergências no mapeamento**:
  - As perguntas 16.b e 16.c estão marcadas como "RETIRAR" na planilha mas aparecem em produção no site.
  - Algumas perguntas têm mapeamento ligeiramente diferente entre a aba `CRITÉRIOS` (descrição textual) e a aba `Quest X Critérios FINAL` (matriz binária). Tratamento: seguir a tabela da seção 6 (validada contra os totais máximos por critério).

### 13.2 Pendências internas

- 🟢 Escolha final da paleta de cores (3 opções já preparadas — Lavanda Acolhedora / Aurora Suave / Terracota Recolhimento)
- 🟢 Revisão do `domain/` por Silvano Malfatti
- 🟢 Renomear package de `troca_contexto` para `desperte_mulher` antes de qualquer commit oficial
- 🟢 Executar `flutter test test/calculadora_arpax_test.dart` no fork
- 🟢 Implementar botão "saída rápida" (foi confirmado entrada no MVP)

### 13.3 Itens futuros (pós-MVP)

- VLibras integrado via plugin JS (arquitetura deve preparar para isso, mas não implementar agora)
- Internacionalização real para PT/ES/EN
- Integração com backend Django quando estiver pronto
- Página de Observatório com gráficos e mapa (espelhando funcionalidade atual)
- Sistema "Acolhe" (área restrita para profissionais, via /login do site atual)

---

## Apêndice A — Glossário rápido

- **AR PAX** — Análise de Risco PAX, metodologia científica de Scarpelli
- **FONAR** — Formulário Nacional de Avaliação de Risco (CNJ/CNMP Res. 5/2020)
- **MPU** — Medida Protetiva de Urgência (Lei Maria da Penha)
- **VC1/VC2/VC3** — Critérios da Vulnerabilidade (Atratibilidade, Exposição, Casuística)
- **AC1/AC2/AC3** — Critérios da Ameaça (Motivação, Histórico, Tendência)
- **MB/BA/MO/AL/EX** — Graus finais (Muito Baixo, Baixo, Moderado, Alto, Extremo)
- **Likert** — Escala de quantificação subjetiva em 5 níveis
- **Matriz de Risco** — Tabela 5×5 que cruza Vulnerabilidade × Ameaça → Grau final
- **TJ-TO** — Tribunal de Justiça do Tocantins
- **CNJ** — Conselho Nacional de Justiça
- **CNMP** — Conselho Nacional do Ministério Público
- **Casa da Mulher Brasileira** — Equipamento federal de atendimento integral à mulher

---

## Apêndice B — Citações e referências

- ANDRADE, F. S. *Análise de Risco e Medidas Protetivas de Urgência*. 2017.
- ANDRADE, F. S. *Metodologia de Análise de Risco em Segurança Institucional*. 2019.
- CLEMEN, R. T.; WINKLER, R. L. (1999). Combining probability distributions from experts in risk analysis. *Risk Analysis*, 19(2), 187-203.
- SCARPELLI DE ANDRADE, F.; SILVA, P. A. M.; PONA, F. B. (2024). Análise de Risco Pax e as Medidas Protetivas de Urgência: a conformação metodológica. *Revista Brasileira de Ciências Policiais*, Brasília, v. 15, n. 1, p. 17-51, jan-abr.
- CNJ; CNMP. *Resolução Conjunta nº 5/2020* — institui o FONAR.
- BRASIL. *Lei nº 11.340/2006* — Lei Maria da Penha.

---

**Fim do arquivo de compilação.**
