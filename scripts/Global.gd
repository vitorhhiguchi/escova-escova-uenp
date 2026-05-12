extends Node

#Node HTTPRequest
var JsonRequest = HTTPRequest.new()
var ImagemRequest = HTTPRequest.new()
var AudioRequest = HTTPRequest.new()

# Recebe as requisicoes
var array_dicionario: Array
var array_dicionario_imagens: Array
var texturas : Array
var audio

#posicao no array de requisicoes
var index = 0
var cont_img = 0

#array com dados apos as requisicoes
var array_silabas: Array
var array_imagens: Array


# cria dicionario
var dicionario : Dictionary = {
	"palavra" : "",
	"silaba" :  "",
	"complemento_silaba" : "",
	"imagens" : null,
	"som" : null
}

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
	add_child(JsonRequest)
	add_child(ImagemRequest)
	add_child(AudioRequest)
	# Conecta o sinal de conclusão da requisição
	JsonRequest.request_completed.connect(_on_json_request_completed)
	ImagemRequest.request_completed.connect(_on_imagem_request_completed)
	AudioRequest.request_completed.connect(_on_audio_request_completed)
	
	var url = "http://localhost:8080/api/recursos/silabas?vogal=A&limite=18&tipoColorir=NAO_COLORIR&quantImagens=4"
	var headers = [
		"Content-Type: application/json",
	]
	JsonRequest.request(url,
		headers,
		HTTPClient.METHOD_GET)


func _on_json_request_completed(_result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var json_string = body.get_string_from_utf8()
	
	var json = JSON.parse_string(json_string)
	
	array_dicionario = json
	
	request_imagem()


func request_imagem():
	if index == array_dicionario.size():
		return
	#request imagem
	array_dicionario_imagens = array_dicionario[index].imagens
	if cont_img < array_dicionario_imagens.size():
		ImagemRequest.request(array_dicionario_imagens[cont_img].imagem)
		cont_img += 1 


func _on_imagem_request_completed(_result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var image = Image.new()
	image.load_png_from_buffer(body)
	var texture = ImageTexture.create_from_image(image)
	texturas.append(texture)
	
	if cont_img < array_dicionario_imagens.size():
		request_imagem()
	else:
		AudioRequest.request(array_dicionario[index].som)

func _on_audio_request_completed(_result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	audio = AudioStreamOggVorbis.load_from_buffer(body)
	cria_dicionario()


func cria_dicionario() -> void:
	dicionario = {
		"palavra" : array_dicionario[index].palavra,
		"silaba" :  array_dicionario[index].silaba,
		"complemento_silaba" : array_dicionario[index].complemento_silaba,
		"imagens" : texturas.duplicate(),
		"som" : audio
	}
	array_silabas.append(dicionario)
	
	index += 1
	
	print(index)
	
	cont_img = 0
	texturas.clear()
	request_imagem()


func embaralhar():
	array_silabas.shuffle()
	array_imagens = array_silabas[0].imagens
	array_imagens.shuffle()

func embaralhar_imagens(pos_array):
	array_imagens = array_silabas[pos_array].imagens
	array_imagens.shuffle()
