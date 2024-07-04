extends Control

@export_multiline var texto_descripcion : String

var raton_dentro = false

@onready var descripcion = $Carta/descripcion
@onready var animador = $AnimationPlayer

signal accion()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Carta/descripcion/TextEdit.text = texto_descripcion
	visible = false
	descripcion.visible = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func mostrar_icono():
	animador.play_backwards("zoom")
	visible = true

func ocultar_icono():
	visible = false


func _on_boton_mouse_entered():
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
