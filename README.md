# 🍄 Super Mario: Ascension (Assembly MIPS)


## 🦇 Sobre o Projeto

Este projeto é uma releitura do clássico *Super Mario*, mas com uma atmosfera de terror e suspense. Desenvolvido inteiramente em **Assembly MIPS**, o jogo foge do visual colorido e alegre da franquia original, entregando uma experiência sombria e uma narrativa focada na sobrevivência e libertação.

O foco mecânico do jogo concentra-se no primeiro reino, enquanto as fases seguintes servem como uma progressão narrativa e catártica, exigindo diferentes abordagens de lógica de transição de telas e encerramento de execução no código de baixo nível.

## 🌌 Cenários e Progressão

A jornada do Mario é estruturada em 3 planos de existência, passando do puro horror ao descanso final:

* 🔥 **Fase 1: Inferno** - O núcleo dos desafios. Um ambiente hostil, escuro e opressivo onde a verdadeira gameplay de sobrevivência acontece. É aqui que o jogador precisa testar seus reflexos para escapar.
* 🌍 **Fase 2: Terra** - O limbo silencioso. Um cenário desprovido de inimigos ou perigos físicos. A tensão dar lugar à solidão de um mundo abandonado. O único objetivo do jogador é caminhar por esse vazio até alcançar uma porta misteriosa, guardada por um diácono, que o transportará automaticamente para a próxima dimensão.
* ☁️ **Fase 3: Céu** - O descanso final. Não há desafios mecânicos, buracos ou armadilhas. A chegada do personagem a este cenário pacífico simboliza o fim de seu pesadelo e marca o encerramento do jogo.

## 💻 Tecnologias e Ferramentas

* **Linguagem:** Assembly MIPS
* **Ambiente de Desenvolvimento/Simulador:** [MARS (MIPS Assembler and Runtime Simulator)](https://courses.missouristate.edu/KenVollmar/mars/)
* **Gráficos:** Bitmap Display (Ferramenta nativa do MARS)
* **Controles:** Keyboard and Display MMIO Simulator (Ferramenta nativa do MARS)

## 🚀 Como Executar o Jogo

Para rodar o jogo na sua máquina, siga os passos abaixo:

1.  Certifique-se de ter o **Java** instalado (necessário para rodar o MARS).
2.  Baixe e abra o simulador **MARS**.
3.  No MARS, vá em `File > Open` e selecione o arquivo principal do jogo (ex: `main.asm`).
4.  Configure as ferramentas de exibição:
    * Vá em `Tools > Bitmap Display`.
    * *Configurações recomendadas do Bitmap (Ajuste conforme o projeto):*
        * Unit Width in Pixels: `4`
        * Unit Height in Pixels: `4`
        * Display Width in Pixels: `512`
        * Display Height in Pixels: `256`
        * Base Address for Display: `0x10010000`
    * Clique em **Connect to MIPS**.
5.  Configure os controles:
    * Vá em `Tools > Keyboard and Display MMIO Simulator`.
    * Clique em **Connect to MIPS**.
6.  Compile o código pressionando `F3` (Assemble).
7.  Inicie o jogo pressionando `F5` (Run) e use a janela do MMIO Simulator para capturar os comandos do teclado.

## 🎮 Controles

| Tecla | Ação |
| :--- | :--- |
| `A` | Andar para a Esquerda |
| `D` | Andar para a Direita |


## 🎓 Contexto Acadêmico

Este projeto foi desenvolvido como requisito avaliativo para a disciplina de **Arquitetura de Computadores**.

* **Instituição:** IFRN (Instituto Federal do Rio Grande do Norte)
* **Curso:** Tecnologia em Análise e Desenvolvimento de Sistemas (TADS)
* **Orientador:** Prof. Dr. Eduardo Bráulio

## 👥 Desenvolvedores

* **Wedson Gabriel Rocha dos Santos** 
* **Maxwell Dantas de Lima**
