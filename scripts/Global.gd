extends Node

# Banco local usado no export HTML. Antes esses dados vinham da API Docker.
var array_silabas: Array
var array_imagens: Array

const CAMINHO_DADOS_ESTATICOS = "res://assets/recursos_estaticos/dados.json"

# Dados para plataforma
var Score : int = 0
var erros : int = 0
var TempoDeJogo_Min : int = 0
var TempoDeJogo_Sec : int = 0
var JogoConcluido : bool = false

#variveis para o jogo
var arrastando: bool = false

#Permite que a intro toque só uma vez
var Intro_tocar : bool = true
var personagem_escolhido: String = "masc"


func _ready() -> void:
	carregar_banco_estatico()


func carregar_banco_estatico() -> void:
	if not array_silabas.is_empty():
		return

	var arquivo = FileAccess.open(CAMINHO_DADOS_ESTATICOS, FileAccess.READ)
	if arquivo == null:
		push_error("Nao foi possivel abrir o banco estatico: " + CAMINHO_DADOS_ESTATICOS)
		return

	var dados = JSON.parse_string(arquivo.get_as_text())
	if typeof(dados) != TYPE_ARRAY:
		push_error("Banco estatico invalido: " + CAMINHO_DADOS_ESTATICOS)
		return

	for item in dados:
		var imagens: Array = []
		for imagem in item.get("imagens", []):
			var caminho_imagem = imagem.get("imagem", "")
			if caminho_imagem != "":
				var textura = carregar_textura_png(caminho_imagem)
				if textura != null:
					imagens.append(textura)

		var caminho_som = item.get("som", "")
		var som = null
		if caminho_som != "":
			som = carregar_audio_ogg(caminho_som)

		array_silabas.append({
			"palavra": item.get("palavra", ""),
			"silaba": item.get("silaba", ""),
			"complemento_silaba": item.get("complemento_silaba", ""),
			"imagens": imagens,
			"som": som
		})


func carregar_textura_png(caminho: String):
	if ResourceLoader.exists(caminho):
		var textura = load(caminho)
		if textura is Texture2D:
			return textura
	push_error("Nao foi possivel carregar imagem estatica: " + caminho)
	return null


func carregar_audio_ogg(caminho: String):
	if ResourceLoader.exists(caminho):
		var audio = load(caminho)
		if audio is AudioStream:
			return audio
	push_error("Nao foi possivel encontrar audio estatico: " + caminho)
	return null


func embaralhar():
	carregar_banco_estatico()
	array_silabas.shuffle()
	array_imagens = array_silabas[0].imagens
	array_imagens.shuffle()

func embaralhar_imagens(pos_array):
	carregar_banco_estatico()
	array_imagens = array_silabas[pos_array].imagens
	array_imagens.shuffle()
