extends Node2D

var array_posicoes_botoes_silabas = [Vector2(190,170), Vector2(190,340)]
var array_posicoes_botoes_imagens = [Vector2(700,165), Vector2(700,340)]

var cena_botao_silaba = preload("res://scenes/botao_silaba.tscn")
var cena_botao_imagem = preload("res://scenes/botao_imagem.tscn")

var array_botoes_silabas:Array
var array_botoes_imagens:Array

var id_botao_silaba: int
var mouse_dentro = false

signal ir_para_main

func _ready() -> void:
	Menu.telaInicial = false
	
	Global.embaralhar()
	
	for i in array_posicoes_botoes_silabas.size():
		var botao_silaba = cena_botao_silaba.instantiate()
		botao_silaba.position = array_posicoes_botoes_silabas[i]
		botao_silaba.id = i
		botao_silaba.get_node("silaba").text = Global.array_silabas[i].silaba
		botao_silaba.caminho_som = Global.array_silabas[i].som
		botao_silaba.connect("enviar_id", Callable(self, "_on_botao_silaba_enviar_id"))
		botao_silaba.desabilitar_botao_como_jogar()
		array_botoes_silabas.append(botao_silaba)
		add_child(botao_silaba)
	
	for i in array_posicoes_botoes_imagens.size():
		var botao_imagem = cena_botao_imagem.instantiate()
		botao_imagem.position = array_posicoes_botoes_imagens[i]
		botao_imagem.id = i
		Global.embaralhar_imagens(i)
		botao_imagem.get_node("imagem").texture = Global.array_imagens[i]
		botao_imagem.connect("soltou_area", Callable(self, "_on_botao_imagem_soltou_area"))
		array_botoes_imagens.append(botao_imagem)
		add_child(botao_imagem)
	
	como_jogar()


func como_jogar():
	#dados para as animacoes
	var tomada1 = array_botoes_silabas[0].get_node("botao_tomada").global_position
	var tomada2 = array_botoes_silabas[1].get_node("botao_tomada").global_position
	var marker_certo  = array_botoes_imagens[0].get_node("Marker").global_position
	var marker_errado = array_botoes_imagens[1].get_node("Marker").global_position
	
	#Vamos aprender a jogar
	Audios.tocar_instrucao("res://assets/audios/como_jogar/vamos_aprender_a_jogar.ogg")
	await get_tree().create_timer(2.5).timeout
	Audios.tocar_instrucao("res://assets/audios/tela_do_jogo.ogg")
	await get_tree().create_timer(4.0).timeout
	#errou
	$AnimationPlayer.play("cursor_para_tomada1")
	await get_tree().create_timer(1.0).timeout
	id_botao_silaba = 0
	await animar_tutorial(array_botoes_silabas[0], tomada1, marker_errado)
	await get_tree().create_timer(2.0).timeout
	Audios.tocar_instrucao("res://assets/audios/como_jogar/tente_outra_vez.ogg")
	await get_tree().create_timer(5.0).timeout
	#remove a tomada 
	Audios.tocar_instrucao("res://assets/audios/como_jogar/tire_a_tomada.ogg")
	await get_tree().create_timer(2.0).timeout
	await animar_tutorial(array_botoes_silabas[0], Vector2.ZERO, tomada1, true)
	#acertou
	Audios.tocar_instrucao("res://assets/audios/tela_do_jogo.ogg")
	await get_tree().create_timer(4.0).timeout
	await animar_tutorial(array_botoes_silabas[0], tomada1, marker_certo)
	var tomada1_node = array_botoes_silabas[0].get_node("botao_tomada")
	tomada1_node.global_position = (marker_certo - tomada1_node.size * 0.35) + Vector2(0, 14)
	await get_tree().create_timer(1.5).timeout
	Audios.tocar_instrucao("res://assets/audios/como_jogar/voce_acertou.ogg")
	await get_tree().create_timer(4.0).timeout
	#acertou de novo
	Audios.tocar_instrucao("res://assets/audios/como_jogar/agora_a_outra_tomada.ogg")
	await get_tree().create_timer(2.7).timeout
	$AnimationPlayer.play("imagem1_para_tomada2")
	await get_tree().create_timer(1.0).timeout
	id_botao_silaba = 1
	await animar_tutorial(array_botoes_silabas[1], tomada2, marker_errado)
	await get_tree().create_timer(2.0).timeout
	$robo.hide()
	$robo_pulando.show()
	$robo_pulando.play("pulando_feliz")
	Audios.tocar_instrucao("res://assets/audios/como_jogar/voce_acertou.ogg")
	await get_tree().create_timer(4.0).timeout
	Audios.tocar_instrucao("res://assets/audios/como_jogar/sua_vez.ogg")
	await get_tree().create_timer(4.0).timeout
	ir_para_main.emit()


