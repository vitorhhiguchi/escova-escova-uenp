extends Node2D

var dentro_area = false

var errou = false

var salva_id_area = null

@export var id:int

signal soltou_area(id)
signal removeu_area(id)

func _process(_delta: float) -> void:
	if not Global.arrastando and dentro_area and not errou:
		soltou_area.emit(id)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if salva_id_area == null:
		salva_id_area = area.get_parent().get_parent().id
		dentro_area = true



func _on_area_2d_area_exited(area: Area2D) -> void:
	if salva_id_area == area.get_parent().get_parent().id:
		dentro_area = false
		salva_id_area = null
		errou = false
		$cor.hide()
		removeu_area.emit(id)


func _acertou():
	$Area2D.monitoring = false
	$cor.show()
	$cor.texture = load("res://assets/tomada/acerto.png")


func _errou():
	errou = true
	$cor.show()
	$cor.texture = load("res://assets/tomada/erro.png")


func desabilitar():
	$Area2D.monitoring = false
