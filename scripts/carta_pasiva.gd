extends Control

@export_multiline var texto_descripcion : String
@export var sprite : Texture

var raton_dentro = false

@onready var descripcion = $Carta/descripcion
@onready var animador = $AnimationPlayer

signal accion()
signal carta_seleccionada

# Called when the node enters the scene tree for the first time.
func _ready():
	$Carta/descripcion/TextEdit.text = texto_descripcion
	$Carta.texture = sprite
	animador.play("zoom")
	visible = false
	descripcion.visible = false
	pass

func mostrar_icono():
	animador.play_backwards("zoom")
	visible = true

func ocultar_icono():
	visible = false

func _on_boton_mouse_entered():
	carta_seleccionada.emit()
	raton_dentro = true
	animador.play("zoom")
	await animador.animation_finished
	if raton_dentro:
		descripcion.visible = true

func _on_boton_mouse_exited():
	animador.play_backwards("zoom")
	raton_dentro = false
	descripcion.visible = false

func _on_boton_pressed():
	accion.emit()
