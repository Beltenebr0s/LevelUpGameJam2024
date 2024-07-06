extends Control

var locos = 10
var esta_loco = false

@onready var medidor = $medidor
@onready var texto_contador = $Sprite2D/TextEdit


# Called when the node enters the scene tree for the first time.
func _ready():
	esta_loco = false
	medidor.value = 1
	actualizar_medidor()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func suma_locos(locos_nuevos : int):
	locos += locos_nuevos
	#if medidor.value > 100 and locos < 100:
	#	locos = 101
	if locos < 1:
		locos = 1
	actualizar_medidor()

func actualizar_medidor():
	while locos != medidor.value:
		medidor.value += sign(locos - medidor.value)
		texto_contador.text = str(medidor.value)
		if !esta_loco && medidor.value == 100:
			esta_loco = true
			medidor.texture_over = load("res://texturas/medidor/Medidor_Marco_CRAZY.png")
		elif esta_loco && medidor.value == 99:
			esta_loco = false
			medidor.texture_over = load("res://texturas/medidor/Medidor_Marco.png")
		await get_tree().create_timer(0.015).timeout
	
