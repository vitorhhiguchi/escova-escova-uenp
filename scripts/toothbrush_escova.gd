extends Area2D

var is_brushing: bool = false
var start_rotation: float = 0.0
var overlapping_teeth: Array = []

@onready var sprite = $Sprite

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	# Textura padrão (masculina) já está definida na cena .tscn
	# Troca apenas se o personagem escolhido for feminino
	if Global.personagem_escolhido == "fem":
		sprite.texture = load("res://assets/escova/escava-de-dente-fem.png")
	
	# Salva a rotação que foi configurada no editor do Sprite
	start_rotation = sprite.rotation
		
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		is_brushing = true
	else:
		is_brushing = false
		
	if is_brushing:
		# Oscila levemente o sprite visualmente para dar a sensação de escovação
		sprite.rotation = start_rotation + sin(Time.get_ticks_msec() * 0.03) * 0.15
		
		var velocity = Input.get_last_mouse_velocity()
		if velocity.length() > 10:
			for tooth in overlapping_teeth:
				if tooth.has_method("brush_action"):
					tooth.brush_action(delta)
	else:
		sprite.rotation = lerp(sprite.rotation, start_rotation, delta * 12)

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("brush_action") and not overlapping_teeth.has(area):
		overlapping_teeth.append(area)

func _on_area_exited(area: Area2D) -> void:
	if overlapping_teeth.has(area):
		overlapping_teeth.erase(area)

func _exit_tree() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
