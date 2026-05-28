extends Control

@onready var bg_rect = $Background
@onready var score_label = $VBox/ScoreLabel

var mouse_dentro = false

func _ready() -> void:
	Menu.telaInicial = false
	Global.JogoConcluido = true
	
	if Global.personagem_escolhido == "fem":
		bg_rect.texture = load("res://assets/escova/fem-fim-sorrindo.png")
	else:
		bg_rect.texture = load("res://assets/escova/masc-fim-sorrindo.png")
		
	score_label.text = "Pontuação Final:  %d\nErros: %d" % [Global.Score, Global.erros]
	
	Audios.tocar_instrucao("res://assets/audios/tela_final.ogg")
	
	if OS.has_feature("web"):
		Menu._postData()

func _on_play_again_pressed() -> void:
	if Global.personagem_escolhido == "fem":
		get_tree().change_scene_to_file("res://scenes/game_escova_fem.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/game_escova_masc.tscn")

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/inicio.tscn")

func _on_btn_mouse_entered() -> void:
	mouse_dentro = true
	$TimerBotao.start()

func _on_btn_mouse_exited() -> void:
	mouse_dentro = false
	$TimerBotao.stop()

func _on_timer_botao_timeout() -> void:
	Audios.tocar_audio("res://assets/audios/voltar.ogg", self)
	$TimerBotao.stop()

func _on_timer_instrucao_timeout() -> void:
	Audios.tocar_instrucao("res://assets/audios/tela_final.ogg")

func is_mouse_inside() -> bool:
	return mouse_dentro

