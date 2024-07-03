extends Control

@export_multiline var texto_descripcion : String

@onready var descripcion = $descripcion
@onready var raton_dentro = false

signal accion()

# Called when the node enters the scene tree for the first time.
func _ready():
	$descripcion/TextEdit.text = texto_descripcion
	visible = false
	descripcion.visible = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func mostrar_icono():
	visible = true

func ocultar_icono():
	visible = false


func _on_boton_mouse_entered():
	raton_dentro = true
	await get_tree().create_timer(0.3).timeout
	if raton_dentro:
		descripcion.visible = true


func _on_boton_mouse_exited():
	raton_dentro = false
	descripcion.visible = false

func _on_boton_pressed():
	accion.emit()
