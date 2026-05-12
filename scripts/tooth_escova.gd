extends Area2D

signal tooth_brushed(syllable: String, is_correct: bool, node: Area2D)

var syllable: String = "BA"
var is_correct: bool = false
var is_dirty: bool = true
var brush_progress: float = 0.0
var dirt_level: int = 1

var base_rotation: float = 0.0
var wobble_time: float = 0.0

@onready var syllable_label = $SyllableLabel

func _ready() -> void:
	syllable_label.text = syllable
	wobble_time = randf_range(0, TAU)
	_update_visual()

func _process(delta: float) -> void:
	# Micro-animação suave de respiração/flutuação
	wobble_time += delta * 2.0
	rotation = base_rotation + sin(wobble_time) * 0.04

func set_syllable(new_syllable: String, correct: bool) -> void:
	syllable = new_syllable
	is_correct = correct
	if is_inside_tree():
		syllable_label.text = syllable

func _update_visual() -> void:
	if is_dirty:
		# Quanto mais sujo, mais escura/amarronzada fica a label
		var dark_factor = max(0.4, 1.0 - (dirt_level - 1) * 0.2)
		syllable_label.modulate = Color(dark_factor, dark_factor * 0.85, dark_factor * 0.6, 1.0)
	else:
		# Limpo: brilha branco
		syllable_label.modulate = Color(0.3, 1.0, 0.5, 1.0)

func brush_action(delta: float) -> void:
	if not is_dirty:
		return
		
	brush_progress += delta * 2.5
	_update_visual()
	
	if brush_progress >= 1.0:
		if is_correct:
			is_dirty = false
			_update_visual()
			# Desabilita colisões para não escovar mais de uma vez
			$CollisionShape2D.set_deferred("disabled", true)
			tooth_brushed.emit(syllable, true, self)
		else:
			# Errou: fica mais sujo e reinicia o progresso
			brush_progress = 0.0
			dirt_level += 1
			_update_visual()
			tooth_brushed.emit(syllable, false, self)
