extends Control

var locos = 10
var esta_loco = false

@onready var medidor = $medidor
@onready var texto_contador = $Sprite2D/TextEdit


# Called when the node enters the scene tree for the first time.
func _ready():
	esta_loco = false
	medidor.value = 1
	var tween = create_tween()
	tween.tween_property(medidor, "value", locos, 2)

func _process(_delta):
	actualizar_medidor()

func suma_locos(locos_nuevos : int):
	locos += locos_nuevos
	if locos < 1:
		locos = 1
	Audio.play_medidor_cambio(locos - medidor.value)
	var tween = create_tween()
	tween.tween_property(medidor, "value", locos, 1)

func actualizar_medidor():
	texto_contador.text = str(medidor.value)
	if !esta_loco && medidor.value == 100:
		esta_loco = true
		medidor.texture_over = load("res://texturas/medidor/Medidor_Marco_CRAZY.png")
		Audio.play_medidor_estado_cambio(esta_loco)
	elif esta_loco && medidor.value == 99:
		esta_loco = false
		medidor.texture_over = load("res://texturas/medidor/Medidor_Marco.png")
		Audio.play_medidor_estado_cambio(esta_loco)
	
