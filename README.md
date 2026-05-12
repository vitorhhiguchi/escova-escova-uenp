# 🦷 Escova-Escova! (Ligue as Sílabas)

Um jogo digital lúdico e interativo desenvolvido na **Godot Engine 4**, focado no apoio à **alfabetização infantil**, **consciência fonológica** e **letramento**, integrando o aprendizado de sílabas com a conscientização sobre a **higiene bucal**.

---

## 🎯 Intuito Educacional

O **Escova-Escova** transforma o ato de escovar os dentes em uma mecânica divertida de aprendizado:
- **Consciência Fonológica**: O jogo apresenta uma palavra incompleta (ex: `_ _ NANA`) e a sílaba-alvo no topo da tela. A criança precisa identificar a sílaba correta entre várias opções (distratores) presentes nos dentes.
- **Desenvolvimento Motor**: Para selecionar a resposta, o jogador controla uma escova de dentes virtual com o mouse e deve fazer o **movimento real de escovação (vai e vem)** sobre o dente correto.
- **Feedback Imediato e Consequência Lógica**:
  - ✅ **Acerto**: O dente fica completamente limpo e brilhante, a palavra se completa na cor verde e áudios comemorativos reforçam o aprendizado.
  - ❌ **Erro**: O dente escovado incorretamente acumula mais sujeira (ficando mais escuro), acompanhado de um alerta visual vermelho e som característico, incentivando a criança a tentar novamente sem frustração excessiva.

---

## ✨ Funcionalidades e Telas

### 1. Tela Inicial
- Interface atrativa com animações e suporte de áudio descritivo ao passar o mouse sobre os botões.
- Acesso rápido para iniciar a partida (**JOGAR**) ou aprender as regras (**COMO JOGAR**).

### 2. Tutorial Narrado (Como Jogar)
- Uma experiência guiada e coreografada automaticamente via script.
- Uma escova demonstrativa se move sozinha pela tela, mostrando o que acontece ao escovar o dente errado e, em seguida, como escovar o dente correto para vencer, acompanhada de narração em áudio passo a passo.

### 3. Escolha de Personagem
- Opção de selecionar entre **Menino** e **Menina**, o que altera dinamicamente o fundo da boca e a textura da escova de dentes durante a partida, promovendo representatividade.

### 4. Partida (Gameplay)
- Sistema dinâmico de fases (1 a 5) carregando palavras e imagens configuradas globalmente.
- Acompanhamento de pontuação (estrelas) e tempo de jogo.
- **Integração Pedagógica**: Ao final da partida, métricas valiosas como pontuação total, tempo gasto e quantidade de erros são enviadas automaticamente para a plataforma ou painel do professor via API.

---

## 🛠️ Tecnologias Utilizadas

- **Engine**: [Godot Engine 4.x](https://godotengine.org/) (Renderizador GL Compatibility).
- **Linguagem**: GDScript.
- **Áudio**: Efeitos sonoros e narrações completas em formato `.ogg` e `.mp3` gerenciados por um Autoload de Áudios global.

---

## 🚀 Como Rodar o Projeto Localmente

### Pré-requisitos
- Ter a **Godot Engine 4** instalada na máquina.

### Passos
1. Clone ou baixe este repositório para o seu computador.
2. Abra a Godot Engine e clique em **Import** (Importar).
3. Navegue até a pasta do projeto e selecione o arquivo `project.godot`.
4. Com o projeto aberto no editor, pressione **F5** (ou clique no botão de Play no canto superior direito) para rodar a cena principal (`inicio.tscn`).

---

## 📦 Exportação (Web / HTML5)

O projeto está otimizado para rodar diretamente nos navegadores de computadores e tablets nas escolas:
1. No menu superior da Godot, vá em `Project > Export...`.
2. Adicione o preset **Web**.
3. Clique em **Export Project** para gerar os arquivos HTML/WASM estáticos prontos para serem hospedados em qualquer servidor web ou portal educacional.