func _on_botao_imagem_soltou_area(id) -> void:
	array_botoes_silabas[id_botao_silaba].z_index = 0
	if id == id_botao_silaba:
		acertou(id)
	else:
		errou(id)


func acertou(id):
	var botao_tomada = array_botoes_silabas[id_botao_silaba].get_node("botao_tomada")
	var marker_pos = array_botoes_imagens[id].get_node("Marker").global_position
	botao_tomada.global_position = (marker_pos - botao_tomada.size * 0.35) + Vector2(0,14)
	array_botoes_imagens[id]._acertou()
	array_botoes_silabas[id_botao_silaba].desabilitar_botao()


func errou(id):
	array_botoes_silabas[id_botao_silaba].tocar_audio()
	Global.Score -= 2
	Global.erros += 1
	var botao_tomada = array_botoes_silabas[id_botao_silaba].get_node("botao_tomada")
	var marker_pos = array_botoes_imagens[id].get_node("Marker").global_position
	botao_tomada.global_position = (marker_pos - botao_tomada.size * 0.35) + Vector2(0,14)
	array_botoes_imagens[id]._errou()
	await get_tree().create_timer(1.0).timeout
	# choque
	treme_robo(0.5, 15.0)
	$choque.restart()
	$choque.emitting = true 
	Audios.som_eletricidade("res://assets/audios/choque.ogg")
	#pisca o robo
	var tween_pisca = create_tween()
	for i in 4:
		tween_pisca.tween_property($robo, "modulate", Color(1, 1, 0, 1), 0.05)
		tween_pisca.tween_property($robo, "modulate", Color(1, 1, 1, 1), 0.05)
	await tween_pisca.finished
	$choque.emitting = false


func treme_robo(duracao: float, intensidade: float = 5.0):
	var origem = $robo.position
	var tween = create_tween()
	var passos = int(duracao / 0.05)

	for i in passos:
		var offset = Vector2(
			randf_range(-intensidade, intensidade),
			randf_range(-intensidade, intensidade)
		)
		tween.tween_property($robo, "position", origem + offset, 0.05)

	# Volta à posição original no final
	tween.tween_property($robo, "position", origem, 0.05)


func _on_pular_tutorial_pressed() -> void:
	ir_para_main.emit()


func _on_pular_tutorial_mouse_entered() -> void:
	mouse_dentro = true
	$TimerBotao.start()


func _on_pular_tutorial_mouse_exited() -> void:
	mouse_dentro = false
	$TimerBotao.stop()


func _on_timer_botao_timeout() -> void:
	Audios.tocar_audio("res://assets/audios/como_jogar/pular_tutorial.ogg", self)
	$TimerBotao.stop()


func is_mouse_inside() -> bool:
	return mouse_dentro


func animar_tutorial(botao_silaba_ref: Node, pos_inicio: Vector2, pos_fim: Vector2, voltando: bool = false) -> void:
	var tomada = botao_silaba_ref.get_node("botao_tomada")
	const DURACAO_ANIM = 1.5
	const OFFSET_CURSOR = Vector2(34, 28)
	var pos_inicio_real: Vector2
	var pos_fim_real: Vector2
	
	if voltando:
		pos_inicio_real = tomada.global_position
		pos_fim_real = pos_fim 
	else:
		pos_inicio_real = pos_inicio
		pos_fim_real = (pos_fim - tomada.size * 0.35) + Vector2(0, 14)
	
	$cursor.global_position = pos_inicio_real + OFFSET_CURSOR
	tomada.global_position = pos_inicio_real
	
	await get_tree().create_timer(0.3).timeout
	
	var tween = create_tween()
	tween.set_parallel(true)
	
	$mouse.texture = load("res://assets/tutorial/Mouse_pintado.png")
	
	tween.tween_property($cursor, "global_position", pos_fim_real + OFFSET_CURSOR, DURACAO_ANIM)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(tomada, "global_position", pos_fim_real, DURACAO_ANIM)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	await tween.finished
	$mouse.texture = load("res://assets/tutorial/Mouse.png")
