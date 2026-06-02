extends Node2D

@onready var word_label = $UI/TopBar/WordLabel
@onready var feedback_label = $UI/FeedbackLabel
@onready var mouth_bg = $MouthBackground
@onready var teeth_container = $TeethContainer
@onready var pos_errado = $PosErrado
@onready var pos_certo = $PosCerto
@onready var escova_demo = $EscovaDemo

var tooth_scene = preload("res://scenes/tooth_escova.tscn")
var dente_certo: Area2D
var dente_errado: Area2D
var mouse_dentro = false
var tutorial_encerrado = false

func _ready() -> void:
	Menu.telaInicial = false
	
	# Instancia os dois dentes demonstrativos
	dente_errado = tooth_scene.instantiate()
	teeth_container.add_child(dente_errado)
	dente_errado.position = pos_errado.position
	dente_errado.rotation = pos_errado.rotation
	dente_errado.base_rotation = pos_errado.rotation
	dente_errado.set_syllable("CA", false)
	# Removemos colisões para o tutorial ser 100% coreografado via script sem interferência do mouse real
	if dente_errado.has_node("CollisionShape2D"):
		dente_errado.get_node("CollisionShape2D").queue_free()
		
	dente_certo = tooth_scene.instantiate()
	teeth_container.add_child(dente_certo)
	dente_certo.position = pos_certo.position
	dente_certo.rotation = pos_certo.rotation
	dente_certo.base_rotation = pos_certo.rotation
	dente_certo.set_syllable("BA", true)
	if dente_certo.has_node("CollisionShape2D"):
		dente_certo.get_node("CollisionShape2D").queue_free()
		
	# Posição inicial da escova demonstrativa
	escova_demo.position = Vector2(512, 650)
	
	executar_tutorial()

func executar_tutorial() -> void:
	# 1. Toca a instrução inicial: "Vamos aprender a jogar"
	Audios.tocar_instrucao("res://assets/audios/como_jogar/vamos_aprender_a_jogar.ogg")
	await get_tree().create_timer(2.5).timeout
	if tutorial_encerrado: return
	
	# 2. Explica o objetivo
	Audios.tocar_instrucao("res://assets/audios/tela_do_jogo_novo.mp3")
	await get_tree().create_timer(3.0).timeout
	if tutorial_encerrado: return
	
	# 3. Move a escova até o dente errado ("CA")
	var tween1 = create_tween()
	tween1.tween_property(escova_demo, "position", dente_errado.position + Vector2(20, -20), 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween1.finished
	if tutorial_encerrado: return
	
	# Simula escovação no dente errado (vai e vem)
	var tween_escova1 = create_tween()
	for i in range(4):
		tween_escova1.tween_property(escova_demo, "position", dente_errado.position + Vector2(-20, 10), 0.15)
		tween_escova1.tween_property(escova_demo, "position", dente_errado.position + Vector2(20, -20), 0.15)
	await tween_escova1.finished
	if tutorial_encerrado: return
	
	# Simula o erro
	feedback_label.text = "Tente outra!"
	feedback_label.modulate = Color(1.0, 0.4, 0.4)
	Audios.som_eletricidade("res://assets/audios/errou2.ogg")
	
	var tween_pisca = create_tween()
	for i in range(3):
		tween_pisca.tween_property(mouth_bg, "modulate", Color(1, 0.7, 0.7), 0.06)
		tween_pisca.tween_property(mouth_bg, "modulate", Color(1, 1, 1), 0.06)
	
	# O dente errado fica visualmente mais sujo
	dente_errado.dirt_level += 1
	dente_errado._update_visual()
	
	Audios.tocar_instrucao("res://assets/audios/como_jogar/tente_outra_vez.ogg")
	await get_tree().create_timer(3.0).timeout
	if tutorial_encerrado: return
	
	feedback_label.text = ""
	
	# 4. Move a escova até o dente correto ("BA")
	var tween2 = create_tween()
	tween2.tween_property(escova_demo, "position", dente_certo.position + Vector2(20, -20), 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween2.finished
	if tutorial_encerrado: return
	
	# Simula escovação no dente correto
	var tween_escova2 = create_tween()
	for i in range(5):
		tween_escova2.tween_property(escova_demo, "position", dente_certo.position + Vector2(-20, 10), 0.15)
		tween_escova2.tween_property(escova_demo, "position", dente_certo.position + Vector2(20, -20), 0.15)
	await tween_escova2.finished
	if tutorial_encerrado: return
	
	# Simula o acerto
	dente_certo.is_dirty = false
	dente_certo._update_visual()
	
	word_label.text = "BANANA"
	word_label.modulate = Color(0.3, 1.0, 0.3)
	
	feedback_label.text = "Muito bem!"
	feedback_label.modulate = Color(0.3, 1.0, 0.3)
	
	Audios.tocar_acertou()
	await get_tree().create_timer(1.0).timeout
	if tutorial_encerrado: return
	
	Audios.tocar_instrucao("res://assets/audios/como_jogar/voce_acertou.ogg")
	await get_tree().create_timer(2.5).timeout
	if tutorial_encerrado: return
	
	Audios.tocar_instrucao("res://assets/audios/como_jogar/sua_vez.ogg")
	await get_tree().create_timer(3.0).timeout
	if tutorial_encerrado: return
	
	# Transita para o jogo
	finalizar_tutorial()

func finalizar_tutorial() -> void:
	if tutorial_encerrado: return
	tutorial_encerrado = true
	get_tree().change_scene_to_file("res://scenes/escolha_personagem.tscn")

func _on_pular_tutorial_pressed() -> void:
	finalizar_tutorial()

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
