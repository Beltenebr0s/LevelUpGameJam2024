extends Control

@export_multiline var texto_descripcion : String
@export var sprite : Texture

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
	await animador.animation_finished
	descripcion.visible = true

func ocultar_icono():
	visible = false

func _on_boton_mouse_entered():
	carta_seleccionada.emit()
	animador.play("zoom")
	await animador.animation_finished

func _on_boton_mouse_exited():
	animador.play_backwards("zoom")

func _on_boton_pressed():
	accion.emit()
