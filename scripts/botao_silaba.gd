extends Node2D

#o mouse nao fica preso no centro do botao
var ajuste_posicao = Vector2(0,0)

var caminho_som
var este_botao_arrastando = false
var mouse_dentro = false

@export var id:int
signal enviar_id(id)


func _process(_delta: float) -> void:
	if Global.arrastando and este_botao_arrastando:
		$botao_tomada.global_position = get_global_mouse_position() - ajuste_posicao
	
	$fio.set_point_position(1, $botao_tomada.position-Vector2(-5,-29))


func _on_botao_tomada_button_down() -> void:
	$Timer.stop()
	este_botao_arrastando = true
	Global.arrastando = true
	ajuste_posicao = get_global_mouse_position() - $botao_tomada.global_position
	enviar_id.emit(id)
	Audios.som_eletricidade("res://assets/audios/som_eletricidade.ogg")


func _on_botao_tomada_button_up() -> void:
	este_botao_arrastando = false
	Global.arrastando = false
	Audios.som_eletricidade_parar()


func _on_area_silaba_mouse_entered() -> void:
	mouse_dentro = true
	$Timer.start()


func _on_area_silaba_mouse_exited() -> void:
	mouse_dentro = false
	$Timer.stop()


func desabilitar_botao():
	$botao_tomada.disabled = true
	Audios.audio_botao(caminho_som)


func desabilitar_botao_como_jogar():
	$botao_tomada.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_timer_timeout() -> void:
	Audios.tocar_audio(caminho_som, self)
	$Timer.stop()


func tocar_audio() -> void:
	Audios.audio_botao(caminho_som)


func is_mouse_inside() -> bool:
	return mouse_dentro
