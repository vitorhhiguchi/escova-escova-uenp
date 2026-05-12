extends Node2D

@onready var word_label = $UI/TopBar/WordLabel
@onready var score_label = $UI/TopBar/ScoreLabel
@onready var phase_label = $UI/TopBar/PhaseLabel
@onready var feedback_label = $UI/FeedbackLabel
@onready var teeth_container = $TeethContainer
@onready var mouth_bg = $MouthBackground
@onready var api_image_rect = $UI/ApiImagePanel/ApiImageRect
@onready var tooth_positions = $ToothPositions

var tooth_scene = preload("res://scenes/tooth_escova.tscn")
var current_target_syllable = ""
var current_word_data: Dictionary = {}

var current_phase: int = 1
var max_phases: int = 5
var game_finished: bool = false
var mouse_dentro = false

func _ready() -> void:
	Menu.telaInicial = false
	
	# Fundo e posições dos dentes já estão definidos na cena .tscn
	# (game_escova_masc.tscn ou game_escova_fem.tscn)
	
	current_phase = 1
	game_finished = false
	_update_score()
	_start_new_round()

func _start_new_round() -> void:
	if game_finished:
		return
		
	for child in teeth_container.get_children():
		child.queue_free()
		
	await get_tree().process_frame
	
	feedback_label.text = ""
	_update_phase_display()
	
	var word_data: Dictionary = {}
	if Global.array_silabas.size() > 0:
		var idx = (current_phase - 1) % Global.array_silabas.size()
		word_data = Global.array_silabas[idx]
	else:
		word_data = {
			"palavra": "BANANA",
			"silaba": "BA",
			"complemento_silaba": "_ _ NANA",
			"imagens": null,
			"som": null
		}
		
	current_word_data = word_data
	current_target_syllable = word_data.get("silaba", "BA")
	var palavra_inteira = word_data.get("palavra", "BANANA")
	var complemento = word_data.get("complemento_silaba", "")
	
	if complemento != "":
		word_label.text = complemento.strip_edges()
	else:
		word_label.text = palavra_inteira.replace(current_target_syllable, "_ _").strip_edges()
		
	word_label.modulate = Color(1, 1, 1)
	
	var imgs = word_data.get("imagens")
	if typeof(imgs) == TYPE_ARRAY and imgs.size() > 0 and imgs[0] != null:
		api_image_rect.texture = imgs[0]
	else:
		api_image_rect.texture = null
		
	if word_data.get("som") != null:
		$AudioPalavra.stream = word_data.som
		$AudioPalavra.play()
		
	var options = [current_target_syllable]
	var fallback_distratores = ["BA", "CA", "DA", "FA", "GA", "JA", "LA", "MA", "NA", "PA", "RA", "SA", "TA", "VA", "ZA"]
	fallback_distratores.shuffle()
	
	for f in fallback_distratores:
		if f != current_target_syllable and not options.has(f):
			options.append(f)
		if options.size() >= 4:
			break
			
	options.shuffle()
	
	var markers = tooth_positions.get_children()
	for i in range(min(4, markers.size())):
		var tooth = tooth_scene.instantiate()
		teeth_container.add_child(tooth)
		
		var target_pos = markers[i].position
		var target_rot = markers[i].rotation
		
		tooth.position = target_pos + Vector2(0, 40)
		tooth.rotation = target_rot
		tooth.base_rotation = target_rot
		tooth.modulate.a = 0.0
		
		var tween = create_tween().set_parallel(true)
		tween.tween_property(tooth, "position", target_pos, 0.4 + i * 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		tween.tween_property(tooth, "modulate:a", 1.0, 0.3 + i * 0.1)
		
		var is_correct = options[i] == current_target_syllable
		tooth.set_syllable(options[i], is_correct)
		tooth.tooth_brushed.connect(_on_tooth_brushed)

func _on_tooth_brushed(syllable: String, is_correct: bool, _node: Area2D) -> void:
	if is_correct:
		$TimerInstrucao.start()
		Global.Score += 34
		_update_score()
		
		word_label.text = current_word_data.get("palavra", "BANANA")
		word_label.modulate = Color(0.3, 1.0, 0.3)
		
		feedback_label.text = "Muito bem!"
		feedback_label.modulate = Color(0.3, 1.0, 0.3)
		
		Audios.tocar_acertou()
		
		for child in teeth_container.get_children():
			if child.has_node("CollisionShape2D"):
				child.get_node("CollisionShape2D").set_deferred("disabled", true)
				
		if current_phase < max_phases:
			current_phase += 1
			await get_tree().create_timer(1.5).timeout
			_start_new_round()
		else:
			game_finished = true
			phase_label.text = "⭐⭐⭐⭐⭐ COMPLETO!"
			await get_tree().create_timer(2.0).timeout
			get_tree().change_scene_to_file("res://scenes/fim_escova.tscn")
	else:
		Global.Score -= 2
		Global.erros += 1
		_update_score()
		
		feedback_label.text = "Tente outra!"
		feedback_label.modulate = Color(1.0, 0.4, 0.4)
		
		# Som de erro
		Audios.som_eletricidade("res://assets/audios/errou2.ogg")
		
		# Pisca vermelho como feedback de erro
		var tween_pisca = create_tween()
		for i in range(3):
			tween_pisca.tween_property(mouth_bg, "modulate", Color(1, 0.7, 0.7), 0.06)
			tween_pisca.tween_property(mouth_bg, "modulate", Color(1, 1, 1), 0.06)
		await tween_pisca.finished

func _update_score() -> void:
	score_label.text = "🌟 %d" % Global.Score

func _update_phase_display() -> void:
	var stars = ""
	for i in range(max_phases):
		if i < current_phase - 1:
			stars += "⭐"
		elif i == current_phase - 1:
			stars += "🔵"
		else:
			stars += "⚪"
	phase_label.text = stars + " Fase %d/%d" % [current_phase, max_phases]

func _on_timer_tempo_timeout() -> void:
	Global.TempoDeJogo_Sec += 1
	if Global.TempoDeJogo_Sec > 59:
		Global.TempoDeJogo_Min += 1
		Global.TempoDeJogo_Sec = 0

func _on_timer_instrucao_timeout() -> void:
	pass # Sem áudio repetitivo do jogo antigo

func is_mouse_inside() -> bool:
	return mouse_dentro
