extends ReferenceRect

@onready var descripcion = $descripcion
@onready var raton_dentro = false


# Called when the node enters the scene tree for the first time.
func _ready():
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


func _on_mouse_entered():
	raton_dentro = true
	await get_tree().create_timer(0.5).timeout
	if raton_dentro:
		descripcion.visible = true


func _on_mouse_exited():
	raton_dentro = false
	descripcion.visible = false
