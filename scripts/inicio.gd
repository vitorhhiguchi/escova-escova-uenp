extends Node

var mouse_dentro = false

func _ready() -> void:
	Menu.telaInicial = true
	
	if Global.Intro_tocar == true:
		Global.Intro_tocar = false
		await get_tree().create_timer(3.3).timeout
	$Intro.visible = false
	
	Audios.tocar_instrucao("res://assets/audios/tela_inicial.ogg")


func _on_jogar_pressed() -> void:
	reset_dados()
	get_tree().change_scene_to_file("res://scenes/escolha_personagem.tscn")


func reset_dados():
	Global.Score = 0
	Global.erros = 0
	Global.TempoDeJogo_Min = 0
	Global.TempoDeJogo_Sec = 0
	Global.JogoConcluido = false


func _on_jogar_mouse_entered() -> void:
	mouse_dentro = true
	$Timer.start()


func _on_jogar_mouse_exited() -> void:
	mouse_dentro = false
	$Timer.stop()


func _on_timer_timeout() -> void:
	Audios.tocar_audio("res://assets/audios/jogar.ogg", self)
	$Timer.stop()


func _on_timer_instrucao_timeout() -> void:
	Audios.tocar_instrucao("res://assets/audios/tela_inicial.ogg")


func _on_como_jogar_pressed() -> void:
	reset_dados()
	get_tree().change_scene_to_file("res://scenes/como_jogar.tscn")


func _on_como_jogar_mouse_entered() -> void:
	mouse_dentro = true
	$TimerComoJogar.start()


func _on_como_jogar_mouse_exited() -> void:
	mouse_dentro = false
	$TimerComoJogar.stop()


func _on_timer_como_jogar_timeout() -> void:
	Audios.tocar_audio("res://assets/audios/como_jogar.ogg", self)
	$TimerComoJogar.stop()


func is_mouse_inside() -> bool:
	return mouse_dentro
