extends Control

var mouse_dentro = false
var audio_atual = ""

func _ready() -> void:
	Menu.telaInicial = false
	Audios.tocar_instrucao("res://assets/audios/escolher-personagem.mp3")

func _on_btn_menino_pressed() -> void:
	Global.personagem_escolhido = "masc"
	get_tree().change_scene_to_file("res://scenes/game_escova_masc.tscn")

func _on_btn_menina_pressed() -> void:
	Global.personagem_escolhido = "fem"
	get_tree().change_scene_to_file("res://scenes/game_escova_fem.tscn")

func _on_btn_menino_mouse_entered() -> void:
	mouse_dentro = true
	audio_atual = "res://assets/audios/menino.mp3"
	$TimerBotao.start()

func _on_btn_menina_mouse_entered() -> void:
	mouse_dentro = true
	audio_atual = "res://assets/audios/menina.mp3"
	$TimerBotao.start()

func _on_btn_mouse_exited() -> void:
	mouse_dentro = false
	$TimerBotao.stop()

func _on_timer_botao_timeout() -> void:
	Audios.tocar_audio(audio_atual, self)
	$TimerBotao.stop()

func is_mouse_inside() -> bool:
	return mouse_dentro
