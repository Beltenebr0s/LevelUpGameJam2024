extends Node2D

@onready var locos = 10
@onready var contador = 0
@onready var barra = $borde_exterior/barra_interior
@onready var texto_contador = $TextEdit


# Called when the node enters the scene tree for the first time.
func _ready():
	actualizar_medidor()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func suma_locos(locos_nuevos : int):
	locos += locos_nuevos
	if locos < 1:
		locos = 1
	actualizar_medidor()

func actualizar_medidor():
	while locos != contador:
		contador += sign(locos - contador)
		texto_contador.text = str(contador)
		barra.position = Vector2(0, 1 - float(contador)/100)
		await get_tree().create_timer(0.03).timeout
	
