extends Node

var como_jogar_scene = preload("res://scenes/como_jogar.tscn")
var instancia_como_jogar

var main_scene = preload("res://scenes/main.tscn")
var instancia_main


func _ready() -> void:
	_instancia_como_jogar()
	instancia_main = main_scene.instantiate()
	instancia_main.connect("_instancia_como_jogar", Callable(self, "_instancia_como_jogar"))


func _instancia_como_jogar() -> void:
	if get_node_or_null("main"):
		instancia_main.position = Vector2(1024,0)
	
	instancia_como_jogar = como_jogar_scene.instantiate()
	instancia_como_jogar.connect("ir_para_main", Callable(self, "ir_para_main"))
	add_child(instancia_como_jogar)


func ir_para_main() -> void:
	instancia_como_jogar.queue_free()
	instancia_main.position = Vector2(0,0)
	
	if get_node_or_null("main"):
		instancia_main.voltando_a_main()
		instancia_main.show()
	else:
		add_child(instancia_main)
