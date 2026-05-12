extends Node

func _ready() -> void:
	$Timer.start()
	Global.JogoConcluido = true
	await get_tree().create_timer(1.0).timeout
	Audios.tocar_instrucao("res://assets/audios/tela_final.ogg")
	if OS.has_feature("web"):
		Menu._postData()


func _on_timer_timeout() -> void:
	Audios.tocar_instrucao("res://assets/audios/tela_final.ogg")
